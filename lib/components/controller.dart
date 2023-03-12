import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:goktasgui/components/controller.dart';
import 'package:universal_mqtt_client/universal_mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:goktasgui/components/constants.dart';
import 'package:goktasgui/components/constants.dart';

class Controller extends StatefulWidget {
  final int keyEvent;
  const Controller({super.key, required this.keyEvent});

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

  Timer? _timerLeft;
  Timer? _timerForward;
  Timer? _timerBackward;
  Timer? _timerRight;

  Color _buttonColor = Colors.red;
  bool _isButtonOn = false;
  final String pubTopic = "goktasagv";
  int x = 0;
  int y = 0;
  int a = 0;
  int b = 0;

  String text = "No Sended Message";

  Map<int, bool> isPressedMap = {
    0: false,
    1: false,
    2: false,
    3: false,
  };
  void _moveForward() {
    if (_isButtonOn) {
      _timerBackward?.cancel(); // önceki zamanlayıcıyı iptal et
      _timerForward =
          Timer.periodic(const Duration(milliseconds: 500), (timer) {
        setState(() {
          y++;
          client.publishString(pubTopic, 'posy: ${y.toString()} move forward',
              MqttQos.atLeastOnce);
          print('pos(x,y): (${x.toString()},${y.toString()}) | MOVE FORWARD');
        });
      });
    }
  }

  void _moveBackward() {
    if (_isButtonOn) {
      _timerForward?.cancel(); // önceki zamanlayıcıyı iptal et
      _timerBackward =
          Timer.periodic(const Duration(milliseconds: 500), (timer) {
        setState(() {
          y--;
          client.publishString(pubTopic, 'posy: ${y.toString()} move backward',
              MqttQos.atLeastOnce);
          print('pos(x,y): (${x.toString()},${y.toString()}) | MOVE BACKWARD');
        });
      });
    }
  }

  void _moveRight() {
    if (_isButtonOn) {
      _timerLeft?.cancel(); // önceki zamanlayıcıyı iptal et
      _timerRight = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        setState(() {
          x++;
          client.publishString(pubTopic, 'posx: ${x.toString()} move right',
              MqttQos.atLeastOnce);
          print('pos(x,y): (${x.toString()},${y.toString()}) | MOVE RIGHT');
        });
      });
    }
  }

  void _moveLeft() {
    if (_isButtonOn) {
      _timerRight?.cancel(); // önceki zamanlayıcıyı iptal et

      _timerLeft = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        setState(() {
          x--;
          client.publishString(
              pubTopic, 'posx: ${x.toString()} move left', MqttQos.atLeastOnce);
          print('pos(x,y): (${x.toString()},${y.toString()}) | MOVE LEFT');
        });
      });
    }
  }

  void _stopEngine() {
    _timerRight?.cancel();
    _timerLeft?.cancel();
    _timerForward?.cancel();
    _timerBackward?.cancel();
    setState(() {
      client.publishString(
          pubTopic,
          'pos(x,y): (${x.toString()},${y.toString()}), engine stopped',
          MqttQos.atLeastOnce);
    });
  }

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

  Widget directions({
    required int direction,
    required String imagePath,
  }) {
    bool isPressed = isPressedMap[direction] ?? false;
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: isPressed
            ? Colors.grey
            : Constant.directionGrey, // arka plan rengi değiştirildi
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: isPressed ? Colors.white : Constant.boxShadowLeft,
            offset: isPressed ? Offset(3, 3) : Offset(-3, -3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: IconButton(
          onPressed: () => {
            setState(() {
              if (_isButtonOn) {
                isPressedMap[direction] = !isPressed;
                if (isPressedMap[direction] == true) {
                  _sender(direction);
                }
                if (isPressedMap[direction] == false) {
                  _sender(911);
                }
              }
            }),
          },
          icon: Image.asset(imagePath),
        ),
      ),
    );
  }

  Widget controllerButton() {
    return Container(
      height: 70,
      width: 70,
      child: NeumorphicButton(
        onPressed: () {
          setState(() {
            _isButtonOn = !_isButtonOn;
            _buttonColor = _isButtonOn ? Colors.green : Colors.red;
            print("Manuel Kontrol Durumu: $_isButtonOn");
          });
        },
        style: NeumorphicStyle(
          color: _buttonColor,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
          depth: 10,
          intensity: 0.5,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Icon(
                _isButtonOn
                    ? Icons.power_settings_new
                    : Icons.power_off_rounded,
                size: 30,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Text(
              _isButtonOn ? 'ON' : 'OFF',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            controllerButton(),
            const SizedBox(
              width: 15,
            ),
            directions(
              direction: 0,
              imagePath: "assets/images/forward.png",
            ),
            const SizedBox(
              width: 15,
            ),
            directions(
              direction: 1,
              imagePath: "assets/images/back.png",
            ),
            const SizedBox(
              width: 15,
            ),
            directions(
              direction: 2,
              imagePath: "assets/images/left.png",
            ),
            const SizedBox(
              width: 15,
            ),
            directions(
              direction: 3,
              imagePath: "assets/images/right.png",
            ),
            const SizedBox(
              width: 15,
            ),
            directions(
              direction: 911,
              imagePath: "assets/images/emergency.png",
            ),
          ],
        ),
      ],
    );
  }
}
