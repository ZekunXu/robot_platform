import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:robot_platform/pages/session/register.dart';
import 'package:robot_platform/pages/setting/test_page.dart';
import 'routes.dart';
import 'package:robot_platform/pages/session/login.dart';


Handler loginPageHandler = Handler(
  handlerFunc:(BuildContext context, Map<String, List<String>> params){
    return LoginPage();
  }
);

Handler registerPageHandler = Handler(
    handlerFunc:(BuildContext context, Map<String, List<String>> params){
      return RegisterPage();
    }
);

Handler testPagePageHandler = Handler(
    handlerFunc:(BuildContext context, Map<String, List<String>> params){
      return TestPage();
    }
);