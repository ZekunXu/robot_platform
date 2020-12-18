import 'package:flutter/material.dart';
import 'package:robot_platform/widgets/common_card.dart';

class ChangeRobotInfoWidget extends StatefulWidget {
  ChangeRobotInfoWidget({Key key}) : super(key: key);

  @override
  _ChangeRobotInfoWidgetState createState() {
    return _ChangeRobotInfoWidgetState();
  }
}

class _ChangeRobotInfoWidgetState extends State<ChangeRobotInfoWidget> {

  List<Map> robotList = [
    {
      "robotName": "7楼外巡小黑",
      "status": "巡航中",
    },
    {
      "robotName": "1楼外围巡逻小黑",
      "status": "充电中",
    },
    {
      "robotName": "5楼巡逻大白",
      "status": "离线",
    },
  ];


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
    return MyCard(
      height: MediaQuery.of(context).size.height * 0.25,
        child: ListView.builder(
          itemCount: robotList.length,
        itemBuilder: (BuildContext context, index){
            return InkWell(
              onTap: (){
                Navigator.pop(context, robotList[index]["robotName"]);
              },
              child: ListTile(
                title: Text(robotList[index]["robotName"]),
                subtitle: Text(robotList[index]["status"]),
              ),
            );
        })
    );
  }
}