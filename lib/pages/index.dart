import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:robot_platform/pages/session/login.dart';
import '../main_state.dart';
import 'package:robot_platform/pages/home/home.dart';
import 'package:robot_platform/pages/setting/setting.dart';
import 'package:robot_platform/pages/message/message.dart';
import 'package:robot_platform/pages/robot/Robot.dart';
import 'package:robot_platform/pages/connect/connect.dart';

class IndexPage extends StatefulWidget {
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final List<BottomNavigationBarItem> bottomNavigationBarItemList = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
    BottomNavigationBarItem(icon: Icon(Icons.android), label: "机器人"),
    BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "消息"),
    BottomNavigationBarItem(
        icon: Icon(Icons.cast_connected_outlined), label: "互联设施"),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: "设置"),
  ];

  final List<Widget> tabBodies = [
    HomePage(),
    RobotPage(),
    MessagePage(),
    ConnectPage(),
    SettingPage(),
  ];

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<MainState>(
      builder: (context, store) {
        return store.state.sessionState.isLogin
            ? Scaffold(
                bottomNavigationBar: BottomNavigationBar(
                  selectedItemColor: Color.fromRGBO(63, 140, 255, 1),
                  unselectedItemColor: Color.fromRGBO(125, 126, 131, 1),
                  items: this.bottomNavigationBarItemList,
                  currentIndex: this.currentPageIndex,
                  onTap: (int index) {
                    setState(() {
                      this.currentPageIndex = index;
                    });
                  },
                ),
                body: IndexedStack(
                  index: this.currentPageIndex,
                  children: this.tabBodies,
                ),
              )
            : LoginPage();
      },
    );
  }
}
