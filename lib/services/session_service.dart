import 'package:flutter/cupertino.dart';
import 'package:robot_platform/configs/configure_dio.dart';
import 'package:robot_platform/configs/configure_url.dart';
import 'package:robot_platform/configs/configure_global_param.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:robot_platform/routers/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

Future<Map> checkLogin() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString(GlobalParam.SHARED_PREFERENCE_TOKEN);

  Map info = {};

  if (token != null) {
    await getSessionInfoByToken(token: token).then((value) {
      final data = json.decode(value.data);
      switch (data["msg"]) {
        case "success":
          info["username"] = data["param"]["username"];
          switch (data["param"]["level"]) {
            case 0:
              info["identity"] = "普通用户";
              break;
            case 1:
              info["identity"] = "管理员";
              break;
          }
          return info;
          break;
        case "no proper user found":
          return null;
          break;
      }
    });
  }
}

Future<void> sendJgRegisterID({@required String id, @required String token}) async {
  String url = ApiUrl.stdHttpRequestUrl + "api/robot/sessions/update/jgRegisterId";

  Response response = await (await MyJsonDio.dio).post(url, data: {"token": token, "jgRegisterId": id});
}
