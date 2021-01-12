import 'package:redux/redux.dart';
import '../models/session_model.dart';

// ignore: camel_case_types
class SetUsernameAction {
  String username;
  SetUsernameAction({this.username}) : super();

  static SessionModel setUsername(
      SessionModel session, SetUsernameAction action) {
    session?.username = action?.username;
    return session;
  }
}

class SetUserIdentityAction {
  String identity;

  SetUserIdentityAction({this.identity}) : super();

  static SessionModel setUserIdentity(
      SessionModel session, SetUserIdentityAction action){
    session?.identity = action?.identity;
    return session;
  }

}

// ignore: camel_case_types
class SetLoginStateAction {
  bool isLogin;
  SetLoginStateAction({this.isLogin});

  static SessionModel setLoginState(
      SessionModel session, SetLoginStateAction action) {
    session?.isLogin = action?.isLogin;
    return session;
  }
}

final sessionReducer = combineReducers<SessionModel>([
  TypedReducer<SessionModel, SetUsernameAction>(SetUsernameAction.setUsername),
  TypedReducer<SessionModel, SetLoginStateAction>(
      SetLoginStateAction.setLoginState),
  TypedReducer<SessionModel, SetUserIdentityAction>(SetUserIdentityAction.setUserIdentity),
]);
