import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:robot_platform/configs/configure_dio.dart';
import 'package:robot_platform/configs/configure_url.dart';
import 'dart:convert';

Future<Response> getCameraUrl({@required String robotId}) async {
  Map<String, dynamic> param = {
    "version": "1.0.0",
    "key": "1b8f1ebd1c88431a9a1f3b6d23229655",
    "module": "video",
    "function": "getCameraUrl",
    "requestId": "123",
    "param": {
      "robotId": robotId,
    },
  };

  Response response = await (await MyJsonDio.dio)
      .post(ApiUrl.wanWeiHttpRequestUrl, data: param);

  return response;
}
