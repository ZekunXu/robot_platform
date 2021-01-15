import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:robot_platform/services/haikang_service.dart';


void main() {
  List a = ["abc", "def"];
  String b = "";
  for(int i=0; i<a.length; i++){
    b += "${a[i]}:1,";
  }
  print(b);
}
