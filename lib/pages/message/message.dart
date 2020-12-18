import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:robot_platform/pages/message/message_list.dart';
import 'package:robot_platform/pages/message/people_avatar_widget.dart';
import 'package:redux/redux.dart';
import 'package:robot_platform/main_state.dart';
import 'package:robot_platform/redux/actions/message_action.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class MessagePage extends StatefulWidget {

  MessagePage({Key key}) : super(key: key);

  @override
  _MessagePageState createState ()=>  _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  List<Color> rowList = [
    Colors.blue,
    Colors.black,
    Colors.amber,
    Colors.grey,
    Colors.blueGrey,
  ];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: StoreConnector<MainState, _viewModel>(
        converter: (store) => _viewModel.create(store),
        builder: (context, viewModel){
          return FloatingActionButton(
              child: Icon(Icons.refresh),
          onPressed: () => _refreshMessageList(viewModel),
          );
        },
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(15, 30, 15, 30),
          children: [
            PeopleAvatarWidget(peopleList: this.rowList,),
            Padding(padding: EdgeInsets.only(top: 40)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("最新", style: TextStyle(fontSize: 20),),
            ),
            Padding(padding: EdgeInsets.only(top: 10),),
            MessageListWidget(),
          ],
        ),
      ),
    );
  }


  _refreshMessageList(viewModel) {
    final String webSocket = "ws://www.anbotcloud.com:8180/anbotwebsocket/1b8f1ebd1c88431a9a1f3b6d23229655/1.0.0";

    WebSocketChannel channel = IOWebSocketChannel.connect(webSocket);
    Fluttertoast.showToast(msg: "websocket连接");

    channel.stream.listen((event) async {
      if(event != "ping"){
        Map<String, dynamic> response = jsonDecode(event);
        await viewModel.onSetMessageState(response);
        Fluttertoast.showToast(msg: response.toString());
      }
    });

    Future.delayed(Duration(seconds: 5), (){
      channel.sink.close();
      Fluttertoast.showToast(msg: "websocket连接关闭");
    });
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