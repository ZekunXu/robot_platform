import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:robot_platform/configs/configure_global_param.dart';
import 'package:robot_platform/main_state.dart';
import 'package:redux/redux.dart';
import 'package:robot_platform/services/session_service.dart';
import 'package:robot_platform/widgets/common_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserInfoWidget extends StatefulWidget {
  UserInfoWidget({Key key}) : super(key: key);

  @override
  _UserInfoWidgetState createState() {
    return _UserInfoWidgetState();
  }
}

class _UserInfoWidgetState extends State<UserInfoWidget> {

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
        return Container(
          padding: EdgeInsets.only(bottom: 40),
          child: FutureBuilder(
            future: _getSessionInfo(),
            builder: (context, snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.done:

                  String username = snapshot.data["param"]["username"];
                  String identity;

                  switch(snapshot.data["param"]["level"]){
                    case 0:
                      identity = "普通用户";
                      break;
                    case 1:
                      identity = "管理员";
                      break;
                  }

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Welcome",
                      style: TextStyle(fontSize: 30),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Text(
                            username ?? "点击登录",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          Padding(padding: EdgeInsets.only(left: 20)),
                          Text(
                            identity ?? "",
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(63, 140, 255, 1),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                default:
                  return Center(child: CircularProgressIndicator(),);
              }
            },
          ),
        );
      },
    );
  }



  Future<Map> _getSessionInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    final token = pref.getString(GlobalParam.SHARED_PREFERENCE_TOKEN);

    Response response = await getSessionInfoByToken(token: token);

    var res = json.decode(response.data);

    return res;

  }


}

class _ViewModel {
  String username;
  String identity;

  _ViewModel({this.username, this.identity});

  factory _ViewModel.create(Store<MainState> store){

    return _ViewModel(
      username: store.state.sessionState.username,
      identity: store.state.sessionState.identity,
    );
  }
}
