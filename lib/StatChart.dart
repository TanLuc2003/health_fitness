import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class StatChart extends StatefulWidget {
  @override
  _StatChartState createState() => _StatChartState();
}

class _StatChartState extends State<StatChart> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int touchedIndex = -1;
  List<int> _stepsPerDay =
      List.filled(7, 0); // Giữ số bước cho mỗi ngày trong tuần

  @override
  void initState() {
    super.initState();
    _loadWeeklyStepData();
  }

  Future<void> _loadWeeklyStepData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DateTime now = DateTime.now();
        DateTime startOfWeek =
            now.subtract(Duration(days: now.weekday - 1)); // Thứ 2 của tuần

        for (int i = 0; i < 7; i++) {
          String dateStr = DateFormat('yyyy-MM-dd')
              .format(startOfWeek.add(Duration(days: i)));

          DocumentSnapshot doc = await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('daily_steps')
              .doc(dateStr)
              .get();

          if (doc.exists) {
            setState(() {
              _stepsPerDay[i] = doc['steps'] ?? 0;
            });
          }
        }
      }
    } catch (e) {
      print('Error loading weekly step data: $e');
    }
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 18,
  }) {
    // Các màu sắc khác nhau cho mỗi nhóm thanh
    List<Color> colors = [
      Colors.blue,
      Colors.blue,
      Colors.blue,
      Colors.blue,
      Colors.blue,
      Colors.blue,
      Colors.blue,
    ];

    barColor ??=
        colors[x % colors.length]; // Màu sắc của thanh thay đổi mỗi nhóm

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched
              ? Colors.white
              : barColor, // Khi chạm vào, thanh sẽ có màu trắng
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.white.withOpacity(0.8))
              : BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color:
                barColor.withOpacity(0.3), // Màu nền của thanh có màu nhạt hơn
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> showingGroups() {
    return List.generate(7, (i) {
      return makeGroupData(i, _stepsPerDay[i].toDouble());
    });
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${rod.toY}', // Hiển thị số bước
              const TextStyle(color: Colors.white),
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1; // Reset khi không có sự tương tác
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
        handleBuiltInTouches: true, // Đảm bảo bật tính năng chạm
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );
              if (value % 2000 == 0) {
                return Text('${value.toInt()}', style: style);
              }
              return Container();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 30,
          ),
        ),
      ),
      // Tăng padding cho biểu đồ
      borderData: FlBorderData(
        show: true,
        border: const Border(
          top: BorderSide.none,
          bottom: BorderSide(width: 1, color: Colors.black),
          left: BorderSide.none,
          right: BorderSide.none,
        ),
      ),
      gridData: FlGridData(show: false),
      barGroups: showingGroups(),
      maxY: 10000, // Đặt giá trị tối đa
      extraLinesData: ExtraLinesData(horizontalLines: [
        HorizontalLine(y: 10000, color: Colors.black, strokeWidth: 1),
      ]),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 0, 0, 0),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('M', style: style);
        break;
      case 1:
        text = const Text('T', style: style);
        break;
      case 2:
        text = const Text('W', style: style);
        break;
      case 3:
        text = const Text('T', style: style);
        break;
      case 4:
        text = const Text('F', style: style);
        break;
      case 5:
        text = const Text('S', style: style);
        break;
      case 6:
        text = const Text('S', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(axisSide: meta.axisSide, space: 8, child: text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bước chân trong tuần'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Biểu đồ bước chân trong tuần',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            _stepsPerDay.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('Đang tải dữ liệu...',
                          style: TextStyle(fontSize: 16)),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15), // Bo góc biểu đồ
                    child: Container(
                      height: 400, // Giảm chiều cao biểu đồ
                      child: BarChart(mainBarData()),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
