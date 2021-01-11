import 'package:flutter/material.dart';
import 'package:robot_platform/widgets/common_card.dart';
import 'package:dio/dio.dart';
import 'package:robot_platform/services/robot_info_service.dart';
import 'dart:convert';

class ChangeRobotInfoWidget extends StatefulWidget {
  ChangeRobotInfoWidget({Key key}) : super(key: key);

  @override
  _ChangeRobotInfoWidgetState createState() {
    return _ChangeRobotInfoWidgetState();
  }
}

class _ChangeRobotInfoWidgetState extends State<ChangeRobotInfoWidget> {
  List robotList = [];

  @override
  void initState() {
    _loadRobots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        child: this.robotList.length > 0
            ? ListView.builder(
                itemCount: robotList.length,
                itemBuilder: (BuildContext context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context, robotList[index]);
                    },
                    child: ListTile(
                      title: Text(robotList[index]["name"]),
                      subtitle: Text(robotList[index]["status"]),
                    ),
                  );
                })
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  _loadRobots() {
    getRobotList().then((value) {
      final data = json.decode(value.data);
      // 这里我们只需要万维机器人的摄像头数据，所以先 .where 过滤
      // 然后将我们需要的数据拿出来并且返回回来
      var myList = data
          .where((robot) => robot["camType"] == "wwRobot")
          .map((robot) => {
                "name": robot["name"],
                "hardwareID": robot["hardwareID"],
                "status": "online",
                "param": robot["param"],
                "camType": robot["camType"]
              })
          .toList();
      setState(() {
        robotList = myList;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
