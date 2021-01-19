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

  static RobotInfoModel setRobotId(
      RobotInfoModel model, SetRobotIdAction action) {
    model?.robotId = action?.robotId;
    return model;
  }
}

class SetWebCamUrlsAction {
  List webCamUrls;

  SetWebCamUrlsAction({this.webCamUrls});

  static RobotInfoModel setWebCamUrls(
      RobotInfoModel model, SetWebCamUrlsAction action) {
    model?.param = action?.webCamUrls;
    return model;
  }
}

class SetWebCamIdAction {
  String camId;

  SetWebCamIdAction({this.camId});

  static RobotInfoModel setWebCamId(
      RobotInfoModel model, SetWebCamIdAction action) {
    model?.camId = action?.camId;
    return model;
  }
}

class SetRobotBatteryAction {
  String percentage;

  SetRobotBatteryAction({this.percentage});

  static RobotInfoModel setRobotBattery(
      RobotInfoModel model, SetRobotBatteryAction action) {
    model?.batteryPercentage = action?.percentage;
    return model;
  }
}

class SetRobotStatusAction {
  String status;

  SetRobotStatusAction({this.status});

  static RobotInfoModel setRobotStatus(
      RobotInfoModel model, SetRobotStatusAction action) {
    model?.status = action?.status;

    return model;
  }
}

class SetBatteryUpdateTimeAction {
  String updateTime;

  SetBatteryUpdateTimeAction({this.updateTime});

  static RobotInfoModel setBatteryUpdateTime(
      RobotInfoModel model, SetBatteryUpdateTimeAction action) {
    model?.lastUpdateTime = action?.updateTime;
    return model;
  }
}

class ResetBatteryUpdateTimeAction {
  static RobotInfoModel resetBatteryUpdateTime(RobotInfoModel model, ResetBatteryUpdateTimeAction action){
    model?.lastUpdateTime = null;
    return model;
  }
}

final robotInfoReducer = combineReducers<RobotInfoModel>([
  TypedReducer<RobotInfoModel, SetRobotNameAction>(
      SetRobotNameAction.setRobotName),
  TypedReducer<RobotInfoModel, SetRobotIdAction>(SetRobotIdAction.setRobotId),
  TypedReducer<RobotInfoModel, SetWebCamUrlsAction>(
      SetWebCamUrlsAction.setWebCamUrls),
  TypedReducer<RobotInfoModel, SetWebCamIdAction>(
      SetWebCamIdAction.setWebCamId),
  TypedReducer<RobotInfoModel, SetRobotBatteryAction>(
      SetRobotBatteryAction.setRobotBattery),
  TypedReducer<RobotInfoModel, SetRobotStatusAction>(
      SetRobotStatusAction.setRobotStatus),
  TypedReducer<RobotInfoModel, SetBatteryUpdateTimeAction>(
      SetBatteryUpdateTimeAction.setBatteryUpdateTime),
  TypedReducer<RobotInfoModel, ResetBatteryUpdateTimeAction>(
      ResetBatteryUpdateTimeAction.resetBatteryUpdateTime),
]);
