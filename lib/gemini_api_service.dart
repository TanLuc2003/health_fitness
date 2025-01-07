import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiApiService {
  final String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
  final String apiKey =
      'AIzaSyCecHRNHKHLRd7WOZR-xT8bcL60XGYPObo'; // Thay thế bằng API Key của bạn
  List<Map<String, String>> conversationHistory = [];

  Future<String> getDoctorAdvice(String userInput) async {
    // Cập nhật lịch sử cuộc trò chuyện
    conversationHistory.add({'role': 'user', 'content': userInput});

    // Cấu trúc prompt để giới thiệu AI như một bác sĩ
    String prompt = '';
    for (var message in conversationHistory) {
      prompt +=
          '${message['role'] == 'user' ? 'User' : 'AI'}: ${message['content']}\n';
    }

    // Thêm vai trò bác sĩ cho AI
    prompt =
        'Bạn là một bác sĩ AI chuyên về sức khỏe. Hãy trả lời như một bác sĩ có kinh nghiệm. Dưới đây là cuộc trò chuyện:\n$prompt';

    prompt += 'AI: ';

    try {
      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "contents": [
            {
              "parts": [
                {
                  "text": prompt,
                }
              ]
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Response data: $responseData');

        // Lấy phản hồi từ AI
        String aiResponse = responseData['candidates'][0]['content']['parts'][0]
                ['text'] ??
            'Không có lời khuyên nào';
        conversationHistory.add({'role': 'ai', 'content': aiResponse});

        return aiResponse;
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        return 'Không thể nhận lời khuyên, vui lòng thử lại.';
      }
    } catch (error) {
      return 'Lỗi: $error';
    }
  }
}
