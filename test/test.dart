
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  Map data = {"abc": 123};
  var newData = json.encode(data);
  print(newData.runtimeType);
}