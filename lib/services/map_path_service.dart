import 'package:dio/dio.dart';
import 'package:robot_platform/configs/configure_dio.dart';
import 'package:robot_platform/configs/configure_url.dart';
import 'package:robot_platform/configs/configure_global_param.dart';

Future<Response> getAllMaps() async {
  final Map<String, dynamic> param = {
    "version": "1.0.0",
    "key": "1b8f1ebd1c88431a9a1f3b6d23229655",
    "module": "map",
    "function": "getAllMaps",
    "requestId": "victor",
  };

  Response response = await (await MyJsonDio.dio).post(ApiUrl.wanWeiHttpRequestUrl, data: param);

  return response;
}

Future<Response> getCurrentMapUsed(String robotId) async {
    final Map<String, dynamic> param = {
      "version": "1.0.0",
      "key": GlobalParam.CompanyKey,
      "module": "map",
      "function": "getRobotMap",
      "requestId": "victor",
      "param": {
        "robotId": robotId,
      }
    };

    Response response = await (await MyJsonDio.dio).post(ApiUrl.wanWeiHttpRequestUrl, data: param);

    return response;
}