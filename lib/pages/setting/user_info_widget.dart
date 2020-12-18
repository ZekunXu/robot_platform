import 'package:flutter/material.dart';

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
                "许骏马",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Padding(padding: EdgeInsets.only(left: 20)),
              Text(
                "管理员",
                style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(63, 140, 255, 1),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
