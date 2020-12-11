import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../main_state.dart';
import 'package:robot_platform/pages/home/home.dart';
import 'package:robot_platform/pages/setting/setting.dart';

class IndexPage extends StatefulWidget {
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final List<BottomNavigationBarItem> bottomNavigationBarItemList = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: "设置"),
  ];

  final List<Widget> tabBodies = [
    HomePage(), 
    SettingPage(),
  ];

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<MainState>(
      builder: (context, store) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            items: this.bottomNavigationBarItemList,
            currentIndex: this.currentPageIndex,
            onTap: (int index){
              setState(() {
                this.currentPageIndex = index;
              });
            },
          ),
          body: IndexedStack(
            index: this.currentPageIndex,
            children: this.tabBodies,
          ),
        );
      },
    );
  }
}
