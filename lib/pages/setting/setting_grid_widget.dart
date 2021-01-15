import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:robot_platform/configs/configure_global_param.dart';
import 'package:robot_platform/pages/index.dart';
import 'package:robot_platform/pages/setting/setting.dart';
import 'package:robot_platform/redux/actions/session_action.dart';
import 'package:robot_platform/routers/application.dart';
import 'package:robot_platform/services/haikang_service.dart';
import 'package:robot_platform/widgets/common_card.dart';
import 'package:redux/redux.dart';
import 'package:robot_platform/main_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SettingGridWidget extends StatefulWidget {
  final List<String> content;

  SettingGridWidget({Key key, @required this.content}) : super(key: key);

  @override
  _SettingGridWidgetState createState() {
    return _SettingGridWidgetState();
  }
}

class _SettingGridWidgetState extends State<SettingGridWidget> {
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
      builder: (context, viewModel){
        return MyCard(
            child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Radius radius = Radius.circular(15.0);
                  BorderRadius borderRadius = BorderRadius.zero;

                  if (index == 0 && widget.content.length != 1) {
                    borderRadius =
                        BorderRadius.only(topLeft: radius, topRight: radius);
                  } else if (index == widget.content.length - 1 &&
                      widget.content.length != 1) {
                    borderRadius =
                        BorderRadius.only(bottomLeft: radius, bottomRight: radius);
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


  _settingNavigator(_ViewModel viewModel, int index) {
    switch (widget.content[index]) {
      case "退出登录":
        _logOut(viewModel);
        break;
      default:
        Fluttertoast.showToast(msg: "你点击了 ${widget.content[index]}");
        break;
    }
  }

  _logOut(_ViewModel viewModel) async {

    return showDialog(context: context,
    builder: (context){
      return AlertDialog(
        title: Text("确定要退出登录吗？"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
        actions: [
          FlatButton(onPressed: (){
            Navigator.of(context).pop();
            },
              child: Text("取消")),
          FlatButton(onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            prefs.remove(GlobalParam.SHARED_PREFERENCE_TOKEN);
            viewModel.onSetLoginStatus(false);
            Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context) => IndexPage()),
                    (route) => route == null);
            Fluttertoast.showToast(msg: "已经退出登录");
          }, child: Text("确定", style: TextStyle(color: Color.fromRGBO(197, 198, 199, 1)),)),
        ],

      );
    }
    );
  }
}

class _ViewModel {
  bool isLogin;
  Function(bool) onSetLoginStatus;

  _ViewModel({this.isLogin, this.onSetLoginStatus});

  factory _ViewModel.create(Store<MainState> store){

    _onSetLoginStatus(bool isLogin){
      store.dispatch(SetLoginStateAction(isLogin: isLogin));
    }

    return _ViewModel(
      isLogin: store.state.sessionState.isLogin,
      onSetLoginStatus: _onSetLoginStatus,
    );
  }
}
