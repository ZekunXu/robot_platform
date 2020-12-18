import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:robot_platform/widgets/common_card.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'change_robot_info_widget.dart';

class RobotInfoWidget extends StatefulWidget {
  RobotInfoWidget({Key key}) : super(key: key);

  @override
  _RobotInfoWidgetState createState() {
    return _RobotInfoWidgetState();
  }
}

class _RobotInfoWidgetState extends State<RobotInfoWidget> {

  String robotName = "Robot Name 001";

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
      child: InkWell(
        onTap: () => _showBottomSheet(),
        borderRadius: BorderRadius.circular(20.0),
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  robotName,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 2.0,
                  children: [
                    Text("电量：30%"),
                    Text("巡航中..."),
                    SizedBox(
                      width: 40,
                    ),
                    Text("最后更新时间：19:20:59"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  _showBottomSheet() {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(15.0), topLeft: Radius.circular(15.0))
        ),
        builder: (BuildContext context){
          return ChangeRobotInfoWidget();
        }
    ).then((value){
      setState(() {
        this.robotName = value;
      });
    });
  }
}
