import 'package:robot_platform/configs/configure_routes.dart';
import 'package:robot_platform/widgets/color_theme/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import './pages/index.dart';
import 'main_state.dart';
import 'package:redux/redux.dart';
import 'package:fluro/fluro.dart';
import './routers/application.dart';

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
            theme: ThemeData.light(),
            darkTheme: myDarkTheme,
            home: IndexPage(),
            onGenerateRoute: Application.router.generator,
          );
        },
      ),
    );
  }
}
