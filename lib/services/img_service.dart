import 'package:flutter/cupertino.dart';
import 'package:robot_platform/configs/configure_dio.dart';
import 'package:robot_platform/configs/configure_url.dart';
import 'package:robot_platform/configs/configure_global_param.dart';
import 'package:dio/dio.dart';
import 'dart:convert';


Future<List> getImgListByType({@required String imgType, int pageSize, int pageStart}) async {

  String url = ApiUrl.stdHttpRequestUrl + "img/get";

  Map data = {
    "imgType": imgType,
    "pageStart": pageStart ?? 0,
    "pageSize": pageSize ?? 5,
  };

  Response response = await (await MyJsonDio.dio).post(url, data: data);

  var res = json.decode(response.data);

  return res["data"];
}