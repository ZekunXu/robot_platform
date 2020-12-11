import 'package:flutter/material.dart';
import 'package:robot_platform/widgets/common_button_with_icon.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:robot_platform/services/camera_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: SafeArea(
      child: Center(
        child: Column(
          children: [
            MyButtonWithIcon(
              text: "建立连接",
              onPressed: () => _connectWebSocket(),
            ),
            MyButtonWithIcon(
              text: "获取图像url",
              onPressed: () => _getFrontCameraUrl(),
            )
          ],
        ),
      ),
    ),);
  }


  _connectWebSocket(){
    final String webSocket = "ws://www.anbotcloud.com:8180/anbotwebsocket/1b8f1ebd1c88431a9a1f3b6d23229655/1.0.0";

    WebSocketChannel channel = IOWebSocketChannel.connect(webSocket);

    channel.stream.listen((event) {
      if(event != "ping"){
        Map<String, dynamic> response = jsonDecode(event);
        print(response);
        print(response.runtimeType);
        print("----------------");
      }
    });
  }

  _getFrontCameraUrl(){
    getCameraUrl().then((value){
      print(value.data["param "]);
    }).catchError((err){
      print("error: $err");
    });

  }

}