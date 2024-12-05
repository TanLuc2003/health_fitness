import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_fitness/BMIPage.dart';
import 'package:health_fitness/ExercisePage.dart';
import 'package:health_fitness/HeartRatePage.dart';
import 'package:health_fitness/Login.dart';
import 'package:health_fitness/NutritionPage.dart';
import 'package:health_fitness/SettingsPage.dart';
import 'package:health_fitness/StepCounter.dart';
import 'package:health_fitness/TrackingPage.dart';
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TrackingPage()));
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
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WeatherPage()));
                          },
                          child: Text(
                            'Thời tiết',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.favorite, color: Colors.red, size: 40),
                              SizedBox(height: 10),
                              Text(
                                'Hãy đo nhịp tim của bạn nào',
                                style: TextStyle(
                                  color: Colors.black,
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
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                        buildHealthCard(
                          context,
                          icon: Icons.food_bank,
                          title: 'Các chế độ ăn phù hợp',
                          value: '',
                          color: Colors.red[100]!,
                          page: NutritionPage(),
                        ),
                        buildHealthCard(
                          context,
                          icon: Icons.scale,
                          title: 'Cân nặng & chỉ số BMI',
                          value: '--- KG',
                          color: Colors.green[100]!,
                          page: WeightHeightInputPage(),
                        ),
                        buildHealthCard(
                          context,
                          icon: Icons.fitness_center,
                          title: 'Luyện tập thể chất',
                          value: 'Hãy tập luyện nào',
                          color: Colors.blue[100]!,
                          page: ExercisePage(),
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
        '/tracking': (context) => TrackingPage(),
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
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Stream<DocumentSnapshot> _getStepCountStream() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore.collection('users').doc(user.uid).snapshots();
    } else {
      throw Exception('User is not logged in');
    }
  }
}
