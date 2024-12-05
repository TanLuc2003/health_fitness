import 'package:flutter/material.dart';

class FitnessCircularProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      child: Stack(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 245, 173, 197)),
            strokeWidth: 6,
          ),
        ],
      ),
    );
  }
}
