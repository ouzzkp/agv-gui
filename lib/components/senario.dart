import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:goktasgui/components/controller.dart';
import 'package:goktasgui/components/mapping.dart';
import 'package:universal_mqtt_client/universal_mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:goktasgui/components/constants.dart';

class EntrySenario extends StatefulWidget {
  const EntrySenario({super.key});

  @override
  State<EntrySenario> createState() => _EntrySenarioState();
}

class _EntrySenarioState extends State<EntrySenario> {
  final client = UniversalMqttClient(
    broker: Uri.parse('ws://localhost:8080'),
    autoReconnect: true,
  );
  @override
  void initState() {
    connectionSenario();
    super.initState();
  }

  void connectionSenario() async {
    //print("connection");
    //client.status.listen((status) {
    //  print('Connection Status: $status');
    //});
    await client.connect();
  }

  String pubTopic = "senario";

  void _sendSenario() {
    setState(() {
      client.publishString(
          pubTopic, 'SENARYO: $_enteredText', MqttQos.atLeastOnce);
      print('SENARYO: $_enteredText');
    });
  }

  String _enteredText = "";
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            width: 200,
            height: 50,
            child: TextField(
              onChanged: (text) {
                setState(() {
                  _enteredText = text;
                });
              },
              decoration: InputDecoration(
                hintText: 'Bir metin girin',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: mappingState ? null : _sendSenario,
          child: SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  "Gönder",
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              )),
        ),
      ],
    );
  }
}
