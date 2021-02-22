import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:robot_platform/services/robot_info_service.dart';
import 'package:robot_platform/widgets/common_card.dart';
import 'dart:convert';

class RobotPage extends StatefulWidget {
  RobotPage({Key key}) : super(key: key);

  @override
  _RobotPageState createState() => _RobotPageState();
}

class _RobotPageState extends State<RobotPage> {
  final List<dynamic> gridItems = [
    {"text": "IFS外围小黑", "height": 100.0},
    {"text": "IFS七楼小黑", "height": 150.0},
    {"text": "IFS五楼大白", "height": 170.0},
    {"text": "IFS四楼大白", "height": 220.0},
  ];

  List<dynamic> robotInfo = [];

  @override
  void initState() {
    _getRobotInfo();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _getRobotInfo,
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 30, 15, 30),
            child: this.robotInfo.length > 0 ? StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              itemCount: this.robotInfo.length,
              itemBuilder: (context, index) {

                String myrealtimeStatus = _getRobtoStatus(realtimeStatus: robotInfo[index]["realtimeStatus"]);
                String myRobotType = _getRobotType(robotType: robotInfo[index]["hardwareType"]);
                bool isOnline = robotInfo[index]["status"] == "online" ? true : false;

                return MyCard(
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      onTap: (){},
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: isOnline ? Colors.blue : Colors.transparent,
                              child: Icon(Icons.android_outlined, color: isOnline ? Colors.white : Colors.grey,),
                            ),
                            Padding(padding: EdgeInsets.only(top: 16),),
                            Text(robotInfo[index]["name"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                            Padding(padding: EdgeInsets.only(top: 10),),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 4,
                                  backgroundColor: Colors.blue,
                                ),
                                Padding(padding: EdgeInsets.only(left: 10)),
                                Text("$myrealtimeStatus"),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: 10)),
                            Text("类型：$myRobotType"),
                          ],
                        ),
                      ),
                    )
                );
              },
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              staggeredTileBuilder: (index) {
                return StaggeredTile.fit(1);
              },
            ) : Center(child: CircularProgressIndicator(),),
          ),
        ),
      ),
    );
  }

  String _getRobtoStatus({@required String realtimeStatus}) {
    switch(realtimeStatus){
      case "idleState":
        return "空闲状态";
      case "remoteControlState":
        return "远程遥控中";
      case "navigationState":
        return "导航中";
      case "chargeState":
        return "充电中";
      case "emergencyStopState":
        return "急停状态";
      case "upgradeState":
        return "系统升级中";
      case "chargeNav":
        return "充电导航中";
      case "mappingState":
        return "建图中";
      case "patrol":
        return "巡逻";
      case "fault":
        return "故障";
      default:
        return "状态未知";
    }
  }

  String _getRobotType({@required String robotType}) {
    switch(robotType){
      case "wwRobot":
        return "万维机器人";
      case "ldRobot":
        return "市井机器人";
      case "tslRobot":
        return "特斯联机器人";
      default:
        return "未知机器人型号";
    }
  }


  Future<void> _getRobotInfo() async {
    await getAllRobotInfo().then((value){
      List res = json.decode(value.data)["data"];
      setState(() {
        this.robotInfo = res.map((e) => {
          "status": e["status"]["status"] ?? "offline",
          "realtimeStatus": e["realtimeStatus"]["realtimeStatus"] ?? "offline",
            "power": e["power"]["percentage"] ?? 0,
          "name": e["name"] ?? "无名称",
          "hardwareType": e["hardwareType"] ?? "暂无型号信息",
          "hardwareID": e["hardwareID"] ?? "",
        }).toList();
      });
    });
  }
}
