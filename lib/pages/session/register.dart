import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:robot_platform/services/session_service.dart';
import 'session_title_widget.dart';
import 'package:robot_platform/widgets/common_text_field.dart';
import 'package:robot_platform/widgets/common_button_with_icon.dart';
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {

  String username;
  String password;
  String confirmedPassword;
  bool isAdmin;

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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(26, 77, 26, 30),
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.fromLTRB(0, 60, 0, 60),
                child: SessionTitle(
                  text: "注册",
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
                onChanged: (value){
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
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: MyTextField(
                  hintText: "password",
                  onChanged: (value){
                    setState(() {
                      this.password = value;
                    });
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: MyTextField(
                  hintText: "confirm password",
                  onChanged: (value){
                    setState(() {
                      this.confirmedPassword = value;
                    });
                  },
                ),
              ),
              Container(
                child: MyButtonWithIcon(
                  text: "点击注册",
                  onPressed: () => _handleRegister(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handleRegister(){
    if(this.password == null || this.username == null || this.confirmedPassword == null){
    }else if(this.password != this.confirmedPassword){
    }

    Map data = {"username": this.username, "password": this.password};

    handleRegisterRequest(data: data)
      .then((value){
        var response = json.decode(value.data);
        switch(response["msg"]){
          case "successful to store new session":
            Navigator.of(context).pop();
            return Flushbar(
              title: "注册成功",
              message: "即将跳转到登录页面",
            );
            break;
          case "account already exist":
            return Flushbar(
              title: "注册失败",
              message: "账号已经存在，或者两次密码输入不相同，请重试",
              duration: Duration(seconds: 2),
            );
        }
    })
      .catchError((err){
        print(err);
    });

  }
}