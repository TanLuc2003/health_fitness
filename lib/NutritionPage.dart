import 'package:flutter/material.dart';

class Food {
  final String name;
  final String imagePath;
  final String description;

  Food({
    required this.name,
    required this.imagePath,
    required this.description,
  });
}

class NutritionPage extends StatelessWidget {
  final List<Food> foods = [
    Food(
      name: 'Bữa ăn 1',
      imagePath: 'assets/food_image_1.jpg',
      description:
          'Bữa sáng: 1 lát bánh mì nướng + 2 quả trứng luộc + 1 cốc sữa hạnh nhân + 1 ít bưởi.\n'
          'Bữa ăn nhẹ: 1 hộp sữa chua + 1 quả chuối.\n'
          'Bữa trưa: Ức gà chế biến salad + dầu oliu.\n'
          'Bữa tối: cơm gạo lứt + cá ngừ sốt + bông cải hấp + salad rau.',
    ),
    Food(
      name: 'Bữa ăn 2',
      imagePath: 'assets/food_image_2.jpg',
      description:
          'Bữa sáng: sữa hạnh nhân + yến mạch + trái cây khô + nước ép.\n'
          'Bữa ăn nhẹ: bánh quy.\n'
          'Bữa trưa: bánh mì + bò hầm rượu vang.\n'
          'Bữa tối: súp gà nấm ngô.',
    ),
    Food(
      name: 'Bữa ăn 3',
      imagePath: 'assets/food_image_3.jpg',
      description: 'Bữa sáng: phở gạo lứt nấu bò + thanh long.\n'
          'Bữa ăn nhẹ: bánh quy + sữa chua.\n'
          'Bữa trưa: cơm gạo lứt + cá tuyết hấp xì dầu.\n'
          'Bữa tối: cá ngừ sốt + súp lơ hấp.',
    ),
    Food(
      name: 'Bữa ăn 4',
      imagePath: 'assets/food_image_4.jpg',
      description: 'Bữa sáng: trứng ốp + bánh mì + 1 quả chuối.\n'
          'Bữa ăn nhẹ: trái cây sấy.\n'
          'Bữa trưa: mì Ý sốt cà chua, salad trộn dầu oliu.\n'
          'Bữa tối: cơm gạo lứt + bạch tuộc nướng + rau luộc.',
    ),
    Food(
      name: 'Bữa ăn 5',
      imagePath: 'assets/food_image_5.jpg',
      description:
          'Bữa sáng: bánh mì xướng + thịt xông khói + trứng ốp la + trái cây tráng miệng.\n'
          'Bữa ăn nhẹ: bánh quy.\n'
          'Bữa trưa: miến gà + trái cây ăn kèm.\n'
          'Bữa tối: cháo cá + trái cây tráng miệng.',
    ),
    Food(
      name: 'Bữa ăn 6',
      imagePath: 'assets/food_image_6.jpg',
      description: 'Bữa sáng: yến mạch + trái cây sấy + sữa hạnh nhân.\n'
          'Bữa ăn nhẹ: hạt điều + sữa chua.\n'
          'Bữa trưa: ức gà áp chảo + salad.\n'
          'Bữa tối: cơm gạo lứt + thịt nạc xào măng + đậu đen hấp.',
    ),
    Food(
      name: 'Bữa ăn 7',
      imagePath: 'assets/food_image_7.jpg',
      description: 'Bữa sáng: bánh mì + trứng luộc + sữa hạnh nhân.\n'
          'Bữa ăn nhẹ: sữa chua + trái cây sấy.\n'
          'Bữa trưa: nui nấu xương + trái cây.\n'
          'Bữa tối: cơm gạo lứt + thịt kho + trái cây.',
    ),
    // Thêm các Bữa ăn khác vào đây
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chế độ ăn'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Các bửa ăn hợp lý cho sức khỏe',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  Food food = foods[index];
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 20), // Khoảng cách dưới
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodDetailPage(food: food),
                          ),
                        );
                      },
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(food.imagePath),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  food.name,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
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

class FoodDetailPage extends StatelessWidget {
  final Food food;

  const FoodDetailPage({required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết món ăn'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              food.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(food.imagePath),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/wood_background2.jpg'), // Đường dẫn đến hình ảnh vân gỗ
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              padding: EdgeInsets.all(20),
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: food.description
                        .split('\n')
                        .map((line) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    '• ',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      line,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
