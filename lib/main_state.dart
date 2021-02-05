import 'package:flutter/material.dart';
import './redux/models/theme_model.dart';
import './redux/actions/theme_action.dart';
import './redux/actions/session_action.dart';
import './redux/models/session_model.dart';
import './redux/models/message_model.dart';
import 'redux/actions/message_action.dart';
import 'package:robot_platform/redux/models/robot_info_model.dart';
import 'package:robot_platform/redux/actions/robot_info_action.dart';

class MainState {
  ThemeModel themeState;
  SessionModel sessionState;
  MessageModel messageState;
  RobotInfoModel robotInfoState;

  MainState({this.themeState, this.sessionState, this.messageState, this.robotInfoState});

  /*
  构造方法初始化 MainState
   */
  MainState.initialState({@required bool isLogin}) {
    themeState = ThemeModel(themeData: ThemeData.light());
    sessionState = SessionModel(isLogin: isLogin);
    messageState = MessageModel(messageList: [{"testMessage": "testMessage"}]);
    robotInfoState = RobotInfoModel(name: "点击选择机器人");
  }
}

/*
初始化 reducer
 */
MainState mainReducer(MainState state, action) {
  return MainState(
    themeState: themeReducer(state.themeState, action),
    sessionState: sessionReducer(state.sessionState, action),
    messageState: messageReducer(state.messageState, action),
    robotInfoState: robotInfoReducer(state.robotInfoState, action),
  );
}
