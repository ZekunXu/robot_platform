import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:robot_platform/services/haikang_service.dart';
import 'package:date_format/date_format.dart';


void main() {
  String date = "1611028692856";
  print(formatDate(DateTime.fromMillisecondsSinceEpoch(int.parse(date)), [HH, ":", nn, ":", ss]));
}
