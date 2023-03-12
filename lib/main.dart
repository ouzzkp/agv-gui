// @dart=2.9
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goktasgui/components/controller.dart';
import 'package:goktasgui/components/mapping.dart';
import 'package:goktasgui/components/senario.dart';
import 'package:universal_mqtt_client/universal_mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:goktasgui/components/constants.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goktas AGV Control Panel',
      theme: ThemeData(
        backgroundColor: Colors.blueGrey,
        primarySwatch: Colors.lime,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _focusNode = FocusNode();
  String _timeString;
  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.hour % 12}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')} ${dateTime.hour < 12 ? '' : ''}";
  }

  int keydirection = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/goktas.png",
                  height: MediaQuery.of(context).size.height / 8,
                  width: MediaQuery.of(context).size.width / 12,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            DataComponent(
                              contentData: DataComponentContent(text: "2 m/s"),
                              subTitle: "Hız",
                              widthSize: MediaQuery.of(context).size.width / 6,
                              heightSize:
                                  MediaQuery.of(context).size.height / 6,
                            ),
                            DataComponent(
                              contentData: DataComponentContent(text: "%87"),
                              subTitle: "Batarya",
                              widthSize: MediaQuery.of(context).size.width / 6,
                              heightSize:
                                  MediaQuery.of(context).size.height / 6,
                            ),
                          ],
                        ),
                        Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            DataComponent(
                              contentData: DataComponentContent(text: "55 Kg"),
                              subTitle: "Yük Bilgileri",
                              widthSize: MediaQuery.of(context).size.width / 6,
                              heightSize:
                                  MediaQuery.of(context).size.height / 6,
                            ),
                            DataComponent(
                              contentData: DataComponentContent(text: "25 C"),
                              subTitle: "Sıcaklık",
                              widthSize: MediaQuery.of(context).size.width / 6,
                              heightSize:
                                  MediaQuery.of(context).size.height / 6,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            DataComponent(
                              subTitle: "Manuel Kontrol",
                              contentData: const Controller(),
                              widthSize:
                                  MediaQuery.of(context).size.width / 3 + 20,
                              heightSize:
                                  MediaQuery.of(context).size.height / 6,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            DataComponent(
                              subTitle: "Geçen Süre",
                              contentData:
                                  DataComponentContent(text: _timeString),
                              widthSize:
                                  MediaQuery.of(context).size.width / 3 + 20,
                              heightSize:
                                  MediaQuery.of(context).size.height / 6,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DataComponent(
                      subTitle: "Harita",
                      contentData: MappingWidget(),
                      widthSize: MediaQuery.of(context).size.width / 3,
                      heightSize: MediaQuery.of(context).size.height / 3 + 20,
                    ),
                    DataComponent(
                      subTitle: "Senaryo",
                      contentData: EntrySenario(),
                      widthSize: MediaQuery.of(context).size.width / 3,
                      heightSize: MediaQuery.of(context).size.height / 6,
                    ),
                    DataComponent(
                      subTitle: "Araç Durumu",
                      contentData:
                          DataComponentContent(text: "Araç İstirahatte"),
                      widthSize: MediaQuery.of(context).size.width / 3,
                      heightSize: MediaQuery.of(context).size.height / 6,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
