import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import '../models/theme_model.dart';

/*
修改全局主题切换的 action
 */
class setThemeAction {
  ThemeData themeData;

  setThemeAction({this.themeData}) : super();

  static ThemeModel setTheme(ThemeModel theme, setThemeAction action) {
    theme?.themeData = action?.themeData;
    return theme;
  }
}

final themeReducer = combineReducers<ThemeModel>([
  TypedReducer<ThemeModel, setThemeAction>(setThemeAction.setTheme),
]);
