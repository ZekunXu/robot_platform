import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:robot_platform/widgets/common_card.dart';
import 'package:redux/redux.dart';
import 'package:robot_platform/main_state.dart';

class MessageListWidget extends StatefulWidget {
  MessageListWidget({Key key}) : super(key: key);

  @override
  _MessageListWidgetState createState() {
    return _MessageListWidgetState();
  }
}

class _MessageListWidgetState extends State<MessageListWidget> {

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

        return viewModel.messageList.length > 0 ? ListView.builder(
          reverse: true,
          itemCount: viewModel.messageList.length,
          itemBuilder: (BuildContext context, index){
            return Container(
              padding: EdgeInsets.only(bottom: 20),
              child: MyCard(
                  child: ListTile(
                    title: Text("这是第$index条消息"),
                    subtitle: Text(viewModel.messageList[index].toString()),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                  )
              ),
            );
          },
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        ) : CircularProgressIndicator();
      },
    );
  }
}


class _viewModel {

  List messageList;

  _viewModel({this.messageList});

  factory _viewModel.create(Store<MainState> store) {

    return _viewModel(
      messageList: store.state.messageState.messageList,
    );
  }


}