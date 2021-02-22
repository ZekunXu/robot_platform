import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:package_info/package_info.dart';
import 'package:robot_platform/configs/configure_global_param.dart';
import 'package:robot_platform/pages/index.dart';
import 'package:robot_platform/redux/actions/session_action.dart';
import 'package:robot_platform/routers/application.dart';
import 'package:robot_platform/services/session_service.dart';
import 'package:robot_platform/services/update_service.dart';
import 'package:robot_platform/widgets/common_card.dart';
import 'package:redux/redux.dart';
import 'package:robot_platform/main_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:another_flushbar/flushbar.dart';

class SettingGridWidget extends StatefulWidget {
  final List<String> content;

  SettingGridWidget({Key key, @required this.content}) : super(key: key);

  @override
  _SettingGridWidgetState createState() {
    return _SettingGridWidgetState();
  }
}

class _SettingGridWidgetState extends State<SettingGridWidget> {
  String debugLable = 'Unknown';
  final JPush jpush = new JPush();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<MainState, _ViewModel>(
      converter: (store) => _ViewModel.create(store),
      builder: (context, viewModel) {
        return MyCard(
            child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Radius radius = Radius.circular(10.0);
                  BorderRadius borderRadius = BorderRadius.zero;

                  if (index == 0 && widget.content.length != 1) {
                    borderRadius =
                        BorderRadius.only(topLeft: radius, topRight: radius);
                  } else if (index == widget.content.length - 1 &&
                      widget.content.length != 1) {
                    borderRadius = BorderRadius.only(
                        bottomLeft: radius, bottomRight: radius);
                  } else if (widget.content.length == 1) {
                    borderRadius = BorderRadius.all(radius);
                  }

                  return InkWell(
                    borderRadius: borderRadius,
                    onTap: () => _settingNavigator(viewModel, index),
                    child: ListTile(
                      title: Text(widget.content[index]),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, index) {
                  return Divider(
                    endIndent: 15.0,
                    indent: 15.0,
                    height: 0.0,
                  );
                },
                itemCount: widget.content.length));
      },
    );
  }

  _settingNavigator(_ViewModel viewModel, int index) async {
    switch (widget.content[index]) {
      case "退出登录":
        _logOut(viewModel);
        break;
      case "检查更新":
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String platform = Platform.isAndroid ? "android" : "ios";
        if(platform ==  "ios"){
        }
        _checkUpdate();
        break;
      case "推送设置":
        Application.router.navigateTo(context, '/test');
        break;
      default:
        // return Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("你点击了${widget.content[index]}")));
        return Flushbar(
          title: "你点击了${widget.content[index]}",
          message: "功能正在开发中，敬请期待",
          duration: Duration(seconds: 2),
          flushbarPosition: FlushbarPosition.TOP,
        )..show(context);
        break;
    }
  }

  _logOut(_ViewModel viewModel) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("确定要退出登录吗？"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("取消")),
              FlatButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.remove(GlobalParam.SHARED_PREFERENCE_TOKEN);
                    viewModel.onSetLoginStatus(false);
                    Navigator.of(context).pushAndRemoveUntil(
                        new MaterialPageRoute(
                            builder: (context) => IndexPage()),
                        (route) => route == null);
                  },
                  child: Text(
                    "确定",
                    style: TextStyle(color: Color.fromRGBO(197, 198, 199, 1)),
                  )),
            ],
          );
        });
  }

  _checkUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String build = packageInfo.buildNumber;
    String packageName = packageInfo.packageName;
    String platform = Platform.isAndroid ? "android" : "ios";
    getAppUpdateInfo().then((value) async {
      var data = json.decode(value.data);
      if (version == data["data"]["version"] &&
          build == data["data"]["build"]) {
        throw "newest";
      }
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Text("发现新版本！"),
              content: Text(data["data"]["updateInfo"] ?? "暂无版本更新信息"),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      "稍后再说",
                      style: TextStyle(color: Color.fromRGBO(197, 198, 199, 1)),
                    )),
                FlatButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      File apkFile =
                          await downloadApp(url: data["data"]["downloadlink"]);
                      String apkFilePath = apkFile.path;
                      if (apkFilePath.isEmpty) {
                        throw "download_fail";
                      }
                      InstallPlugin.installApk(apkFilePath, packageName)
                          .then((value) {
                        print("install apk $value");
                      }).catchError((err) {
                        print("install apk err: $err");
                      });
                    },
                    child: Text(
                      "现在更新",
                    )),
              ],
            );
          });
    }).catchError((err) {
      switch (err) {
        case "newest":
          break;
        case "download_fail":
        default:
          break;
      }
    });
  }

  _notificationTest() async {
    var fireDate = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch + 1000);
    var localNotification = LocalNotification(
      id: 234,
      title: '我是推送测试标题wwwwwwwww',
      buildId: 1,
      content: '看到了说明已经成功了hahahaha',
      fireTime: fireDate,
      subtitle: '一个测试qqqqqqqq',
    );
    jpush.sendLocalNotification(localNotification).then((res) {
      print('sddd');
      setState(() {
        debugLable = res;
      });
    });
  }
}

class _ViewModel {
  bool isLogin;
  Function(bool) onSetLoginStatus;

  _ViewModel({this.isLogin, this.onSetLoginStatus});

  factory _ViewModel.create(Store<MainState> store) {
    _onSetLoginStatus(bool isLogin) {
      store.dispatch(SetLoginStateAction(isLogin: isLogin));
    }

    return _ViewModel(
      isLogin: store.state.sessionState.isLogin,
      onSetLoginStatus: _onSetLoginStatus,
    );
  }
}
