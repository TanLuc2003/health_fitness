import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String apiKey = '2c6b4939197f8f591bcf0d29e2d9859b';
  // Thay bằng API Key của bạn
  String city = '';
  var currentWeather;
  var hourlyForecast;
  var dailyForecast;
  List<String> cities = []; // Danh sách các địa điểm từ API
  String getWeatherIconUrl(String iconCode) {
    return 'http://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCities().then((_) {
      getLocation();
    });
  }

  Future<void> fetchCities() async {
    try {
      String citiesUrl =
          'https://api.openweathermap.org/data/2.5/group?id=1581130,1566083,1583992,1581297,1586203,1581047,1583477,1568770,1576633,1572151,1587919&appid=$apiKey&limit=1000000';
      final citiesResponse = await http.get(Uri.parse(citiesUrl));
      if (citiesResponse.statusCode == 200) {
        final List<dynamic> citiesData =
            json.decode(citiesResponse.body)['list'];
        if (citiesData != null && citiesData is List) {
          Set<String> uniqueCities = Set<String>();
          for (var city in citiesData) {
            if (city['name'] != null && city['name'] is String) {
              uniqueCities.add(city['name'].toString());
            }
          }
          setState(() {
            cities = uniqueCities.toList();
          });
        } else {
          print('Dữ liệu danh sách địa điểm không hợp lệ');
        }
      } else {
        print('Không thể tải danh sách địa điểm: ${citiesResponse.statusCode}');
        throw Exception('Không thể tải danh sách địa điểm');
      }
    } catch (e) {
      print('Lỗi: $e');
      throw Exception('Không thể tải danh sách địa điểm');
    }
  }

  Future<void> fetchWeatherData(double latitude, double longitude) async {
    try {
      // Sử dụng tọa độ để gọi API
      String url =
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';
      String forecastUrl =
          'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';

      final weatherResponse = await http.get(Uri.parse(url));
      final forecastResponse = await http.get(Uri.parse(forecastUrl));

      if (weatherResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        setState(() {
          currentWeather = json.decode(weatherResponse.body);
          hourlyForecast =
              json.decode(forecastResponse.body)['list'].sublist(0, 6);
          dailyForecast =
              json.decode(forecastResponse.body)['list'].sublist(0, 5);
        });
      } else {
        print(
            'Không tải được dữ liệu thời tiết: ${weatherResponse.statusCode}, ${forecastResponse.statusCode}');
        throw Exception('Không tải được dữ liệu thời tiết');
      }
    } catch (e) {
      print('Lỗi: $e');
      throw Exception('Không tải được dữ liệu thời tiết');
    }
  }

  Future<void> getLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        // In ra danh sách placemarks để kiểm tra dữ liệu trả về
        print('Placemark: $placemarks');

        // Kiểm tra và lấy thông tin theo cấu trúc: Street, Subadministrative area
        String locationName = placemarks.isNotEmpty
            ? (placemarks[0].street ?? '') +
                (placemarks[0].subAdministrativeArea != null
                    ? ', ${placemarks[0].subAdministrativeArea}'
                    : '')
            : "Vị trí không xác định";

        // Nếu không có thông tin, hiển thị Subadministrative area nếu có
        if (locationName.trim().isEmpty) {
          locationName = placemarks.isNotEmpty
              ? placemarks[0].subAdministrativeArea ??
                  placemarks[0].administrativeArea ??
                  "Vị trí không xác định"
              : "Vị trí không xác định";
        }

        print('Vị trí hiện tại: $locationName');

        // Cập nhật tên vị trí
        setState(() {
          city = locationName;
        });

        // Gọi API thời tiết với tọa độ
        fetchWeatherData(position.latitude, position.longitude);
      } catch (e) {
        print("Lỗi khi lấy vị trí hiện tại: $e");
      }
    } else {
      print("Quyền truy cập vị trí đã bị từ chối.");
    }
  }

  String formatTemperature(dynamic temp) {
    if (temp is int) {
      temp = temp.toDouble();
    }
    return '${temp.toStringAsFixed(1)}°C';
  }

  String formatTime(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('HH:mm').format(date);
  }

  String formatDate(int timestamp) {
    // Chuyển timestamp từ UTC sang thời gian địa phương
    var date =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true)
            .toLocal();

    // Debug: In ra thời gian dự báo và thời gian hiện tại
    print('Current Date: ${DateTime.now()}');
    print('Forecast Date: $date');

    var today = DateTime.now();
    var tomorrow = today.add(Duration(days: 1));
    var dayAfterTomorrow = today.add(Duration(days: 2));

    // Đặt lại thời gian của today, tomorrow và dayAfterTomorrow về 00:00:00 để chỉ so sánh ngày
    today = DateTime(today.year, today.month, today.day);
    tomorrow = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    dayAfterTomorrow = DateTime(
        dayAfterTomorrow.year, dayAfterTomorrow.month, dayAfterTomorrow.day);

    // So sánh với ngày hiện tại (today)
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Hôm nay';
    }

    // So sánh với ngày mai (tomorrow)
    if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Ngày mai';
    }

    // So sánh với ngày kia (dayAfterTomorrow)
    if (date.year == dayAfterTomorrow.year &&
        date.month == dayAfterTomorrow.month &&
        date.day == dayAfterTomorrow.day) {
      return 'Ngày kia';
    }

    // Nếu không phải hôm nay, ngày mai, hay ngày kia, hiển thị tên ngày trong tuần
    return DateFormat('EEEE', 'vi_VN').format(date); // Thứ 2, Thứ 3, ...
  }

  String translateWeather(String description) {
    switch (description.toLowerCase()) {
      case 'clear sky':
        return 'Trời quang';
      case 'few clouds':
        return 'Ít mây';
      case 'scattered clouds':
        return 'Mây rải rác';
      case 'broken clouds':
        return 'Mây đứt đoạn';
      case 'shower rain':
        return 'Mưa rào';
      case 'rain':
        return 'Mưa';
      case 'thunderstorm':
        return 'Dông';
      case 'snow':
        return 'Tuyết';
      case 'mist':
        return 'Sương mù';
      case 'overcast clouds':
        return 'Mây âm u';
      default:
        return description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: cities.isEmpty
            ? Text('Đang tải...')
            : Text(city.isEmpty && currentWeather != null
                ? currentWeather['name'] // Dùng tên thành phố từ API
                : 'Vị trí hiện tại'),
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
      ),
      body: currentWeather == null ||
              hourlyForecast == null ||
              dailyForecast == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 33, 150, 243),
                          const Color.fromARGB(255, 73, 234, 240)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Hiển thị tên thành phố hoặc "Vị trí hiện tại"
                          Text(
                            city.isEmpty ? 'Vị trí hiện tại' : city,
                            style: TextStyle(fontSize: 32, color: Colors.white),
                          ),
                          Text(
                            formatTemperature(currentWeather['main']['temp']),
                            style: TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            translateWeather(
                                currentWeather['weather'][0]['description']),
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dự báo giờ',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: hourlyForecast.length,
                            itemBuilder: (context, index) {
                              var forecast = hourlyForecast[index];
                              return Container(
                                width: 100,
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 90, 174, 230),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(formatTime(forecast['dt']),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255))),
                                    SizedBox(height: 10),
                                    Image.network(
                                      getWeatherIconUrl(
                                          forecast['weather'][0]['icon']),
                                      width: 50,
                                      height: 50,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                        formatTemperature(
                                            forecast['main']['temp']),
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white)),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Dự báo ngày',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 300,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: dailyForecast.length,
                            itemBuilder: (context, index) {
                              var forecast = dailyForecast[index];
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                elevation: 7,
                                color: const Color.fromARGB(255, 209, 227, 241),
                                shadowColor:
                                    const Color.fromARGB(255, 46, 122, 235),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(16),
                                  title: Text(formatDate(forecast['dt']),
                                      style: TextStyle(fontSize: 18)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        getWeatherIconUrl(
                                            forecast['weather'][0]['icon']),
                                        width: 50,
                                        height: 50,
                                      ),
                                      Text(
                                        'Temp: ${formatTemperature(forecast['main']['temp'])}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
