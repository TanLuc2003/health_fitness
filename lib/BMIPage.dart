import 'package:flutter/material.dart';
import 'package:health_fitness/BMIresultPage.dart';

class WeightHeightInputPage extends StatefulWidget {
  @override
  _WeightHeightInputPageState createState() => _WeightHeightInputPageState();
}

class _WeightHeightInputPageState extends State<WeightHeightInputPage> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhập Chỉ Số'),
        backgroundColor: Colors.blue, // Màu nền của thanh tiêu đề
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Cân nặng (kg)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Chiều cao (cm)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double weight = double.parse(_weightController.text);
                double height = double.parse(_heightController.text) / 100;

                double bmi = weight / (height * height);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultPage(
                      bmi: bmi,
                      weight: weight,
                      height: height * 100,
                    ),
                  ),
                );
              },
              child: Text('Tính BMI'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Màu nền của nút
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0), // Tạo độ cao nút
              ),
            ),
          ],
        ),
      ),
    );
  }
}
