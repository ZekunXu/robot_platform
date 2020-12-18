import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../models/message_model.dart';

class SetMessageInfoAction {

  Map<String, dynamic> message;

  SetMessageInfoAction({this.message});

  static MessageModel setMessageInfo (MessageModel model, SetMessageInfoAction action) {
    model.messageList.add(action.message);

    return model;
  }
}

final messageReducer = combineReducers<MessageModel>([
  TypedReducer<MessageModel, SetMessageInfoAction>(SetMessageInfoAction.setMessageInfo),
]);