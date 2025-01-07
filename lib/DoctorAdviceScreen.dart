import 'package:flutter/material.dart';
import 'gemini_api_service.dart';

class DoctorAdviceScreen extends StatefulWidget {
  @override
  _DoctorAdviceScreenState createState() => _DoctorAdviceScreenState();
}

class _DoctorAdviceScreenState extends State<DoctorAdviceScreen> {
  final TextEditingController _controller = TextEditingController();
  final GeminiApiService geminiApiService = GeminiApiService();
  bool _isLoading = false;

  // Hàm gọi API khi người dùng nhấn nút
  void _getAdvice() async {
    if (_controller.text.isEmpty) return;
    setState(() {
      _isLoading = true;
    });
    final String userInput = _controller.text;
    await geminiApiService.getDoctorAdvice(userInput);
    setState(() {
      _isLoading = false;
      _controller.clear(); // Xóa nội dung sau khi gửi
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bác sĩ AI',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Hiển thị lịch sử hội thoại
            Expanded(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: geminiApiService.conversationHistory.length,
                    itemBuilder: (context, index) {
                      final message =
                          geminiApiService.conversationHistory[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: message['role'] == 'user'
                              ? Colors.teal[50]
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: message['role'] == 'user'
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['role'] == 'user' ? 'Bạn' : 'Bác sĩ AI',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              message['content']!,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Nhập câu hỏi của người dùng
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nhập tin nhắn',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Nút gửi câu hỏi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _getAdvice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Gửi',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
