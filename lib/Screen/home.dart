import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_fitness/BMIPage.dart';
import 'package:health_fitness/DoctorAdviceScreen.dart';
import 'package:health_fitness/ExercisePage.dart';
import 'package:health_fitness/HeartRatePage.dart';
import 'package:health_fitness/Login.dart';
import 'package:health_fitness/NutritionPage.dart';
import 'package:health_fitness/SettingsPage.dart';
import 'package:health_fitness/StepCounter.dart';
import 'package:health_fitness/StatChart.dart';
import 'package:health_fitness/WeatherPage.dart';

class HomeContent extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 248, 215, 229),
          title: Row(
            children: [
              Text(
                "Health",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Fitness",
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text("Theo dõi hoạt động"),
                  value: 1,
                ),
                PopupMenuItem(
                  child: Text("Chế độ ăn"),
                  value: 2,
                ),
                PopupMenuItem(
                  child: Text("Tập luyện"),
                  value: 3,
                ),
                PopupMenuItem(
                  child: Text("Cài đặt"),
                  value: 4,
                ),
                PopupMenuItem(
                  child: Text("Đếm bước chân"),
                  value: 5,
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 1:
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => StatChart()));
                    break;
                  case 2:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NutritionPage()));
                    break;
                  case 3:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExercisePage()));
                    break;
                  case 4:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                    break;
                  case 5:
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => StepCounter()));
                    break;
                  default:
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                color: Color.fromARGB(255, 235, 248, 255),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'theo dõi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors
                                .white, // Màu nền của khung (bạn có thể thay đổi màu nền)
                            borderRadius: BorderRadius.circular(
                                30), // Tạo hình tròn cho khung
                            border: Border.all(
                              color: const Color.fromARGB(
                                  255, 40, 117, 231), // Màu của viền khung
                              width: 2, // Độ dày của viền
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WeatherPage()));
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize
                                  .min, // Đảm bảo chiều rộng của Row chỉ vừa đủ
                              children: [
                                Icon(
                                  Icons.cloud, // Biểu tượng đám mây
                                  color: const Color.fromARGB(
                                      255, 40, 117, 231), // Màu của icon
                                ),
                                SizedBox(
                                    width: 8), // Khoảng cách giữa icon và text
                                Text(
                                  'Thời tiết',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 40, 117, 231)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 250, 178,
                            178), // Màu nền mặc định nếu hình ảnh chưa load
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/nhiptim.png'), // Đường dẫn tới hình nền
                          fit: BoxFit
                              .cover, // Đảm bảo hình ảnh bao phủ toàn bộ Container
                          opacity: 0.3, // Độ mờ của hình nền, có thể điều chỉnh
                        ),
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Stack(
                        children: [
                          // Nội dung chính của bạn
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.favorite,
                                      color:
                                          const Color.fromARGB(255, 255, 17, 0),
                                      size: 40),
                                  SizedBox(height: 10),
                                  Text(
                                    'Hãy đo nhịp tim của bạn nào',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 241, 45, 45),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HeartRatePage()),
                                  );
                                },
                                child: Text('Đo ngay'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 248, 98, 98),
                                ),
                              ),
                            ],
                          ),
                          // Thêm lớp phủ (overlay) nếu cần thiết
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(
                                  0.2), // Lớp overlay để làm nổi bật nội dung
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nhật ký sức khỏe',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        StreamBuilder<DocumentSnapshot>(
                          stream: _getStepCountStream(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final stepCount = snapshot.data!['steps'];
                              return buildHealthCard(
                                context,
                                icon: Icons.directions_walk,
                                title: 'Bộ đếm bước',
                                value: stepCount.toString(),
                                color: Colors.blue[100]!,
                                page: StepCounter(),
                                image:
                                    'assets/buocchan.jpg', // Thêm hình ảnh nền
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                        buildHealthCard(
                          context,
                          icon: Icons.food_bank,
                          title: 'Chế độ ăn',
                          value: '',
                          color: Colors.red[100]!,
                          page: NutritionPage(),
                          image: 'assets/food.jpg', // Thêm hình ảnh nền
                        ),
                        buildHealthCard(
                          context,
                          icon: Icons.scale,
                          title: 'Chỉ số BMI',
                          value: '',
                          color: Colors.green[100]!,
                          page: WeightHeightInputPage(),
                          image: 'assets/BMI.jpg', // Thêm hình ảnh nền
                        ),
                        buildHealthCard(
                          context,
                          icon: Icons.fitness_center,
                          title: 'Luyện tập',
                          value: '',
                          color: Colors.blue[100]!,
                          page: ExercisePage(),
                          image: 'assets/fit.jpg', // Thêm hình ảnh nền
                        ),
                        buildHealthCard(
                          context,
                          icon: Icons.fitness_center,
                          title: 'Hoạt động của bạn',
                          value: '',
                          color: Colors.blue[100]!,
                          page: StatChart(),
                          image: 'assets/bieudo.jpg', // Thêm hình ảnh nền
                        ),
                        buildHealthCard(
                          context,
                          icon: Icons.healing,
                          title: 'Bác sĩ AI',
                          value: '',
                          color: Colors.blue[100]!, // Màu nền phía sau hình PNG
                          page: DoctorAdviceScreen(),
                          image: 'assets/BacsiAI.png',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      routes: {
        '/user_info': (context) => LoginPage(),
        '/tracking': (context) => StatChart(),
        '/nutri': (context) => NutritionPage(),
        '/exercise': (context) => ExercisePage(),
        '/setting': (context) => SettingsPage(),
        '/step': (context) => StepCounter(),
        '/weather': (context) => WeatherPage(),
      },
    );
  }

  Widget buildHealthCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Widget page,
    String? image, // Tham số cho hình ảnh nền
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: color, // Màu nền của thẻ
          borderRadius: BorderRadius.circular(10),
          image: image != null
              ? DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover, // Đảm bảo hình ảnh phủ kín
                )
              : null,
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.black
                .withOpacity(0.1), // Lớp overlay giúp nội dung dễ đọc
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 40,
                color:
                    const Color.fromARGB(255, 33, 207, 56), // Màu icon dễ đọc
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 94, 192, 38), // Màu chữ
                ),
              ),
              Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 2, 2), // Màu chữ
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<DocumentSnapshot> _getStepCountStream() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore.collection('users').doc(user.uid).snapshots();
    } else {
      return Stream.empty();
    }
  }
}
