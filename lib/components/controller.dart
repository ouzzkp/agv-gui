import 'dart:io';
import 'package:flutter/material.dart';
import 'package:goktasgui/components/controller.dart';
import 'package:universal_mqtt_client/universal_mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:goktasgui/components/constants.dart';
import 'package:goktasgui/components/constants.dart';

class Controller extends StatefulWidget {
  const Controller({super.key});

  @override
  State<Controller> createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  final client = UniversalMqttClient(
    broker: Uri.parse('ws://localhost:8080'),
    autoReconnect: true,
  );
  void initState() {
    connection();
    //setupUpdatesListener();
    super.initState();
  }

  void connection() async {
    print("connection");
    client.status.listen((status) {
      print('Connection Status: $status');
    });

    await client.connect();

    //await subscription.cancel();

    //client.disconnect();
  }

  void _moveForward() {
    setState(() {
      y++;
      client.publishString(
          pubTopic, 'posy: ${y.toString()} move forward', MqttQos.atLeastOnce);
    });
  }

  void _moveBackward() {
    setState(() {
      y--;
      client.publishString(
          pubTopic, 'posy: ${y.toString()} move backward', MqttQos.atLeastOnce);
    });
  }

  void _moveRight() {
    setState(() {
      x++;
      client.publishString(
          pubTopic, 'posx: ${x.toString()} move right', MqttQos.atLeastOnce);
    });
  }

  void _moveLeft() {
    setState(() {
      x--;
      client.publishString(
          pubTopic, 'posx: ${x.toString()} move left', MqttQos.atLeastOnce);
    });
  }

  void _stopEngine() {
    setState(() {
      client.publishString(
          pubTopic,
          'pos(x,y): (${x.toString()},${y.toString()}), engine stopped',
          MqttQos.atLeastOnce);
    });
  }

  final String pubTopic = "goktasagv";
  int x = 0;
  int y = 0;
  int a = 0;
  int b = 0;

  String text = "No Sended Message";

  void _sender(int index) {
    setState(() {
      switch (index) {
        case 0:
          _moveForward();
          break;
        case 1:
          _moveBackward();
          break;
        case 2:
          _moveLeft();
          break;
        case 3:
          _moveRight();
          break;
        case 911:
          _stopEngine();
          break;
      }
    });
  }

  Widget directions({required int direction, required String imagePath}) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Constant.directionGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: IconButton(
          onPressed: () => {_sender(direction)},
          icon: Image.asset(imagePath),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Position: $x,$y Sended Message: $a $b");
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OnOffSwitch(),
            const SizedBox(
              width: 15,
            ),
            directions(direction: 0, imagePath: "assets/images/forward.png"),
            const SizedBox(
              width: 15,
            ),
            directions(direction: 1, imagePath: "assets/images/back.png"),
            const SizedBox(
              width: 15,
            ),
            directions(direction: 2, imagePath: "assets/images/left.png"),
            const SizedBox(
              width: 15,
            ),
            directions(direction: 3, imagePath: "assets/images/right.png"),
            const SizedBox(
              width: 15,
            ),
            directions(
                direction: 911, imagePath: "assets/images/emergency.png"),
          ],
        ),
      ],
    );
  }
}

class OnOffSwitch extends StatefulWidget {
  const OnOffSwitch({Key? key}) : super(key: key);

  @override
  _OnOffSwitchState createState() => _OnOffSwitchState();
}

class _OnOffSwitchState extends State<OnOffSwitch> {
  bool _isOn = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isOn = !_isOn;
        });
      },
      child: Container(
        height: 40.0,
        width: 80.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: _isOn
                ? [
                    Colors.lightGreen.withOpacity(0.5),
                    Colors.lightGreen.withOpacity(0.8),
                    Colors.lightGreen.withOpacity(1.0),
                  ]
                : [
                    Colors.redAccent.withOpacity(0.5),
                    Colors.redAccent.withOpacity(0.8),
                    Colors.redAccent.withOpacity(1.0),
                  ],
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            AnimatedAlign(
              duration: Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: _isOn ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                height: 32.0,
                width: 32.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 6.0,
                      spreadRadius: 2.0,
                      offset: Offset(0.0, 3.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
