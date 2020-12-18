import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

getInstanceMessage() async {
  final String webSocket = "ws://www.anbotcloud.com:8180/anbotwebsocket/1b8f1ebd1c88431a9a1f3b6d23229655/1.0.0";

  WebSocketChannel channel = IOWebSocketChannel.connect(webSocket);

  channel.stream.listen((event) {
    if(event != "ping"){
      Map<String, dynamic> response = jsonDecode(event);
      Fluttertoast.showToast(msg: response.toString());
    }
  });
}