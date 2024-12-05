import 'package:flutter/material.dart';

class Exercise {
  final String name;
  final String imagePath;
  final String description;

  Exercise({
    required this.name,
    required this.imagePath,
    required this.description,
  });
}

class ExerciseDetailPage extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailPage({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết bài tập'),
        backgroundColor: Color.fromARGB(255, 203, 234, 248),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              exercise.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Image.asset(
              exercise.imagePath,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              'Hướng dẫn:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  exercise.description,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExercisePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Exercise> exercises = [
      Exercise(
        name: 'Plank',
        imagePath: 'assets/plank.jpg',
        description: '''
          - Bạn hãy bắt đầu ngày đầu tiên với một tư thế plank cẳng tay hay còn gọi là plank thấp cơ bản.
          BƯỚC 1: Bạn đặt cẳng tay lên thảm và điều chỉnh sao cho khuỷu tay nằm thẳng hàng dưới vai. Hai cánh tay song song với cơ thể và cách nhau một khoảng ngang vai. Bạn có thể chắp tay lại để thoải mái hơn hoặc úp hai tay xuống sàn
          BƯỚC 2: Chú ý giữ đầu thẳng hàng với lưng và siết chặt cơ bụng. Nếu không chắc đầu và lưng đã thẳng hàng chưa, bạn có thể điều chỉnh bằng cách nhìn vào một điểm trên sàn trước hai tay khoảng 30 cm
          BƯỚC 3: Giữ nguyên tư thế trong 20 giây.

          - Khi bạn đã quen bài plank cẳng tay, hãy tiếp tục thử thách mình với động tác plank một chân.
          BƯỚC 1: Bạn hãy lập lại tất cả các bước plank cẳng tay rồi nâng một chân lên trời cao hết sức có thể
          BƯỚC 2: Sau khi nâng một chân, bạn hạ chân đó xuống và tiếp tục nâng chân kia lên
          BƯỚC 3: Bạn hãy cố gắng giữ tư thế trong 30 giây và tăng dần lên 60 giây khi đã quen.
          Bạn sẽ tăng cường độ tập cho cơ trọng tâm với bài tập này. Tuy nhiên, bạn đừng ép bản thân phải giữ tư thế quá lâu. Khi tập, bạn có thể nghỉ ngơi khi cần bằng cách hạ đầu gối xuống sàn trong vài giây.
        ''',
      ),
      Exercise(
        name: 'Squats',
        imagePath: 'assets/squat.jpg',
        description: '''
          BƯỚC 1: Đứng thẳng và 2 chân rộng bằng hông: 
          Đứng thẳng dang hai chân rộng bằng hoặc hơn hông một chút và đặt hai tay lên hông. 

          BƯỚC 2: Siết chặt cơ bụng:
          Đứng thẳng người, nhẹ nhàng kéo vai ra đằng sau, ưỡn ngực. Khi thở ra, cố gắng kéo rốn về phía sau để siết cơ bụng, giúp giữ cho cột sống và xương chậu được cố định. 

          BƯỚC 3: Hạ cơ thể xuống giống như đang ngồi trên chiếc ghế vô hình:
          Đầu gối uốn cong và giữ phần cơ thể phía trên thẳng. Hạ người xuống hết mức có thể mà không nghiêng phần thân trên về phía trước quá nhiều. 
          Lưu ý: Không được để đầu gối đi quá xa về phía trước hoặc lõm vào trong mà hãy để đầu gối thẳng hàng với chân của bạn.

          BƯỚC 4: Duỗi chân thẳng để nâng người lên:
          Duỗi thẳng chân, cẩn thận không khóa đầu gối khi bạn đến tư thế đứng. 
          Lưu ý: Giữ gót chân bám sát mặt sàn khi bạn ngồi xổm, sau đó ấn gót chân xuống đất khi bạn đứng dậy để trở về vị trí cũ.

          BƯỚC 5: Lặp lại động tác:
          Động tác lặp lại từ 10 đến 15 lần.
        ''',
      ),
      Exercise(
        name: 'Burpees',
        imagePath: 'assets/burpee.jpg',
        description: '''
            Burpee có rất nhiều hình thức luyện tập khác nhau. Tuy nhiên, việc kết hợp những động tác cơ bản “Squat – Squat Thrust – Push Up – Frog Jump – Jump Squat”  chính là bài tập được nhiều người tập áp dụng nhất. Cách thực hiện như sau:
            BƯỚC 1: Đứng thẳng trên sàn, hai chân đứng gần và duỗi thẳng hai đặt hai bên người.

            BƯỚC 2: Hạ người vào tư thế squat, đồng thời chống hai tay xuống sàn. Khoảng cách 2 tay rộng bằng hơn vai một chút, nhón 2 gót chân.
            
            BƯỚC 3: Giữ cố định và dồn lực vào 2 cánh tay, sau đó bật nhảy 2 chân về phía sau, toàn thân duỗi thẳng và tạo thành tư thế hít đất.

            BƯỚC 4: Từ đầu tới gót chân tạo thành một đường thẳng, bạn có thể hít đất vài cái.

            BƯỚC 5: Cố định hai tay và hai chân nhảy về phía hai tay tạo thành tư thế ngồi xổm.

            BƯỚC 6: Thực hiện bật nhảy càng cao càng tốt, đồng thời đưa hai tay lên cao hơn đầu.

            BƯỚC 7: Sau khi tiếp đất, quay lại tư thế squat lúc đầu. Thực hiện lặp đi lặp lại những động tác trên đến khi đạt đủ số lần quy định.
            ''',
      ),
      Exercise(
        name: 'Hít đất',
        imagePath: 'assets/hitdat.jpg',
        description: '''
              Đây là một trong những động tác chống đẩy cho người mới tập, vì độ dễ của nó. Chống đẩy tường rất phù hợp với những người cảm thấy khó khăn khi khó đẩy người lên ở chống đẩy hít đất thông thường. Bằng cách thay đổi tư thế từ song song với sàn thành đứng, bạn sẽ tạo ít áp lực lên cánh tay hơn.
              Cách thực hiện:

              BƯỚC 1: Đặt chân rộng bằng vai, đứng cách tường một khoảng bằng cánh tay.

              BƯỚC 2: Nghiêng người về phía trước trong tư thế Plank đứng và đặt bàn tay lên tường. Cánh tay của bạn phải cao ngang vai và hai tay rộng bằng vai.

              BƯỚC 3: Hít vào, uốn cong khuỷu tay và di chuyển phần trên cơ thể về phía tường trong khi vẫn giữ bàn chân phẳng trên mặt đất. Giữ tư thế này trong 1 hoặc 2 giây.
              
              BƯỚC 4: Thở ra và dùng lực cánh tay đẩy cơ thể từ từ trở lại vị trí ban đầu.

              Khi cảm thấy thoải mái hơn, bạn có thể thử chống đẩy tường bằng một tay. Cách thực hiện cũng tương tự hướng dẫn ở trên, nhưng thay đổi bằng cách đặt một tay chắp sau lưng và tay còn lại đặt trên tường để chống đẩy. Sau đó đổi tay để lặp lại động tác.
            ''',
      ),
      Exercise(
        name: 'Nâng tạ',
        imagePath: 'assets/nangta.jpg',
        description: '''
          Các nhóm cơ được tác động: cơ ngực, cơ vai, cơ tam đầu
          Hướng dẫn tập tạ tay đúng cách với Bench Press:

          BƯỚC 1: Nằm thẳng lưng trên 1 băng ghế phẳng, mỗi tay cầm 1 quả tạ đặt lên đỉnh đùi với 2 lòng bàn tay hướng vào nhau. 

          BƯỚC 2: Dùng lực 2 đùi để nâng 2 quả tạ đơn lên tới vị trí 2 tạ ở bên trên vai. 

          BƯỚC 3: Xoay 2 cổ tay để 2 lòng bàn tay hướng về phía trước sao cho 2 quả tạ thẳng hàng. 

          BƯỚC 4: Từ từ hạ tạ xuống phía dưới tới khi 2 cánh tay song song với mặt sàn và tạo với cẳng tay 1 góc 90 độ, đồng thời mở rộng cánh tay sang 2 bên.

          BƯỚC 5: Dùng cơ ngực đẩy 2 quả tạ lên, không khóa khuỷu tay và ép cơ ngực lại để kéo 2 cánh tay lại gần nhau.

          BƯỚC 6: Khóa chặt 2 cánh tay ở đỉnh, siết chặt cơ ngực và duy trì tư thế 1 - 2s.

          BƯỚC 7: Từ từ hạ tạ xuống và về tư thế ban đầu. 

          Thực hiện: 10 - 12 lần x 3 hiệp, nghỉ 90 - 120s mỗi hiệp.
          ''',
      ),
      Exercise(
        name: 'Gập bụng',
        imagePath: 'assets/gapbung.jpg',
        description: '''Dưới đây là các bước thực hiện động tác gập bụng:

          BƯỚC 1: Nằm ngửa, hai tay đặt sau đầu và gập hai chân co, 2 bàn chân đặt trên sàn, tạo thành một góc 90 độ.

          BƯỚC 2: Ép sát lưng dưới thảm, tránh võng lưng. Siết chặt cơ bụng, nâng đầu và vai lên khỏi sàn ở mức đủ cao, đồng thời thở ra.

          BƯỚC 3: Lưu ý, chỉ dùng lực ở bụng để nâng phần trên của cơ thể lên, không dùng lực tay để kéo vai lên khỏi sàn.

          BƯỚC 4: Sau đó, siết chặt cơ bụng, từ từ hạ người xuống vị trí ban đầu.

          BƯỚC 5: Lặp lại liên tục cho đến hết hiệp.

          BƯỚC 6: Để bài tập khó hơn, bạn có thể co chân tạo thành một góc 90 độ và nhấc chân lên khỏi mặt đất.
          ''',
      ),
      // Add more exercises as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Tập luyện'),
        backgroundColor: Color.fromARGB(255, 203, 234, 248),
      ),
      backgroundColor: Color.fromARGB(255, 203, 234, 248),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Các bài tập cho sức khỏe và thể chất',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  Exercise exercise = exercises[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseDetailPage(
                            exercise: exercise,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(exercise.imagePath),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    exercise.name,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
