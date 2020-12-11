import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import '../models/session_model.dart';

// ignore: camel_case_types
class setUsernameAction {
  String username;
  setUsernameAction({this.username}) : super();

  static SessionModel setUsername(
      SessionModel session, setUsernameAction action) {
    session?.username = action?.username;
    return session;
  }
}

// ignore: camel_case_types
class setLoginStateAction {
  bool isLogin;
  setLoginStateAction({this.isLogin});

  static SessionModel setLoginState(
      SessionModel session, setLoginStateAction action) {
    session?.isLogin = action?.isLogin;
    return session;
  }
}

final sessionReducer = combineReducers<SessionModel>([
  TypedReducer<SessionModel, setUsernameAction>(setUsernameAction.setUsername),
  TypedReducer<SessionModel, setLoginStateAction>(
      setLoginStateAction.setLoginState),
]);
