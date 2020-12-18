import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:robot_platform/configs/configure_dio.dart';
import 'package:robot_platform/configs/configure_url.dart';
import 'package:robot_platform/configs/configure_global_param.dart';

/// date格式："yyy-mm-dd"
Future<Response> getHistoryLog({@required String date, @required String robotId}) async {
  final Map<String, dynamic> param = {
    "version": "1.0.0",
    "key": GlobalParam.CompanyKey,
    "module": "statistics",
    "function": "getRobotDataByDate",
    "requestId": "victor",
    "param": {
      "robotId": robotId,
      "date": date,
    }
  };

  Response response = await (await MyJsonDio.dio).post(ApiUrl.wanWeiHttpRequestUrl, data: param);

  return response;
}