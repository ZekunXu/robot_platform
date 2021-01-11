import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../routers/handler.dart';
import '../routers/routes.dart';

class MyRoutes {
  static configureRoutes(FluroRouter router) {
    /*
    当请求的路由不存在时，返回的显示
     */
    router.notFoundHandler = Handler(
        // ignore: missing_return
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("Error ==> Route not exist.");
    });

router.define(Routes.login, handler: loginPageHandler);
router.define(Routes.register, handler: registerPageHandler);

  }
}
