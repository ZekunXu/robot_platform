import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:robot_platform/main_state.dart';
import 'package:redux/redux.dart';

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
          child: ListTile(
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
                    viewModel.username ?? "点击登录",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Padding(padding: EdgeInsets.only(left: 20)),
                  Text(
                    viewModel.identity ?? "",
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(63, 140, 255, 1),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
