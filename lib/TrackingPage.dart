import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import để sử dụng DateFormat

class TrackingPage extends StatefulWidget {
  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  late int _todayStepCount;

  @override
  void initState() {
    super.initState();
    _loadTodayStepCount();
  }

  Future<void> _loadTodayStepCount() async {
    // Lấy ngày hiện tại dưới dạng chuỗi 'yyyy-MM-dd'
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Truy vấn Firestore để lấy số bước chân của ngày hiện tại
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('stepCounts')
        .where('date', isEqualTo: todayDate)
        .get();

    // Lặp qua các documents để tính tổng số bước chân
    int totalSteps = 0;
    querySnapshot.docs.forEach((doc) {
      totalSteps += (doc['steps'] as num)
          .toInt(); // Giả sử 'steps' là trường chứa số bước chân trong document
    });
    // Cập nhật giá trị của _todayStepCount
    setState(() {
      _todayStepCount = totalSteps;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theo dõi hoạt động'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Số bước chân hôm nay',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          _todayStepCount
                              .toString(), // Hiển thị số bước chân của ngày hiện tại
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          'Mục tiêu: 10,000', // Đổi thành mục tiêu thực tế của bạn
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Biểu đồ hoạt động',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 200,
                        child:
                            Placeholder(), // Thay bằng biểu đồ thực tế của bạn
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
