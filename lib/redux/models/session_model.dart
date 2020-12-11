import 'package:flutter/material.dart';

class SessionModel {
  bool isLogin;
  String username;
  int accountId;
  int role;

  SessionModel({this.isLogin, this.username, this.accountId, this.role});
}