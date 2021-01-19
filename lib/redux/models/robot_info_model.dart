class RobotInfoModel {
  String name;
  String robotId;
  String batteryPercentage;
  String lastUpdateTime;
  String status;
  List param;
  String camId;

  RobotInfoModel(
      {this.robotId,
      this.name,
      this.param,
      this.batteryPercentage,
      this.lastUpdateTime,
      this.status,
      this.camId});
}
