import 'package:redux/redux.dart';
import '../models/robot_info_model.dart';

class SetRobotNameAction {
  String name;

  SetRobotNameAction({this.name});

  static RobotInfoModel setRobotName(
      RobotInfoModel model, SetRobotNameAction action) {
    model?.name = action?.name;
    return model;
  }
}

class SetRobotIdAction {
  String robotId;

  SetRobotIdAction({this.robotId});

  static RobotInfoModel setRobotId(RobotInfoModel model, SetRobotIdAction action){
    model?.robotId = action?.robotId;
    return model;
  }
}

class SetWebCamUrlsAction {
  Map webCamUrls;

  SetWebCamUrlsAction({this.webCamUrls});

  static RobotInfoModel setWebCamUrls(RobotInfoModel model, SetWebCamUrlsAction action){
    model?.param = action?.webCamUrls;
    return model;
  }

}

final robotInfoReducer = combineReducers<RobotInfoModel>([
  TypedReducer<RobotInfoModel, SetRobotNameAction>(SetRobotNameAction.setRobotName),
  TypedReducer<RobotInfoModel, SetRobotIdAction>(SetRobotIdAction.setRobotId),
  TypedReducer<RobotInfoModel, SetWebCamUrlsAction>(SetWebCamUrlsAction.setWebCamUrls),
]);
