import 'package:flutter/material.dart';

import 'mapping.dart';

class Constant {
  // Colors
  static const Color mainGreen = Color(0xFFE8E120);
  static const Color mainGrey = Color(0xFF282828);
  static const Color directionGrey = Color(0xFF727272);
}

class DataComponent extends StatelessWidget {
  final double widthSize;
  final double heightSize;
  final String subTitle;
  final Widget contentData;

  const DataComponent(
      {super.key,
      required this.subTitle,
      required this.contentData,
      required this.widthSize,
      required this.heightSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(40, 40, 40, 1.0),
        ),
        height: heightSize,
        width: widthSize,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  subTitle,
                  style: const TextStyle(
                      color: Color.fromRGBO(232, 225, 32, 1.0),
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: contentData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Widget DataComponentContent({required String text}) {
  return Text(
    text,
    style: const TextStyle(fontSize: 30, color: Colors.white),
  );
}

final points = [
  Offset(10, 10),
  Offset(20, 30),
  Offset(50, 70),
  Offset(80, 90),
];
