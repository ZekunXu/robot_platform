import 'package:flutter/cupertino.dart';
import 'package:robot_platform/configs/configure_dio.dart';
import 'package:robot_platform/configs/configure_url.dart';
import 'package:robot_platform/configs/configure_global_param.dart';
import 'package:dio/dio.dart';

import 'package:robot_platform/routers/routes.dart';


Future<Response> handleLoginService({@required Map loginInfo}) async {

  final String url = ApiUrl.stdHttpRequestUrl + "sessions/login";

  Response response = await (await MyJsonDio.dio).post(url, data: loginInfo);

  return response;

}

Future<Response> getSessionInfoByToken({@required String token}) async {
  final String url = ApiUrl.stdHttpRequestUrl + "sessions/token";
  final Map param = {"token": token};
  
  Response response = await (await MyJsonDio.dio).post(url, data: param);

  return response;
}

Future<Response> handleRegisterRequest({@required Map data}) async {

  final String url = ApiUrl.stdHttpRequestUrl + "sessions/save";

  Response response = await (await MyJsonDio.dio).post(url, data: data);

  return response;

}