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

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;

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
        initialState: MainState.initialState(this.isLogin));

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
    if(token != null){
        getSessionInfoByToken(token: token)
            .then((value){
           final data = json.decode(value.data);
           switch(data["msg"]){
             case "success":
               setState(() {
                 this.isLogin = true;
               });
               break;
             case "no proper user found":
               Fluttertoast.showToast(msg: "登录失效，请重新登录");
           }
        });
    }
  }
}
