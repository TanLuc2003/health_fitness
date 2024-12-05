import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'Login_Controller.dart';

class SettingsPage extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Cài đặt tài khoản',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Thông tin cá nhân'),
              onTap: () {
                // Xử lý khi người dùng chọn cập nhật thông tin cá nhân
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Thay đổi mật khẩu'),
              onTap: () {
                // Xử lý khi người dùng chọn thay đổi mật khẩu
              },
            ),
            Divider(),
            Text(
              'Cài đặt ứng dụng',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Thông báo'),
              onTap: () {
                // Xử lý khi người dùng chọn cài đặt thông báo
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Ngôn ngữ'),
              onTap: () {
                // Xử lý khi người dùng chọn thay đổi ngôn ngữ
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('Chế độ tối'),
              onTap: () {
                // Xử lý khi người dùng chọn cài đặt chế độ tối
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Đăng xuất'),
              onTap: () {
                controller.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
