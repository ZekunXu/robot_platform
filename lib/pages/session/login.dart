import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:robot_platform/configs/configure_global_param.dart';
import 'package:robot_platform/pages/index.dart';
import 'package:robot_platform/pages/session/session_title_widget.dart';
import 'package:robot_platform/redux/actions/session_action.dart';
import 'package:robot_platform/widgets/common_button_with_icon.dart';
import 'package:robot_platform/widgets/common_text_field.dart';
import 'package:robot_platform/services/session_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:redux/redux.dart';
import 'package:robot_platform/main_state.dart';
import 'package:robot_platform/routers/application.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  String username;
  String password;

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
    return Scaffold(
      body: StoreConnector<MainState, _ViewModel>(
        converter: (store) => _ViewModel.create(store),
        builder: (context, viewModel) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(26, 77, 26, 30),
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.fromLTRB(0, 60, 0, 60),
                    child: SessionTitle(
                      text: "WELCOME",
                      fontSize: 32,
                    ),
                  ),
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: SessionTitle(
                      text: "用户名",
                    ),
                  ),
                  MyTextField(
                    hintText: "username",
                    onChanged: (value) {
                      setState(() {
                        this.username = value;
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                    width: double.maxFinite,
                    child: SessionTitle(
                      text: "密码",
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: MyTextField(
                      hintText: "password",
                      onChanged: (value) {
                        setState(() {
                          this.password = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    child: MyButtonWithIcon(
                      text: "点击登录",
                      onPressed: () => _handleLogin(viewModel),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: FlatButton(
                      child: RichText(
                        text: TextSpan(
                            text: "没有账号? ",
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              TextSpan(
                                  text: "点击注册",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold)),
                            ]),
                      ),
                      onPressed: () =>
                          Application.router.navigateTo(context, "/register"),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _handleLogin(_ViewModel viewModel) {
    if (this.username == null || this.password == null) {
      return Flushbar(
        title: "登录失败",
        message: "账号名或密码不能为空",
      );
    }

    final Map loginInfo = {
      "username": this.username,
      "password": this.password
    };

    handleLoginService(loginInfo: loginInfo).then((value) {
      var data = json.decode(value.data);
      switch(data["msg"]){
        case "username or password is wrong":
          return Flushbar(
            title: "登录失败",
            message: "账号名或密码错误，请重试",
          );
          break;
        case "success":
          viewModel.onSetUsername(data["param"]["username"]);
          _saveIdentity(level: data["param"]["level"], viewModel: viewModel);
          _saveToken(token: data["param"]["token"]);
          viewModel.onSetLoginState(true);
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => IndexPage()),
                  (route) => route == null);
          return Flushbar(
            title: "登录成功",
            message: "",
          );
          break;
      }
    }).catchError((err){
      return null;
    });
  }

  _saveToken({@required String token}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(GlobalParam.SHARED_PREFERENCE_TOKEN, token);
  }

  _saveIdentity({@required int level, @required _ViewModel viewModel}) {
    switch (level) {
      case 0:
        viewModel.onSetUserIdentity("普通用户");
        break;
      case 1:
        viewModel.onSetUserIdentity("管理员");
        break;
    }
  }
}

class _ViewModel {
  Function(bool) onSetLoginState;
  Function(String) onSetUsername;
  Function(String) onSetUserIdentity;

  _ViewModel(
      {this.onSetLoginState, this.onSetUsername, this.onSetUserIdentity});

  factory _ViewModel.create(Store<MainState> store) {
    _onSetLoginState(bool isLogin) {
      store.dispatch(SetLoginStateAction(isLogin: isLogin));
    }

    _ontSetUsername(String username) {
      store.dispatch(SetUsernameAction(username: username));
    }

    _onSetUserIdentity(String identity) {
      store.dispatch(SetUserIdentityAction(identity: identity));
    }

    return _ViewModel(
      onSetLoginState: _onSetLoginState,
      onSetUsername: _ontSetUsername,
      onSetUserIdentity: _onSetUserIdentity,
    );
  }
}
