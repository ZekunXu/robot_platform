import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:robot_platform/configs/configure_dio.dart';
import 'package:robot_platform/configs/configure_url.dart';
import 'package:robot_platform/configs/configure_global_param.dart';

///该方法处理机器人通用的状态，并返回给前台
Future HandleRobotSatus({@required Map param}) async {

  Map<String, dynamic> value = {
    "status": "",
    "realTimeStatus": "",
    "GPS": {
      "longtitude": "",
      "latitude": "",
    },
    "power": {
      "currentPower": 0.0,
      "gatherTime": ""
    }
  };

  value["status"] = param["param"]["selfStatus"]["status"];
  value["realTimeStatus"] = param["param"]["selfStatus"]["realtimeStatus"];
  value["GPS"]["longtitude"] = param["param"]["selfStatus"]["GPSInformation"]["longtitude"];
  value["GPS"]["latitude"] = param["param"]["selfStatus"]["GPSInformation"]["latitude"];
  value["power"]["currentPower"] = param["param"]["selfStatus"]["power"]["currentPower"];
  value["power"]["gatherTime"] = param["param"]["selfStatus"]["power"]["gatherTime"];

  return value;
}