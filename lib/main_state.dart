import 'package:flutter/material.dart';
import './redux/models/theme_model.dart';
import './redux/actions/theme_action.dart';
import './redux/actions/session_action.dart';
import './redux/models/session_model.dart';

class MainState {
  ThemeModel themeState;
  SessionModel sessionState;

  MainState({this.themeState, this.sessionState});

  /*
  构造方法初始化 MainState
   */
  MainState.initialState(bool isLogin) {
    themeState = ThemeModel(themeData: ThemeData.light());
    sessionState = SessionModel(isLogin: isLogin);
  }
}

/*
初始化 reducer
 */
MainState mainReducer(MainState state, action) {
  return MainState(
    themeState: themeReducer(state.themeState, action),
    sessionState: sessionReducer(state.sessionState, action),
  );
}
