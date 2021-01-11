class RobotInfoModel {
  String name;
  String robotId;
  String batteryPercentage;
  DateTime lastUpdateTime;
  String status;
  Map param;

  RobotInfoModel({this.robotId, this.name, this.param, this.batteryPercentage, this.lastUpdateTime, this.status});

}