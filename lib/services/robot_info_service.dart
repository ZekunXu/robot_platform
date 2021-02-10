import 'package:flutter/material.dart';
import 'package:robot_platform/configs/configure_dio.dart';
import 'package:robot_platform/configs/configure_url.dart';
import 'package:robot_platform/configs/configure_global_param.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

Future<Response> getRobotList() async {
  final url = ApiUrl.stdHttpRequestUrl + "webcams";

  Response response = await (await MyDio.dio).get(url);

  return response;
}

Future<Response> getRobotInfoById({@required String hardwareID}) async {
  final url = ApiUrl.stdHttpRequestUrl + "robotInfo/get/robotStatus";

  Response response =
      await (await MyJsonDio.dio).post(url, data: {hardwareID: hardwareID});

  return response;
}

Future<Response> getAllRobotInfo() async {
  final url = ApiUrl.stdHttpRequestUrl + "robotInfo/get";

  Response response = await (await MyDio.dio).get(url);

  return response;
}

Future<Response> getWebCamInfoByID({@required String id}) async {
  final url = ApiUrl.stdHttpRequestUrl + "webcams";

  Response response = await (await MyJsonDio.dio).post(url, data: {"id": id});

  return response;
}

//这个接口用来给首页加载机器人列表用。
Future<List> getRobotInfoToList() async {
  final url = ApiUrl.stdHttpRequestUrl + "robotInfo/get";

  Response response = await (await MyDio.dio).get(url);

  var data = json.decode(response.data);

  /// 如果在 map 方法里嵌套了一个 Future 的方法
  /// 就需要使用 Stream.fromIterable(List).asyncMap().toList();
  List res = await Stream.fromIterable(data["data"]).asyncMap((e) async {
      Response value = await getWebCamInfoByID(id: e["hardwareID"]);

      data = json.decode(value.data);

      List urlList = [];

      if (data["param"].containsKey("robotCam")) {
        urlList = [
          {"name": "前摄像头", "url": data["param"]["robotCam"]["frontUrl"]},
          {"name": "后摄像头", "url": data["param"]["robotCam"]["backUrl"]},
          {"name": "左摄像头", "url": data["param"]["robotCam"]["leftUrl"]},
          {"name": "右摄像头", "url": data["param"]["robotCam"]["rightUrl"]},
        ];
      } else if (data["param"].containsKey("haiKangCam")) {
        urlList = [
          {"name": "摄像头", "url": data["param"]["haiKangCam"]["SDFlv"]}
        ];
      }

      print(urlList.toString());

      return {
        "name": e["name"],
        "hardwareID": e["hardwareID"],
        "status": e["status"]["status"],
        "realtimeStatus": e["realtimeStatus"]["realtimeStatus"],
        "power": e["power"]["percentage"],
        "powerUpdateTime": e["power"]["timestamp"],
        "hardwareType": e["hardwareType"],
        "WebCams": urlList,
      };
  }).toList();

  return res;
}

Future<Map> updateRobotInfoById({@required String hardwareID}) async {
  List data = await getRobotInfoToList();

  Map res =
      data.where((element) => element["hardwareID"] == hardwareID).toList()[0];

  return res;
}
