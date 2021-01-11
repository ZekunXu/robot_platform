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