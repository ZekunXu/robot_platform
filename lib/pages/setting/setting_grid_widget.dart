import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:robot_platform/configs/configure_global_param.dart';
import 'package:robot_platform/redux/actions/session_action.dart';
import 'package:robot_platform/routers/application.dart';
import 'package:robot_platform/widgets/common_card.dart';
import 'package:redux/redux.dart';
import 'package:robot_platform/main_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return StoreConnector<MainState, _viewModel>(
      converter: (store) => _viewModel.create(store),
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
                    onTap: () {
                      switch(widget.content[index]){
                        case "登录":
                          if(viewModel.isLogin == true){
                            Fluttertoast.showToast(msg: "已经登录");
                          }else{
                            Application.router.navigateTo(context, '/login');
                          }
                          break;
                        case "退出登录":
                          _logOut(viewModel);
                          break;
                        default:
                          Fluttertoast.showToast(msg: "你点击了 ${widget.content[index]}");
                          break;
                      }
                    },
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

  _logOut(_viewModel viewModel) async {
    if(viewModel.isLogin == true){
      final prefs = await SharedPreferences.getInstance();
      prefs.remove(GlobalParam.SHARED_PREFERENCE_TOKEN);
      viewModel.onSetLoginStatus(false);
      Fluttertoast.showToast(msg: "已经退出登录");
    }else{
      Fluttertoast.showToast(msg: "还没有登录");
    }
  }
}

class _viewModel {
  bool isLogin;
  Function(bool) onSetLoginStatus;

  _viewModel({this.isLogin, this.onSetLoginStatus});

  factory _viewModel.create(Store<MainState> store){

    _onSetLoginStatus(bool isLogin){
      store.dispatch(setLoginStateAction(isLogin: isLogin));
    }

    return _viewModel(
      isLogin: store.state.sessionState.isLogin,
      onSetLoginStatus: _onSetLoginStatus,
    );
  }
}
