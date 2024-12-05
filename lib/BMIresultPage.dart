import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final double bmi;
  final double weight;
  final double height;

  ResultPage({required this.bmi, required this.weight, required this.height});

  @override
  Widget build(BuildContext context) {
    String bmiCategory;
    Color bmiColor;

    if (bmi < 18.5) {
      bmiCategory = 'Thiếu cân';
      bmiColor = Colors.yellow;
    } else if (bmi < 25) {
      bmiCategory = 'Bình thường';
      bmiColor = Colors.green;
    } else if (bmi < 30) {
      bmiCategory = 'Thừa cân';
      bmiColor = Colors.orange;
    } else {
      bmiCategory = 'Béo phì';
      bmiColor = Colors.red;
    }

    List<AdviceItem> adviceItems = [];
    if (bmi < 18.5) {
      adviceItems = [
        AdviceItem(
          title: 'Duy trì chế độ ăn uống cân bằng',
          subtitle:
              'Tiếp tục tuân theo chế độ ăn uống cân bằng giàu trái cây, rau, ngũ cốc nguyên hạt và protein nạc. Hạn chế tiêu thụ đường và thực phẩm chế biến để giúp giữ cân nặng ổn định và hỗ trợ sức khỏe tổng thể.',
        ),
        AdviceItem(
          title: 'Duy trì hoạt động thể chất',
          subtitle:
              'Tham gia vào các hoạt động thể chất thường xuyên, chẳng hạn như đi bộ, chạy bộ, đạp xe hoặc bất kỳ bài tập thể dục nào khác. Đặt mục tiêu tập thể dục ít nhất 150 phút mỗi tuần để tăng cường sức khỏe tim mạch và sức khỏe tổng thể.',
        ),
        AdviceItem(
          title: 'Theo dõi cân nặng của bạn',
          subtitle:
              'Theo dõi cân nặng của bạn để đảm bảo nó nằm trong phạm vi khỏe mạnh. Giảm thiểu sự tăng giảm đột ngột bằng cách duy trì chế độ ăn uống và thói quen tập thể dục đều đặn.',
        ),
        AdviceItem(
          title: 'Uống nhiều nước',
          subtitle:
              'Hãy chắc chắn bạn uống đủ nước hàng ngày, nước là một phần quan trọng của sức khỏe và giúp duy trì cân nặng cũng như giảm cảm giác đói.',
        ),
        AdviceItem(
          title: 'Nâng cao lượng protein',
          subtitle:
              'Bổ sung thêm protein vào chế độ ăn hàng ngày để giúp xây dựng cơ bắp và duy trì sức khỏe tổng thể.',
        ),
      ];
    } else if (bmi < 25) {
      adviceItems = [
        AdviceItem(
          title: 'Lời khuyên cho tình trạng bình thường',
          subtitle: 'Cảm ơn bạn đã duy trì cân nặng và sức khỏe tốt!',
        ),
        AdviceItem(
          title: 'Duy trì chế độ ăn uống lành mạnh',
          subtitle:
              'Tiếp tục duy trì chế độ ăn uống giàu dinh dưỡng và cân bằng, bao gồm đủ lượng rau, hoa quả, protein và chất béo lành mạnh.',
        ),
        AdviceItem(
          title: 'Tập thể dục đều đặn',
          subtitle:
              'Hãy tập thể dục ít nhất 30 phút mỗi ngày hoặc ít nhất 150 phút mỗi tuần. Kết hợp các bài tập cardio và tập luyện sức mạnh để duy trì sức khỏe toàn diện.',
        ),
        AdviceItem(
          title: 'Duy trì cân nặng',
          subtitle:
              'Theo dõi cân nặng và cân nhắc việc điều chỉnh chế độ ăn uống và lịch trình tập thể dục nếu cần thiết để duy trì cân nặng hiện tại.',
        ),
        AdviceItem(
          title: 'Đảm bảo đủ giấc ngủ',
          subtitle:
              'Ngủ đủ giấc hàng đêm để cơ thể có thời gian phục hồi và tái tạo, giúp duy trì sức khỏe cũng như cân nặng ổn định.',
        ),
      ];
    } else if (bmi < 30) {
      adviceItems = [
        AdviceItem(
          title: 'Lời khuyên cho tình trạng thừa cân',
          subtitle:
              'Bạn nên tập trung vào việc giảm cân và duy trì chế độ ăn uống lành mạnh.',
        ),
        AdviceItem(
          title: 'Giảm ăn đồ ngọt',
          subtitle:
              'Hạn chế tiêu thụ đồ ngọt và đồ uống có đường để giúp giảm cân và cải thiện sức khỏe tổng thể.',
        ),
        AdviceItem(
          title: 'Tăng cường hoạt động vận động',
          subtitle:
              'Tăng cường hoạt động thể chất hàng ngày để đốt cháy calo thừa và giảm cân hiệu quả.',
        ),
        AdviceItem(
          title: 'Ưu tiên thực phẩm giàu chất xơ',
          subtitle:
              'Thực phẩm giàu chất xơ giúp giảm cảm giác đói và cảm giác no lâu hơn, giúp bạn kiểm soát cân nặng hiệu quả hơn.',
        ),
        AdviceItem(
            title: 'Hạn chế đồ ăn chứa chất béo',
            subtitle:
                'Giảm lượng chất béo bão hòa và chất béo trong chế độ ăn hàng ngày để giảm cân và duy trì thể dục thể thao hằng ngày'),
        AdviceItem(
          title: 'Giảm cân một cách dần dần',
          subtitle:
              'Hãy thiết lập một mục tiêu giảm cân hợp lý và điều chỉnh chế độ ăn uống cùng với việc tăng cường hoạt động thể chất.',
        ),
      ];
    } else {
      adviceItems = [
        AdviceItem(
          title: 'Lời khuyên cho tình trạng béo phì',
          subtitle:
              'Cần tham khảo ý kiến bác sĩ và lập kế hoạch giảm cân và tập thể dục thích hợp.',
        ),
        AdviceItem(
          title: 'Giảm tiêu thụ calo',
          subtitle:
              'Hạn chế lượng calo hàng ngày và tăng cường hoạt động thể chất để giảm cân và cải thiện sức khỏe.',
        ),
        AdviceItem(
          title: 'Tìm kiếm sự hỗ trợ',
          subtitle:
              'Xem xét việc tham gia vào các nhóm hỗ trợ hoặc tìm kiếm sự hỗ trợ từ gia đình và bạn bè trong quá trình giảm cân.',
        ),
        AdviceItem(
          title: 'Hạn chế thức ăn nhanh',
          subtitle:
              'Tránh thức ăn nhanh và thực phẩm chế biến để giảm lượng calo không cần thiết và chất béo động vật.',
        ),
        AdviceItem(
          title: 'Duy trì tinh thần tích cực',
          subtitle:
              'Duy trì một tinh thần tích cực và kiên nhẫn trong quá trình giảm cân, và hãy nhớ rằng mục tiêu giảm cân cần thời gian và cố gắng.',
        ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả BMI'),
        backgroundColor: Colors.blue, // Màu nền cho AppBar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Colors.grey[400]!,
                    width: 1.0,
                  ), // Thêm border
                ),
                elevation: 4,
                color: Colors.white, // Đổi màu nền
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Cân nặng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4), // Điều chỉnh khoảng cách
                      Text(
                        '${weight.toStringAsFixed(1)} kg',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Chiều cao',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4), // Điều chỉnh khoảng cách
                      Text(
                        '${height.toStringAsFixed(1)} cm',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'BMI',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4), // Điều chỉnh khoảng cách
                      Text(
                        bmi.toStringAsFixed(1),
                        style: TextStyle(fontSize: 24, color: bmiColor),
                      ),
                      SizedBox(height: 10),
                      Text(
                        bmiCategory,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: bmiColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Lời khuyên độc quyền',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              // Hiển thị các lời khuyên dựa trên tình trạng BMI
              for (var advice in adviceItems) ...[
                SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  color: Colors.white, // Màu nền cho card
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          advice.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          advice.subtitle,
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AdviceItem {
  final String title;
  final String subtitle;

  AdviceItem({required this.title, required this.subtitle});
}
