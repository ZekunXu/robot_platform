import 'package:fluttertoast/fluttertoast.dart';
import 'package:robot_platform/configs/configure_global_param.dart';
import 'package:robot_platform/configs/configure_routes.dart';
import 'package:robot_platform/services/session_service.dart';
import 'package:robot_platform/widgets/color_theme/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './pages/index.dart';
import 'main_state.dart';
import 'package:redux/redux.dart';
import 'package:fluro/fluro.dart';
import './routers/application.dart';
import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() {
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white),
    NotificationChannel(
        channelKey: 'progress_bar',
        channelName: 'Progress bar notifications',
        channelDescription: 'Notifications with a progress bar layout',
        defaultColor: Colors.deepPurple,
        ledColor: Colors.deepPurple,
        vibrationPattern: lowVibrationPattern,
        onlyAlertOnce: true),
  ]);
  _requestPermission();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;
  String username = "";
  String identity = "";

  @override
  void initState() {
    _checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*
  设置redux里面，store的初始值
   */
    final store = Store<MainState>(mainReducer,
        initialState: MainState.initialState(
            isLogin: this.isLogin,
            username: this.username,
            identity: this.identity));

    /*
  初始化路由配置
   */
    final router = FluroRouter();
    MyRoutes.configureRoutes(router);
    Application.router = router;

    return StoreProvider(
      store: store,
      child: StoreBuilder<MainState>(
        builder: (context, store) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: myLightTheme,
            darkTheme: myDarkTheme,
            home: IndexPage(),
            onGenerateRoute: Application.router.generator,
          );
        },
      ),
    );
  }

  _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(GlobalParam.SHARED_PREFERENCE_TOKEN);
    if (token != null) {
      await getSessionInfoByToken(token: token).then((value) {
        final data = json.decode(value.data);
        switch (data["msg"]) {
          case "success":
            setState(() {
              this.isLogin = true;
              this.username = data["param"]["username"];
              switch (data["param"]["level"]) {
                case 0:
                  this.identity = "普通用户";
                  break;
                case 1:
                  this.identity = "管理员";
                  break;
              }
            });
            break;
          case "no proper user found":
            Fluttertoast.showToast(msg: "登录失效，请重新登录");
        }
      });
    }
  }
}

_requestPermission() {
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
}
