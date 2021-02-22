import 'package:flutter/services.dart';
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
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 极光推送相关变量
  String debugLable = 'Unknown';
  final JPush jpush = new JPush();

  bool isLogin = false;

  @override
  void initState() {
    _checkLogin();
    _initPlatformState();
    _requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*
  设置redux里面，store的初始值
   */
    final store = Store<MainState>(mainReducer,
        initialState: MainState.initialState(
            isLogin: this.isLogin,));

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
      setState(() {
        this.isLogin = true;
      });
    }
  }

  // 初始化极光推送
  Future<void> _initPlatformState() async {
    String platformVersion;

    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
            print("flutter onReceiveNotification: $message");
            setState(() {
              debugLable = "flutter onReceiveNotification: $message";
            });
          }, onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
        setState(() {
          debugLable = "flutter onOpenNotification: $message";
        });
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
        setState(() {
          debugLable = "flutter onReceiveMessage: $message";
        });
      }, onReceiveNotificationAuthorization:
          (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationAuthorization: $message");
        setState(() {
          debugLable = "flutter onReceiveNotificationAuthorization: $message";
        });
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    jpush.setup(
      appKey: "bd54c9f26c93aac42d8c4d51", //你自己应用的 AppKey
      channel: "theChannel",
      production: true,
      debug: false,
    );
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));

    // send registerID every time when app init. We need to get token first.
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(GlobalParam.SHARED_PREFERENCE_TOKEN);
    if (token != null) {
      jpush.getRegistrationID().then((value) {
        if (value == null) {
          throw 101;
        }
        return sendJgRegisterID(id: value, token: token);
      }).then((value) {
      }).catchError((err) {
        switch (err) {
          case 101:
            break;
          default:
            break;
        }
      });
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      debugLable = platformVersion;
    });
  }

  _requestPermission() async {

    Map<Permission, PermissionStatus> statues = await [
      Permission.location,
      Permission.storage,
      Permission.notification,
      Permission.phone,
      Permission.camera,
    ].request();
  }
}
