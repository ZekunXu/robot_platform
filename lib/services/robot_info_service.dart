import 'package:flutter/material.dart';
import 'package:robot_platform/configs/configure_dio.dart';
import 'package:robot_platform/configs/configure_url.dart';
import 'package:robot_platform/configs/configure_global_param.dart';
import 'package:dio/dio.dart';

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
