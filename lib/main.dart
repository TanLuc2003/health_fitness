import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:health_fitness/FitnessCircular.dart';

import 'package:health_fitness/demo.dart';

// Import các trang
import 'Login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SplashScreen(),
      routes: {
        '/user_info': (context) => LoginPage(),
        '/home': (context) => FluidNavBarDemo(),
        // Trang home
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(
        Duration(seconds: 2)); // Tạm dừng 2 giây để hiển thị màn hình splash
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Người dùng đã đăng nhập
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      // Người dùng chưa đăng nhập
      Navigator.of(context).pushReplacementNamed('/user_info');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            FitnessCircularProgressIndicator(), // Thay thế CircularProgressIndicator bằng FitnessCircularProgressIndicator
      ),
    );
  }
}
