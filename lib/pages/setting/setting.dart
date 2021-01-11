import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:robot_platform/pages/setting/setting_grid_widget.dart';
import 'package:robot_platform/pages/setting/user_info_widget.dart';
import 'package:robot_platform/widgets/common_card.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() {
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  final List<String> content1 = [
    "推送设置",
    "一键反馈",
  ];

  final List<String> content2 = [
    "人脸录入",
    "告警管理",
    "账号权限管理",
  ];

  final List<String> content3 = [
    "登录",
    "退出登录",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(15, 30, 15, 30),
          children: [
            UserInfoWidget(),
            SettingGridWidget(content: content1),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            SettingGridWidget(content: content2),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            SettingGridWidget(content: content3),
          ],
        ),
      ),
    );
  }
}
