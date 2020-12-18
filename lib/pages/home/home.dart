import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:robot_platform/services/wanwei_websocket_service.dart';
import 'package:robot_platform/widgets/common_button_with_icon.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:robot_platform/services/camera_service.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:robot_platform/services/log_service.dart';
import 'package:robot_platform/configs/configure_global_param.dart';
import 'package:robot_platform/pages/home/robot_info_widget.dart';
import 'alarm_widget.dart';
import 'web_cam_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String frontUrl = "rtmp://www.anbotcloud.com:1936/live/20WV450008/front/b7c25b654652495fbcdd5098c5589e91";
  String backUrl = "rtmp://www.anbotcloud.com:1936/live/20WV450008/back/b7c25b654652495fbcdd5098c5589e91";
  String yingShiUrl = "rtmp://rtmp01open.ys7.com/openlive/fc06ca5771e84b5583cbc5e35bdde861";
  IjkMediaController controller = IjkMediaController();
  final double playerWidth = double.maxFinite;
  final double playerHeight = 200;
  final List<String> alarmMessage1 = [
    "这是第一条报警信息",
    "This is the second alarm message from robot 2",
    "Robot3 complete its task",
  ];

  final List<String> alarmMessage2 = [
    "7号门烟感正常",
  ];

  final List<String> alarmMessage3 = [
    "检测到黑名单人员侵入！！！",
    "7号门火警检测异常！！！",
  ];

  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.navigation),
        onPressed: (){},
      ),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RobotInfoWidget(),
              Padding(padding: EdgeInsets.only(top: 20)),
              _displayFrontCamera(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButtonWithIcon(
                    text: "前置摄像头",
                    onPressed: ()=> getInstanceMessage(),
                  ),
                  MyButtonWithIcon(
                  text: "后置摄像头",
                    onPressed: ()=> _getFrontCameraUrl(url: yingShiUrl),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              WebCamWidget(),
              Padding(padding: EdgeInsets.only(top: 20)),
              AlarmWidget(title: "重要警报", alarmMessage: alarmMessage3, messageColor: Colors.red,),
              Padding(padding: EdgeInsets.only(top: 20)),
              AlarmWidget(title: "环境感知", alarmMessage: alarmMessage2,),
              Padding(padding: EdgeInsets.only(top: 20)),
              AlarmWidget(title: "安防探测",alarmMessage: alarmMessage1,),
            ],
          ),
        ),
      ),
    ),);
  }


  _connectWebSocket() async {
    getInstanceMessage();
  }

  _getFrontCameraUrl({@required String url}) async {
    getCameraUrl(robotId: GlobalParam.ROBOT_1_FLOOR).then((value){
      print(value.data["param"]);
    });
    await controller.stop();
    await controller.setNetworkDataSource(url);
    await controller.play();
  }

  _displayFrontCamera() {
    return SizedBox(
      height: this.playerHeight,
      width: this.playerWidth,
      child: IjkPlayer(
        mediaController: controller,
      ),
    );
  }

  _getAllMapsInfo() async {
    final String robotId = "19WV430010";
    final String date = "2020-12-11";
    getHistoryLog(robotId: robotId, date: date).then((value){
      print(value.data);
    });
  }

  _initUrlAddress() async {
    getCameraUrl(robotId: GlobalParam.ROBOT_1_FLOOR).then((value){
      setState(() {
        frontUrl = value.data["param"]["frontUrl"];
      });
    });
  }

}