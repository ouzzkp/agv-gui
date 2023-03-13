import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goktasgui/components/controller.dart';
import 'package:goktasgui/components/mapping.dart';

import 'package:universal_mqtt_client/universal_mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:goktasgui/components/constants.dart';
import 'package:goktasgui/components/mapping.dart';
import 'package:goktasgui/components/senario.dart';

class EmergencyStop extends StatefulWidget {
  const EmergencyStop({super.key});

  @override
  State<EmergencyStop> createState() => _EmergencyStopState();
}

class _EmergencyStopState extends State<EmergencyStop> {
  final client = UniversalMqttClient(
    broker: Uri.parse('ws://localhost:8080'),
    autoReconnect: true,
  );
  void initState() {
    connection();
    super.initState();
  }

  void connection() async {
    await client.connect();
  }

  void _stopEngine() {
    setState(() {
      client.publishString(
          pubTopic,
          'pos(x,y): (${x.toString()},${y.toString()}), engine stopped',
          MqttQos.atLeastOnce);
      print('pos(x,y): (${x.toString()},${y.toString()}) | ENGINE STOPPED');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 14,
      width: MediaQuery.of(context).size.width / 14,
      child: IconButton(
          onPressed: () {
            _stopEngine();
          },
          icon: Image.asset(
            "assets/images/emergency.png",
            fit: BoxFit.fill,
          )),
    );
  }
}
