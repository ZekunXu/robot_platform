import 'package:robot_platform/configs/configure_global_param.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:robot_platform/configs/configure_dio.dart';
import 'package:robot_platform/configs/configure_url.dart';
import 'dart:convert';

Future<Response> getToken() async {
  final url = "https://open.ys7.com/api/lapp/token/get";
  
  Map<String, dynamic> param = {
    "appKey": HaiKangGlobalParam.appKey,
    "appSecret": HaiKangGlobalParam.appSecret
  };

  Response response = await (await MyDio.dio).post(url, data: param);

  return response;
}

Future<Response> getDeviceStatus({@required String token}) async {
  final url = "https://open.ys7.com/api/lapp/device/list";

  Response response =
      await (await MyDio.dio).post(url, data: {"accessToken": token});

  return response;
}

Future<Response> getUrlByDeviceId(
    {@required List idList, @required String token}) async {
  final url = "https://open.ys7.com/api/lapp/live/address/get";

  String abc = "";

  for(int i=0; i<idList.length; i++){
    abc += "${idList[i]}:1,";
  }

  Response response = await (await MyDio.dio)
      .post(url, data: {"accessToken": token, "source": abc});

  return response;
}
