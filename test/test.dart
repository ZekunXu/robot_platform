import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info/package_info.dart';
import 'package:robot_platform/services/haikang_service.dart';
import 'package:date_format/date_format.dart';

void main() async {

  Map data = {"abc": 1};

  data["abc"] = "123";

  print(data);

}
