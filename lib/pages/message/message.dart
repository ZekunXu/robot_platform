import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:robot_platform/pages/message/message_list.dart';
import 'package:robot_platform/pages/message/people_avatar_widget.dart';
import 'package:redux/redux.dart';
import 'package:robot_platform/main_state.dart';
import 'package:robot_platform/redux/actions/message_action.dart';
import 'package:robot_platform/services/img_service.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class MessagePage extends StatefulWidget {

  MessagePage({Key key}) : super(key: key);

  @override
  _MessagePageState createState ()=>  _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  List imgList = [];


  @override
  void initState() {
    _loadImgList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadImgList,
          child: ListView(
            padding: EdgeInsets.fromLTRB(15, 30, 15, 30),
            children: [
              Text("最新人脸", style: TextStyle(fontSize: 20),),
              Padding(padding: EdgeInsets.only(top: 10)),
              PeopleAvatarWidget(imgList: this.imgList,),
              Padding(padding: EdgeInsets.only(top: 40)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("最新消息", style: TextStyle(fontSize: 20),),
              ),
              Padding(padding: EdgeInsets.only(top: 10),),
              MessageListWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadImgList() async {
    await getImgListByType(imgType: "faceImg").then((res){
      this.setState(() {
        this.imgList = res;
      });
    });
    Fluttertoast.showToast(msg: "刷新成功");
  }
}


class _viewModel {

  Function(Map) onSetMessageState;

  _viewModel({this.onSetMessageState});

  factory _viewModel.create(Store<MainState> store){
    _onSetMessageState(Map message){
        store.dispatch(SetMessageInfoAction(message: message));
    }

    return _viewModel(
      onSetMessageState: _onSetMessageState,
    );
  }

}