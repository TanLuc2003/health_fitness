import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart'; // Thêm gói flutter_map
import 'package:latlong2/latlong.dart'; // Thêm gói latlong2

class StepCounter extends StatefulWidget {
  @override
  _StepCounterState createState() => _StepCounterState();
}

class _StepCounterState extends State<StepCounter>
    with SingleTickerProviderStateMixin {
  late Stream<StepCount> _stepCountStream;
  int _steps = 0;
  int _initialSteps = 0;
  bool _isCounting = false;
  int _dailyGoal = 6000;
  late AnimationController _animationController;
  late MapController _mapController;
  StreamSubscription<Position>? _positionStreamSubscription;
  List<LatLng> _routePoints = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  LatLng _currentPosition = LatLng(51.5, -0.09);

  double _distanceInKm = 0.0;
  double _caloriesBurned = 0.0;
  String _timeWalked = '0:00';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..stop();
    _loadInitialStepsFromFirestore();
    _loadMetricsFromFirestore();
    initPlatformState();
    _resetStepsIfNewDay();
    _mapController = MapController();
    _currentPosition = LatLng(0, 0);
    _startLocationUpdates();
    _loadRouteFromFirestore();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _goToCurrentLocation() {
    // Đảm bảo vị trí được cập nhật
    if (_currentPosition != null) {
      _mapController.move(
          _currentPosition, 13.0); // Cập nhật trung tâm và zoom của bản đồ
    }
  }

  void _startLocationUpdates() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Dịch vụ vị trí không được bật.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Quyền vị trí bị từ chối.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Quyền vị trí bị từ chối vĩnh viễn.');
      return;
    }

    // Lấy vị trí hiện tại
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    // Di chuyển bản đồ đến vị trí hiện tại
    _goToCurrentLocation();

    // Lắng nghe vị trí thay đổi
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5, // Chỉ cập nhật khi di chuyển >= 5m
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        if (_isCounting) {
          _routePoints.add(_currentPosition); // Thêm điểm vào tuyến đường
        }
        _mapController.move(_currentPosition, 13.0);
      });
    });
  }

  void onStepCount(StepCount event) {
    setState(() {
      if (_initialSteps == 0) {
        _initialSteps = event.steps;
      }
      if (_isCounting) {
        _steps = event.steps - _initialSteps + _steps;
        _initialSteps = event.steps;
        _calculateMetrics();
        _saveStepCountToFirestore(_steps, _distanceInKm, _timeWalked);
      }
    });
  }

  void onStepCountError(error) {
    setState(() {
      _steps = 0;
    });
  }

  Future<void> initPlatformState() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);
    } else {
      setState(() {
        _steps = 0;
      });
    }
  }

  void startCounting() {
    setState(() {
      _isCounting = true;
      _routePoints.clear(); // Reset các điểm tuyến đường
      _routePoints.add(_currentPosition); // Thêm điểm bắt đầu
      _animationController.repeat();
    });
  }

  void stopCounting() {
    setState(() {
      _isCounting = false;
      _animationController.stop();
    });
    saveRouteToFirestore(_routePoints
        .map((point) =>
            {'latitude': point.latitude, 'longitude': point.longitude})
        .toList());
  }

  void toggleCounting() {
    if (_isCounting) {
      stopCounting();
    } else {
      startCounting();
    }
  }

  Future<void> _saveStepCountToFirestore(
      int steps, double distance, String timeWalked) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Cập nhật tổng số bước, khoảng cách, và thời gian vào document chính của người dùng
        await _firestore.collection('users').doc(user.uid).set({
          'steps': steps,
          'distance': distance,
          'timeWalked': timeWalked,
          'calories': _caloriesBurned,
          'timestamp': Timestamp.now(),
        }, SetOptions(merge: true));

        // Lưu số bước của ngày hiện tại vào collection 'daily_steps'
        String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('daily_steps')
            .doc(currentDate)
            .set({
          'steps': steps,
          'distance': distance,
          'calories': _caloriesBurned,
          'timeWalked': timeWalked,
          'timestamp': Timestamp.now(),
        });
      }
    } catch (e) {
      print('Error saving steps to Firestore: $e');
    }
  }

  Future<void> _loadMetricsFromFirestore() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          if (data.containsKey('distance')) {
            setState(() {
              _distanceInKm = data['distance'] ?? 0.0;
            });
          }
          if (data.containsKey('timeWalked')) {
            setState(() {
              _timeWalked = data['timeWalked'] ?? '0:00';
            });
          }
        }
      }
    } catch (e) {
      print('Error loading metrics from Firestore: $e');
    }
  }

  void getRouteFromFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('routes')
            .doc(currentDate)
            .get();

        if (doc.exists) {
          List<dynamic> route = doc['route'];
          // Hiển thị route ở đây
          print(route);
        }
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  Future<void> _saveInitialStepsToFirestore(int initialSteps) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'initialSteps': initialSteps,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error saving initial steps to Firestore: $e');
    }
  }

  Future<void> _loadInitialStepsFromFirestore() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          if (data.containsKey('steps')) {
            _steps = data['steps'];
          } else {
            _steps = 0;
          }
          if (data.containsKey('initialSteps')) {
            _initialSteps = data['initialSteps'];
          } else {
            _initialSteps = 0;
          }

          setState(() {});
        }
      }
    } catch (e) {
      print('Error loading initial steps from Firestore: $e');
    }
  }

  void _calculateMetrics() {
    const double avgStepLengthKm =
        0.000762; // Chiều dài trung bình của mỗi bước bộ
    const double calPerKmWalked =
        0.05; // Số calo tiêu hao cho mỗi kilômét đi bộ
    const double calPerStep = 0.05 / 1.0;

    double distance = _steps * avgStepLengthKm;
    double calories = _steps * 0.04;

    int hours = _steps ~/ 2000; // Giả sử tốc độ đi bộ 2000 bước/giờ
    int minutes =
        ((_steps % 2000) * 3) ~/ 100; // Giả sử tốc độ đi bộ là 100 bước

    setState(() {
      _distanceInKm = distance;
      _caloriesBurned = calories;
      _timeWalked = '$hours:${minutes.toString().padLeft(2, '0')}';
    });

    // Lưu lại số calo, khoảng cách và thời gian vào Firestore
    _saveMetricsToFirestore(distance, calories, hours, minutes);
  }

  Future<void> _saveMetricsToFirestore(
      double distance, double calories, int hours, int minutes) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'distance': distance,
          'calories': calories,
          'timeWalked': '$hours:${minutes.toString().padLeft(2, '0')}',
          'timestamp': Timestamp.now(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error saving metrics to Firestore: $e');
    }
  }

  void saveRouteToFirestore(List<Map<String, dynamic>> route) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('routes')
            .doc(currentDate)
            .update({
          'route': route, // Lưu tuyến đường vào document
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error saving route: $e');
    }
  }

  Future<void> _loadRouteFromFirestore() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

        // Lấy tuyến đường đã lưu trong Firestore
        DocumentSnapshot routeDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('routes')
            .doc(currentDate)
            .get();

        if (routeDoc.exists) {
          List<dynamic> routeData = routeDoc['route'] ?? [];
          List<LatLng> loadedRoutePoints = routeData
              .map((data) => LatLng(data['latitude'], data['longitude']))
              .toList();

          setState(() {
            _routePoints = loadedRoutePoints; // Cập nhật tuyến đường
          });
        }
      }
    } catch (e) {
      print('Error loading route from Firestore: $e');
    }
  }

  void _resetStepsIfNewDay() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          Timestamp? lastResetTimestamp = data['lastResetTimestamp'];

          DateTime now = DateTime.now();
          if (lastResetTimestamp == null ||
              DateTime.fromMillisecondsSinceEpoch(
                          lastResetTimestamp.millisecondsSinceEpoch)
                      .day !=
                  now.day) {
            // Reset steps và tuyến đường
            setState(() {
              _steps = 0;
              _initialSteps = 0;
              _routePoints.clear(); // Làm mới danh sách tuyến đường
            });

            // Tạo document mới trong daily_steps cho ngày hôm nay
            String currentDate = DateFormat('yyyy-MM-dd').format(now);
            await _firestore
                .collection('users')
                .doc(user.uid)
                .collection('daily_steps')
                .doc(currentDate)
                .set({
              'steps': 0,
              'distance': 0.0,
              'calories': 0.0,
              'timeWalked': '0:00',
              'timestamp': Timestamp.now(),
            });

            // Update Firestore với timestamp mới
            await _firestore.collection('users').doc(user.uid).update({
              'steps': 0,
              'lastResetTimestamp': Timestamp.now(),
            });
          }
        } else {
          // Nếu người dùng không tồn tại, có thể là lỗi hoặc user chưa được khởi tạo đúng
          print("User data not found in Firestore.");
        }
      }
    } catch (e) {
      print('Error resetting steps: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bộ Đếm Bước'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStepsTile(),
            SizedBox(height: 20),
            _buildMetricsCard(),
            SizedBox(height: 20),
            _buildStartStopButton(),
            SizedBox(height: 30), // Khoảng cách cho bản đồ
            _buildMap(), // Thêm widget bản đồ vào đây
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return Container(
      height: 300,
      child: _currentPosition == null
          ? Center(child: CircularProgressIndicator()) // Hiển thị chờ
          : Stack(
              children: [
                // Bản đồ
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter:
                        _currentPosition, // Cập nhật vị trí trung tâm của bản đồ
                    initialZoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _currentPosition, // Vị trí bạn muốn đánh dấu
                          width: 80.0, // Độ rộng của marker
                          height: 80.0, // Độ cao của marker
                          child: Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40.0,
                          ), // Sử dụng widget làm child cho marker
                        ),
                      ],
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _routePoints,
                          strokeWidth: 4.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ],
                ),
                // Nút bấm quay lại vị trí hiện tại
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(Icons.my_location, size: 30, color: Colors.blue),
                    onPressed: () {
                      // Cập nhật lại trung tâm bản đồ và di chuyển đến vị trí hiện tại
                      _mapController.move(_currentPosition, 13.0);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStepsTile() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            'Số bước hiện tại',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            '$_steps',
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildMetricRow(
              Icons.local_fire_department,
              'Calo',
              '${(_steps * 0.045).toStringAsFixed(2)} Kcal',
            ),
            _buildMetricRow(Icons.directions_walk, 'Khoảng cách',
                '${_distanceInKm.toStringAsFixed(2)} km'),
            _buildMetricRow(Icons.timer, 'Thời gian đi bộ', '$_timeWalked'),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 24),
            SizedBox(width: 10),
            Text(label),
          ],
        ),
        Text(value),
      ],
    );
  }

  Widget _buildStartStopButton() {
    return ElevatedButton(
      onPressed: toggleCounting,
      child: Text(_isCounting ? 'Dừng' : 'Bắt đầu'),
    );
  }
}
