import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_fitness/Login_Controller.dart';

class LoginPage extends StatelessWidget {
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Login",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Page",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
      body: Center(
        child: Obx(() {
          if (controller.googleAccount.value == null) {
            return buildLoginButton();
          } else {
            return buildProfileView();
          }
        }),
      ),
    );
  }

  Column buildProfileView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundImage:
              Image.network(controller.googleAccount.value?.photoUrl ?? '')
                  .image,
          radius: 100,
        ),
        Text(
          controller.googleAccount.value?.displayName ?? '',
          style: Get.textTheme.headlineSmall,
        ),
        Text(
          controller.googleAccount.value?.email ?? '',
          style: Get.textTheme.bodyMedium,
        ),
        SizedBox(
          height: 15,
        ),
        ActionChip(
          avatar: Icon(Icons.logout),
          label: Text('Đăng xuất'),
          onPressed: () {
            controller.logout();
          },
        ),
      ],
    );
  }

  FloatingActionButton buildLoginButton() {
    return FloatingActionButton.extended(
      onPressed: () async {
        await controller.login();
        if (controller.googleAccount.value != null) {
          Get.offAllNamed('/home');
        }
      },
      icon: Image.asset(
        'assets/logo_Google.jpg',
        height: 32,
        width: 32,
      ),
      label: Text('Đăng nhập bằng Google'),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    );
  }
}
