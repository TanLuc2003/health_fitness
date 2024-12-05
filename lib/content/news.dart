import 'package:flutter/material.dart';

// Lớp đại diện cho tin tức
class News {
  final String title;
  final String mainContent;
  final String imageUrl;

  News({
    required this.title,
    required this.mainContent,
    required this.imageUrl,
  });
}

class NewsList extends StatelessWidget {
  // Danh sách các tin tức
  final List<News> newsList = [
    News(
      title: '4 lưu ý cho người mới bắt đầu giảm cân trong năm mới',
      mainContent: '''
        Bước sang năm mới, nhiều người trong chúng ta thường hạ quyết tâm bắt đầu giảm cân nghiêm túc. Nhưng chỉ sau vài ngày, một số người nhận thấy hành trình đó không hề dễ dàng. Giảm cân có thể vừa thú vị, vừa đầy thử thách. Với những người mới bắt đầu, nó có thể khó khăn.

        Để việc giảm cân trong năm mới dễ dàng và thuận lợi hơn, mọi người hãy bắt đầu bằng những điều sau:
        <img src='assets/news_exercise.jpg'/>
        1. ĐẶT MỤC TIÊU THỰC TẾ:
          Một trong những bước đầu tiên trong hành trình giảm cân là đặt ra các mục tiêu thực tế và có khả năng đạt được. Thay vì cố gắng đạt được mục tiêu trong một tháng thì mọi người hãy tập trung vào việc thay đổi một cách từ từ và phù hợp với lối sống của mình, theo chuyên trang sức khỏe Verywell Health (Mỹ). Chẳng hạn, đặt mục tiêu thâm hụt hơn 500 calo mỗi ngày, tập hàng giờ liền hay giảm 3 - 5 kg/tháng có thể là quá mức, gây áp lực lớn lên cơ thể và khó đạt được. Thay vì vậy, mọi người nên áp dụng chế độ ăn lành mạnh, duy trì tập luyện đều đặn và dần dần nâng độ khó lên.

        2. THIẾT LẬP CHẾ ĐỘ ĂN UỐNG CÂN BẰNG:
          Với mục tiêu giảm cân bền vững thì không phải cứ cắt giảm thật nhiều calo là tốt. Thay vào đó, mọi người nên áp dụng chế độ ăn uống cân bằng với trái cây, rau củ, ngũ cốc nguyên hạt và thịt giàu protein. Chỉ cần hạn chế tinh bột trắng, đường và chất béo có hại, đồng thời thay thế bằng những món lành mạnh trên thì lượng calo nạp vào đã có thể giảm đáng kể.

        3. UỐNG ĐỦ NƯỚC:
          Uống đủ nước sẽ góp phần giúp kiểm soát cân nặng, tăng cường trao đổi chất và hỗ trợ các chức năng cơ thể khác nhau. Tuy nhiên, không ít người lại không uống đủ nước và bỏ qua lợi ích của thói quen này.
          <img src='assets/image_exercise_water.jpg'/>

        4. TẬP THỂ DỤC THƯỜNG XUYÊN:
          Tập luyện đều đặn là phần cơ bản của mọi kế hoạch giảm cân hiệu quả. Bạn có thể kết hợp các bài tập cardio, rèn luyện sức mạnh và sức bền để tăng cường thể lực tổng thể. Hãy bắt đầu có các hoạt động yêu thích dù đó là đi bộ, đạp xe, khiêu vũ hay yoga đều được, sau đó tăng dần cường độ và thời lượng lên, theo Verywell Health (Mỹ).        
        ''',
      imageUrl: 'assets/news_exercise.jpg',
    ),
    News(
      title: 'Sai lầm phổ biến khi đi bộ',
      mainContent: '''
        Đi bộ ít tốn sức, dễ dàng thực hiện và trở thành thói quen hằng ngày. Bài tập này mang lại nhiều lợi ích cho sức khỏe, bao gồm cải thiện tim mạch, tinh thần và năng lượng. Tuy nhiên, nhiều người đi bộ giảm cân thường vô tình mắc phải những sai lầm, ông Jarrod Nobbe, huấn luyện viên thể dục tại Mỹ, chia sẻ.
        <img src='assets/image_exercise_3.jpg'/>
        1. ĐI BỘ QUÁ ÍT:
          Mặc dù đi bộ có thể giúp đốt cháy calo, nhưng việc đi bộ vài lần một tuần thường không đủ để thấy được kết quả đáng kể. Chìa khóa để giảm cân hiệu quả thông qua đi bộ là bạn phải đi bộ đủ nhiều để tạo ra thâm hụt calo.
          Mục tiêu ít nhất 150 phút hoạt động cường độ vừa phải hoặc 75 phút hoạt động cường độ mạnh mỗi tuần. Nếu bạn mới bắt đầu, hãy tăng dần số bước đi hằng ngày và đặt mục tiêu khoảng 10.000 bước mỗi ngày, theo trang Eat This, Not That!.
        2. KHÔNG TĂNG CƯỜNG ĐỘ:
          Đi bộ với tốc độ thoải mái vẫn tốt hơn là không đi bộ, nhưng nếu mục tiêu của bạn là giảm cân, bạn cần phải tăng cường độ tập luyện. Điều này giúp bạn đốt cháy nhiều calo hơn và cải thiện sức khỏe tim mạch.

        3. BỎ QUA KHỞI ĐỘNG VÀ DÃN CƠ:
          Việc khởi động 5-10 phút có thể giúp tăng dần nhịp tim và chuẩn bị cơ bắp để đi bộ. Tương tự, việc giãn cơ sau khi đi bộ giúp nhịp tim trở lại bình thường và ngăn ngừa cứng cơ. Thực hiện đầy đủ khởi động và giãn cơ giúp tăng hiệu quả tập luyện, giảm nguy cơ chấn thương, hỗ trợ quá trình giảm cân hiệu quả.

        4. ĂN KHÔNG KHOA HỌC:
          Nhiều người tập trung đi bộ mà bỏ qua chế độ ăn, dẫn đến việc giảm cân không hiệu quả. Kết hợp đi bộ với chế độ ăn giàu rau củ, trái cây, protein nạc, ngũ cốc nguyên cám giúp cung cấp năng lượng, tạo thâm hụt calo cần thiết để giảm cân. Bạn cần hạn chế thực phẩm nhiều calo, đường, thực phẩm chế biến sẵn để đạt kết quả tốt nhất. 
          <img src='assets/uong-nuoc-3.jpg'/>
        5. KHÔNG UỐNG ĐỦ NƯỚC:
          Uống nước đầy đủ là yếu tố then chốt cho sức khỏe và hiệu quả tập luyện, đặc biệt khi đi bộ giảm cân. Nhiều người không uống đủ nước, dẫn đến mất nước, mệt mỏi. Bạn cần uống nước trước, trong và sau khi đi bộ, nhất là khi trời nóng. 

        6. ĐI GIÀY SAI CÁCH:
          Đi giày không phù hợp có thể gây khó chịu và dẫn đến chấn thương, cản trở việc duy trì thói quen đi bộ. Giày đi bộ chuyên dụng tạo sự ổn định và giảm nguy cơ đau chân, đau khớp.

        7. THIẾU BÀI TẬP TĂNG CƠ:
          Nhiều người chỉ tập đi bộ để giảm cân mà bỏ qua tập tăng cơ, dẫn đến hiệu quả giảm cân chậm. Bạn nên tập tăng cơ 2 lần/tuần giúp xây dựng cơ bắp, đốt cháy nhiều calo hơn, đẩy nhanh quá trình giảm cân.      
        
        8. NGHỈ NGƠI KHÔNG ĐỦ:
          Nhiều người tập luyện quá sức, bỏ qua thời gian nghỉ ngơi, dẫn đến giảm hiệu quả và nguy cơ chấn thương. Nghỉ ngơi đầy đủ giúp cơ bắp phục hồi, phát triển mạnh, cải thiện hiệu suất đi bộ và tránh kiệt sức.

        9. THIẾU KIÊN TRÌ:
          Nhiều người bỏ cuộc giữa chừng vì không kiên trì với lịch trình đi bộ, dẫn đến kết quả không như mong muốn. Vào những ngày bận rộn, bạn hãy cố gắng dành thời gian cho dù chỉ là một đoạn đi bộ ngắn để duy trì thói quen.
        ''',
      imageUrl: 'assets/image_exercise_3.jpg',
    ),
    News(
      title: 'Chàng trai đi bơi, tập gym giảm cân từ 230 kg còn 162 kg',
      mainContent: '''
        Bước sang năm mới, nhiều người trong chúng ta thường hạ quyết tâm bắt đầu giảm cân nghiêm túc. Nhưng chỉ sau vài ngày, một số người nhận thấy hành trình đó không hề dễ dàng. Giảm cân có thể vừa thú vị, vừa đầy thử thách. Với những người mới bắt đầu, nó có thể khó khăn.

        Để việc giảm cân trong năm mới dễ dàng và thuận lợi hơn, mọi người hãy bắt đầu bằng những điều sau:
        <img src='assets/news_exercise.jpg'/>
        1. ĐẶT MỤC TIÊU THỰC TẾ:
          Một trong những bước đầu tiên trong hành trình giảm cân là đặt ra các mục tiêu thực tế và có khả năng đạt được. Thay vì cố gắng đạt được mục tiêu trong một tháng thì mọi người hãy tập trung vào việc thay đổi một cách từ từ và phù hợp với lối sống của mình, theo chuyên trang sức khỏe Verywell Health (Mỹ). Chẳng hạn, đặt mục tiêu thâm hụt hơn 500 calo mỗi ngày, tập hàng giờ liền hay giảm 3 - 5 kg/tháng có thể là quá mức, gây áp lực lớn lên cơ thể và khó đạt được. Thay vì vậy, mọi người nên áp dụng chế độ ăn lành mạnh, duy trì tập luyện đều đặn và dần dần nâng độ khó lên.

        2. THIẾT LẬP CHẾ ĐỘ ĂN UỐNG CÂN BẰNG:
          Với mục tiêu giảm cân bền vững thì không phải cứ cắt giảm thật nhiều calo là tốt. Thay vào đó, mọi người nên áp dụng chế độ ăn uống cân bằng với trái cây, rau củ, ngũ cốc nguyên hạt và thịt giàu protein. Chỉ cần hạn chế tinh bột trắng, đường và chất béo có hại, đồng thời thay thế bằng những món lành mạnh trên thì lượng calo nạp vào đã có thể giảm đáng kể.

        3. UỐNG ĐỦ NƯỚC:
          Uống đủ nước sẽ góp phần giúp kiểm soát cân nặng, tăng cường trao đổi chất và hỗ trợ các chức năng cơ thể khác nhau. Tuy nhiên, không ít người lại không uống đủ nước và bỏ qua lợi ích của thói quen này.
          <img src='assets/image_exercise_water.jpg'/>

        4. TẬP THỂ DỤC THƯỜNG XUYÊN:
          Tập luyện đều đặn là phần cơ bản của mọi kế hoạch giảm cân hiệu quả. Bạn có thể kết hợp các bài tập cardio, rèn luyện sức mạnh và sức bền để tăng cường thể lực tổng thể. Hãy bắt đầu có các hoạt động yêu thích dù đó là đi bộ, đạp xe, khiêu vũ hay yoga đều được, sau đó tăng dần cường độ và thời lượng lên, theo Verywell Health (Mỹ).        
        ''',
      imageUrl: 'assets/image_exercise_4.jpg',
    ),
    News(
      title:
          'Ngày mới với tin tức sức khỏe: Uống cà phê bao nhiêu phút thì có tác dụng?',
      mainContent: '''
        Bước sang năm mới, nhiều người trong chúng ta thường hạ quyết tâm bắt đầu giảm cân nghiêm túc. Nhưng chỉ sau vài ngày, một số người nhận thấy hành trình đó không hề dễ dàng. Giảm cân có thể vừa thú vị, vừa đầy thử thách. Với những người mới bắt đầu, nó có thể khó khăn.

        Để việc giảm cân trong năm mới dễ dàng và thuận lợi hơn, mọi người hãy bắt đầu bằng những điều sau:
        <img src='assets/news_exercise.jpg'/>
        1. ĐẶT MỤC TIÊU THỰC TẾ:
          Một trong những bước đầu tiên trong hành trình giảm cân là đặt ra các mục tiêu thực tế và có khả năng đạt được. Thay vì cố gắng đạt được mục tiêu trong một tháng thì mọi người hãy tập trung vào việc thay đổi một cách từ từ và phù hợp với lối sống của mình, theo chuyên trang sức khỏe Verywell Health (Mỹ). Chẳng hạn, đặt mục tiêu thâm hụt hơn 500 calo mỗi ngày, tập hàng giờ liền hay giảm 3 - 5 kg/tháng có thể là quá mức, gây áp lực lớn lên cơ thể và khó đạt được. Thay vì vậy, mọi người nên áp dụng chế độ ăn lành mạnh, duy trì tập luyện đều đặn và dần dần nâng độ khó lên.

        2. THIẾT LẬP CHẾ ĐỘ ĂN UỐNG CÂN BẰNG:
          Với mục tiêu giảm cân bền vững thì không phải cứ cắt giảm thật nhiều calo là tốt. Thay vào đó, mọi người nên áp dụng chế độ ăn uống cân bằng với trái cây, rau củ, ngũ cốc nguyên hạt và thịt giàu protein. Chỉ cần hạn chế tinh bột trắng, đường và chất béo có hại, đồng thời thay thế bằng những món lành mạnh trên thì lượng calo nạp vào đã có thể giảm đáng kể.

        3. UỐNG ĐỦ NƯỚC:
          Uống đủ nước sẽ góp phần giúp kiểm soát cân nặng, tăng cường trao đổi chất và hỗ trợ các chức năng cơ thể khác nhau. Tuy nhiên, không ít người lại không uống đủ nước và bỏ qua lợi ích của thói quen này.
          <img src='assets/image_exercise_water.jpg'/>

        4. TẬP THỂ DỤC THƯỜNG XUYÊN:
          Tập luyện đều đặn là phần cơ bản của mọi kế hoạch giảm cân hiệu quả. Bạn có thể kết hợp các bài tập cardio, rèn luyện sức mạnh và sức bền để tăng cường thể lực tổng thể. Hãy bắt đầu có các hoạt động yêu thích dù đó là đi bộ, đạp xe, khiêu vũ hay yoga đều được, sau đó tăng dần cường độ và thời lượng lên, theo Verywell Health (Mỹ).        
        ''',
      imageUrl: 'assets/image_exercise_5.jpg',
    ),
    News(
      title: 'Mẹo ăn cơm giúp giảm cân',
      mainContent: '''
        Bước sang năm mới, nhiều người trong chúng ta thường hạ quyết tâm bắt đầu giảm cân nghiêm túc. Nhưng chỉ sau vài ngày, một số người nhận thấy hành trình đó không hề dễ dàng. Giảm cân có thể vừa thú vị, vừa đầy thử thách. Với những người mới bắt đầu, nó có thể khó khăn.

        Để việc giảm cân trong năm mới dễ dàng và thuận lợi hơn, mọi người hãy bắt đầu bằng những điều sau:
        <img src='assets/news_exercise.jpg'/>
        1. ĐẶT MỤC TIÊU THỰC TẾ:
          Một trong những bước đầu tiên trong hành trình giảm cân là đặt ra các mục tiêu thực tế và có khả năng đạt được. Thay vì cố gắng đạt được mục tiêu trong một tháng thì mọi người hãy tập trung vào việc thay đổi một cách từ từ và phù hợp với lối sống của mình, theo chuyên trang sức khỏe Verywell Health (Mỹ). Chẳng hạn, đặt mục tiêu thâm hụt hơn 500 calo mỗi ngày, tập hàng giờ liền hay giảm 3 - 5 kg/tháng có thể là quá mức, gây áp lực lớn lên cơ thể và khó đạt được. Thay vì vậy, mọi người nên áp dụng chế độ ăn lành mạnh, duy trì tập luyện đều đặn và dần dần nâng độ khó lên.

        2. THIẾT LẬP CHẾ ĐỘ ĂN UỐNG CÂN BẰNG:
          Với mục tiêu giảm cân bền vững thì không phải cứ cắt giảm thật nhiều calo là tốt. Thay vào đó, mọi người nên áp dụng chế độ ăn uống cân bằng với trái cây, rau củ, ngũ cốc nguyên hạt và thịt giàu protein. Chỉ cần hạn chế tinh bột trắng, đường và chất béo có hại, đồng thời thay thế bằng những món lành mạnh trên thì lượng calo nạp vào đã có thể giảm đáng kể.

        3. UỐNG ĐỦ NƯỚC:
          Uống đủ nước sẽ góp phần giúp kiểm soát cân nặng, tăng cường trao đổi chất và hỗ trợ các chức năng cơ thể khác nhau. Tuy nhiên, không ít người lại không uống đủ nước và bỏ qua lợi ích của thói quen này.
          <img src='assets/image_exercise_water.jpg'/>

        4. TẬP THỂ DỤC THƯỜNG XUYÊN:
          Tập luyện đều đặn là phần cơ bản của mọi kế hoạch giảm cân hiệu quả. Bạn có thể kết hợp các bài tập cardio, rèn luyện sức mạnh và sức bền để tăng cường thể lực tổng thể. Hãy bắt đầu có các hoạt động yêu thích dù đó là đi bộ, đạp xe, khiêu vũ hay yoga đều được, sau đó tăng dần cường độ và thời lượng lên, theo Verywell Health (Mỹ).        
        ''',
      imageUrl: 'assets/image_exercise_6.jpg',
    ),
    News(
      title: 'Giảm ăn tinh bột tác động đến giấc ngủ như thế nào?',
      mainContent: '''
        Bước sang năm mới, nhiều người trong chúng ta thường hạ quyết tâm bắt đầu giảm cân nghiêm túc. Nhưng chỉ sau vài ngày, một số người nhận thấy hành trình đó không hề dễ dàng. Giảm cân có thể vừa thú vị, vừa đầy thử thách. Với những người mới bắt đầu, nó có thể khó khăn.

        Để việc giảm cân trong năm mới dễ dàng và thuận lợi hơn, mọi người hãy bắt đầu bằng những điều sau:
        <img src='assets/news_exercise.jpg'/>
        1. ĐẶT MỤC TIÊU THỰC TẾ:
          Một trong những bước đầu tiên trong hành trình giảm cân là đặt ra các mục tiêu thực tế và có khả năng đạt được. Thay vì cố gắng đạt được mục tiêu trong một tháng thì mọi người hãy tập trung vào việc thay đổi một cách từ từ và phù hợp với lối sống của mình, theo chuyên trang sức khỏe Verywell Health (Mỹ). Chẳng hạn, đặt mục tiêu thâm hụt hơn 500 calo mỗi ngày, tập hàng giờ liền hay giảm 3 - 5 kg/tháng có thể là quá mức, gây áp lực lớn lên cơ thể và khó đạt được. Thay vì vậy, mọi người nên áp dụng chế độ ăn lành mạnh, duy trì tập luyện đều đặn và dần dần nâng độ khó lên.

        2. THIẾT LẬP CHẾ ĐỘ ĂN UỐNG CÂN BẰNG:
          Với mục tiêu giảm cân bền vững thì không phải cứ cắt giảm thật nhiều calo là tốt. Thay vào đó, mọi người nên áp dụng chế độ ăn uống cân bằng với trái cây, rau củ, ngũ cốc nguyên hạt và thịt giàu protein. Chỉ cần hạn chế tinh bột trắng, đường và chất béo có hại, đồng thời thay thế bằng những món lành mạnh trên thì lượng calo nạp vào đã có thể giảm đáng kể.

        3. UỐNG ĐỦ NƯỚC:
          Uống đủ nước sẽ góp phần giúp kiểm soát cân nặng, tăng cường trao đổi chất và hỗ trợ các chức năng cơ thể khác nhau. Tuy nhiên, không ít người lại không uống đủ nước và bỏ qua lợi ích của thói quen này.
          <img src='assets/image_exercise_water.jpg'/>

        4. TẬP THỂ DỤC THƯỜNG XUYÊN:
          Tập luyện đều đặn là phần cơ bản của mọi kế hoạch giảm cân hiệu quả. Bạn có thể kết hợp các bài tập cardio, rèn luyện sức mạnh và sức bền để tăng cường thể lực tổng thể. Hãy bắt đầu có các hoạt động yêu thích dù đó là đi bộ, đạp xe, khiêu vũ hay yoga đều được, sau đó tăng dần cường độ và thời lượng lên, theo Verywell Health (Mỹ).        
        ''',
      imageUrl: 'assets/image_exercise_7.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).size.aspectRatio > 1;
    var columnCount = isLandscape ? 3 : 2;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: GridView.builder(
        itemCount: newsList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (BuildContext context, int index) {
          final News news = newsList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailScreen(news: news),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(8)),
                    child: Image.asset(
                      news.imageUrl,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          news.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  final News news;

  const NewsDetailScreen({Key? key, required this.news}) : super(key: key);

  List<InlineSpan> _parseContent(String content) {
    List<InlineSpan> spans = [];
    RegExp exp = RegExp(r"<img src='(.*?)'/>");
    Iterable<RegExpMatch> matches = exp.allMatches(content);

    int lastMatchEnd = 0;
    for (var match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: content.substring(lastMatchEnd, match.start)));
      }
      spans.add(WidgetSpan(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Image.asset(match.group(1)!),
        ),
      ));
      lastMatchEnd = match.end;
    }
    if (lastMatchEnd < content.length) {
      spans.add(TextSpan(text: content.substring(lastMatchEnd)));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết tin tức'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  children: _parseContent(news.mainContent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
