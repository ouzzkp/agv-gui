import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:goktasgui/components/controller.dart';
import 'package:universal_mqtt_client/universal_mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:goktasgui/components/constants.dart';

var mappingState = true;

class MyCustomPainter extends CustomPainter {
  final List<Offset> points;

  MyCustomPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;
    //canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    final paint2 = Paint()..color = Colors.red;

    for (var i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
    for (final point in points) {
      canvas.drawCircle(point, 5, paint2);
    }
  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) =>
      oldDelegate.points != points;
}

class MappingWidget extends StatefulWidget {
  final List<Offset> points;

  const MappingWidget({super.key, required this.points});

  @override
  State<MappingWidget> createState() => _MappingWidgetState();
}

class _MappingWidgetState extends State<MappingWidget> {
  final client = UniversalMqttClient(
    broker: Uri.parse('ws://localhost:8080'),
    autoReconnect: true,
  );
  List<Offset> points = [];
  @override
  void initState() {
    mapping();
    super.initState();
  }

  void mapping() async {
    await client.connect();
    final subscription =
        client.handleString('mapping', MqttQos.atLeastOnce).listen((message) {
      //print(message);
      //Map<String, dynamic> parsedJson = jsonDecode(message);
      //print(parsedJson);
      List<double> xList = []; // x pozisyonları
      List<double> yList = []; // y pozsiyonları
      Map<String, dynamic> jsonMap = jsonDecode(message);
      List<dynamic> nodes =
          jsonMap['nodes']; //Json içindeki nodes array parse edilmesi
      for (dynamic node in nodes) {
        String nodeId = node['id'];
        List<dynamic> pos = node[
            'pos']; // her bir node içindeki pozisyon değerlerinin parse edilmesi
        double x = pos[0]['x'];
        double y = pos[0]['y'];
        xList.add(x);
        yList.add(y);
      }
      /*
      List<String> x = (parsedJson['nodes'] as Map<String, dynamic>)
          .values
          .map((e) => e['position']['x'].toString())
          .toList();
      List<String> y = (parsedJson['nodes'] as Map<String, dynamic>)
          .values
          .map((e) => e['position']['y'].toString())
          .toList();*/
      setState(() {
        points.clear();
        for (int i = 0; i < xList.length; i++) {
          points.add(Offset(xList[i], yList[i]));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 100,
      child: CustomPaint(
        painter: MyCustomPainter(points),
      ),
    );
  }
}
