import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:universal_mqtt_client/universal_mqtt_client.dart';

import 'mapping.dart';

Map<int, bool> isPressedMap = {
  0: false,
  1: false,
  2: false,
  3: false,
};
int x = 0;
int y = 0;
final String pubTopic = "goktasagv";

class Constant {
  // Colors
  static const Color mainGreen = Color(0xFFE8E120);
  static const Color mainGrey = Color(0xFF282828);
  static const Color directionGrey = Color(0xFF727272);
  static const Color boxShadowRight = Color.fromARGB(255, 63, 63, 63);
  static const Color boxShadowLeft = Color(0xFF969696);
}

class DataComponent extends StatefulWidget {
  final double widthSize;
  final double heightSize;
  final String subTitle;
  final Widget contentData;

  const DataComponent({
    Key? key,
    required this.subTitle,
    required this.contentData,
    required this.widthSize,
    required this.heightSize,
  }) : super(key: key);

  @override
  _DataComponentState createState() => _DataComponentState();
}

class _DataComponentState extends State<DataComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(40, 40, 40, 1.0),
        ),
        height: widget.heightSize,
        width: widget.widthSize,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  widget.subTitle,
                  style: const TextStyle(
                      color: Color.fromRGBO(232, 225, 32, 1.0),
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: widget.contentData,
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

class MainButtons extends StatefulWidget {
  const MainButtons({super.key});

  @override
  State<MainButtons> createState() => _MainButtonsState();
}

class _MainButtonsState extends State<MainButtons> {
  final client = UniversalMqttClient(
    broker: Uri.parse('ws://localhost:8080'),
    autoReconnect: true,
  );

  @override
  void initState() {
    client.connect();
    super.initState();
  }

  void _startTheMapping() {
    setState(() {
      mappingState == true;
      client.publishString(
          mappingStateTopic, 'start the mapping', MqttQos.atLeastOnce);
    });
  }

  void _stopTheMapping() {
    setState(() {
      mappingState == false;
      client.publishString(
          mappingStateTopic, 'stop the mapping', MqttQos.atLeastOnce);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(40, 40, 40, 1.0),
        ),
        height: MediaQuery.of(context).size.height / 12,
        width: MediaQuery.of(context).size.width / 1.5 + 40,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      _startTheMapping();
                    },
                    child: Text("Başla!")),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      _stopTheMapping();
                    },
                    child: Text("Bitir!")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
