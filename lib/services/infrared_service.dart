import 'package:robot_platform/configs/configure_dio.dart';
import 'package:robot_platform/configs/configure_url.dart';
import 'package:robot_platform/configs/configure_global_param.dart';
import 'package:dio/dio.dart';
import 'dart:convert';


Future<Map> getLatestInfraredMsg() async {
  final url = ApiUrl.stdHttpRequestUrl + "infrared/getOne";

  Response response = await (await MyJsonDio.dio).get(url);

  var data = json.decode(response.data);

  return data;
}