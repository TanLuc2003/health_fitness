import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<FlSpot> _monthlyStepsData = [];

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
    initPlatformState();
    _loadMonthlyStepsData();
    _resetStepsIfNewDay();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadMonthlyStepsData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DateTime now = DateTime.now();
        DateTime startOfMonth = DateTime(now.year, now.month, 1);

        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('steps')
            .where('timestamp', isGreaterThanOrEqualTo: startOfMonth)
            .orderBy('timestamp', descending: false)
            .get();

        List<FlSpot> monthlySteps = querySnapshot.docs.map((doc) {
          DateTime date = (doc['timestamp'] as Timestamp).toDate();
          int steps = doc['steps'];
          return FlSpot(date.day.toDouble(), steps.toDouble());
        }).toList();

        setState(() {
          _monthlyStepsData = monthlySteps;
        });
      }
    } catch (e) {
      print('Error loading monthly steps data: $e');
    }
  }

  void onStepCount(StepCount event) {
    setState(() {
      if (_initialSteps == 0) {
        _initialSteps = event.steps;
      }
      if (_isCounting) {
        _steps = event.steps - _initialSteps;
        _calculateMetrics();
        _saveStepCountToFirestore(_steps);
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
      _saveInitialStepsToFirestore(_initialSteps);
      _animationController.repeat();
    });
  }

  void stopCounting() {
    setState(() {
      _isCounting = false;
      _animationController.stop();
    });
  }

  void toggleCounting() {
    if (_isCounting) {
      stopCounting();
    } else {
      startCounting();
    }
  }

  Future<void> _saveStepCountToFirestore(int steps) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'steps': steps,
          'timestamp': Timestamp.now(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error saving steps to Firestore: $e');
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
    const double calPerStep = calPerKmWalked / avgStepLengthKm;

    double distance = _steps * avgStepLengthKm;
    double calories = _steps * calPerStep;

    int hours = _steps ~/ 2000; // Giả sử tốc độ đi bộ 2000 bước/giờ
    int minutes =
        ((_steps % 2000) * 3) ~/ 100; // Giả sử tốc độ đi bộ là 100 bước
    setState(() {
      _distanceInKm = distance;
      _caloriesBurned = calories;
      _timeWalked = '$hours:${minutes.toString().padLeft(2, '0')}';
    });
  }

  void _resetStepsIfNewDay() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          Timestamp lastResetTimestamp = userDoc['lastResetTimestamp'];
          DateTime now = DateTime.now();
          DateTime lastResetDate = DateTime.fromMillisecondsSinceEpoch(
              lastResetTimestamp.millisecondsSinceEpoch);
          if (lastResetDate.day != now.day) {
            // Reset steps
            _steps = 0;
            _initialSteps = 0;
            // Save last reset timestamp
            await _firestore.collection('users').doc(user.uid).set({
              'lastResetTimestamp': Timestamp.now(),
            }, SetOptions(merge: true));
          }
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
            SizedBox(height: 20),
            _buildMonthlyStepsChart(),
          ],
        ),
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

  Widget _buildMonthlyStepsChart() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Mục tiêu hàng ngày: $_dailyGoal',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              // Vòng tròn tiến độ của mục tiêu hàng ngày
              Container(
                width: 200, // Độ rộng của vòng tròn
                height: 200, // Độ cao của vòng tròn
                child: CircularProgressIndicator(
                  value: _steps / _dailyGoal,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
              // Các widget khác
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$_steps',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$_timeWalked', // Hiển thị thời gian đã đi
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${(_steps * 0.045).toStringAsFixed(2)} Kcal', // Tính calo dựa trên số bước
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
