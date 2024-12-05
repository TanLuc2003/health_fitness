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
  String apiKey =
      '2c6b4939197f8f591bcf0d29e2d9859b'; // Thay bằng API Key của bạn
  String city = '';
  var currentWeather;
  var hourlyForecast;
  var dailyForecast;
  List<String> cities = []; // Danh sách các địa điểm từ API

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

  Future<void> fetchWeatherData(String city) async {
    try {
      String url =
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
      String forecastUrl =
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric';

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
        print('Phản hồi thời tiết: ${weatherResponse.body}');
        print('Phản hồi dự báo: ${forecastResponse.body}');
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
        print('Định vị hiện tại: ${placemarks[0]}');
        String newCity = placemarks[0].locality ?? '';
        setState(() {
          if (cities.contains(newCity)) {
            city = newCity;
          } else {
            city = cities.isNotEmpty
                ? cities[0]
                : ''; // Chọn thành phố đầu tiên hoặc giá trị mặc định
          }
        });
        fetchWeatherData(city);
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
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('E, dd/MM').format(date);
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
            : DropdownButton<String>(
                value: city.isEmpty ? null : city,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      city = newValue;
                    });
                    fetchWeatherData(newValue);
                  }
                },
                items: cities.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
        backgroundColor: Colors.blue,
      ),
      body: currentWeather == null ||
              hourlyForecast == null ||
              dailyForecast == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translateWeather(
                          currentWeather['weather'][0]['description']),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      formatTemperature(currentWeather['main']['temp']),
                      style:
                          TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Nhiệt độ cao nhất: ${formatTemperature(currentWeather['main']['temp_max'])} | Nhiệt độ thấp nhất: ${formatTemperature(currentWeather['main']['temp_min'])}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Dự báo 48 giờ',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: hourlyForecast.length,
                        itemBuilder: (context, index) {
                          var forecast = hourlyForecast[index];
                          return Container(
                            width: 100,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(formatTime(forecast['dt'])),
                                SizedBox(height: 10),
                                Text(formatTemperature(
                                    forecast['main']['temp'])),
                                SizedBox(height: 10),
                                Icon(Icons
                                    .wb_sunny), // Chỉnh icon theo thời tiết thực tế
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Dự báo 15 ngày',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Column(
                        children: dailyForecast.map<Widget>((forecast) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(formatDate(forecast['dt'])),
                                SizedBox(width: 10),
                                Text(formatTemperature(
                                    forecast['main']['temp'])),
                                SizedBox(width: 10),
                                Icon(Icons
                                    .wb_sunny), // Chỉnh icon theo thời tiết thực tế
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
