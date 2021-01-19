import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:robot_platform/redux/actions/robot_info_action.dart';
import 'package:robot_platform/widgets/common_card.dart';
import 'package:dio/dio.dart';
import 'package:robot_platform/services/robot_info_service.dart';
import 'dart:convert';
import 'package:robot_platform/main_state.dart';
import 'package:redux/redux.dart';

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
    return StoreConnector<MainState, _ViewModel>(
      converter: (store) => _ViewModel.create(store),
      builder: (context, viewModel) {
        return MyCard(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
            child: this.robotList.length > 0
                ? ListView.builder(
                    itemCount: robotList.length,
                    itemBuilder: (BuildContext context, index) {
                      return InkWell(
                        onTap: () {
                          viewModel.resetBatteryUpdateTime();
                          viewModel
                              .onSetRobotPercentage(robotList[index]["power"]);
                          viewModel
                              .onSetRobotStatus(robotList[index]["status"]);
                          viewModel.onSetBatteryUpdateTime(
                              robotList[index]["powerUpdate"]);
                          getWebCamInfoByID(id: robotList[index]["hardwareID"])
                              .then((value) {
                            var data = json.decode(value.data);
                            Navigator.pop(context, data);
                          });
                        },
                        child: ListTile(
                          title: Text(robotList[index]["name"]),
                          subtitle: Text(
                            robotList[index]["status"],
                            style: TextStyle(
                                color: robotList[index]["status"] == "online"
                                    ? Colors.blue
                                    : Colors.black),
                          ),
                        ),
                      );
                    })
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        );
      },
    );
  }

  _loadRobots() {
    getAllRobotInfo().then((value) {
      var data = json.decode(value.data);
      var myList = data["data"]
          .where((robot) => robot["hardwareType"] == "wwRobot")
          .map((robot) => {
                "status": robot["status"]["status"],
                "realtimeStatus": robot["realtimeStatus"]["realtimeStatus"],
                "hardwareID": robot["hardwareID"],
                "power": robot["power"]["percentage"].toString() ?? "-1",
                "powerUpdate": robot["power"]["timestamp"],
                "name": robot["name"]
              })
          .toList();
      setState(() {
        this.robotList = myList;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _ViewModel {
  Function(String) onSetRobotPercentage;
  Function(String) onSetRobotStatus;
  Function(String) onSetBatteryUpdateTime;
  Function() resetBatteryUpdateTime;

  _ViewModel(
      {this.onSetRobotPercentage,
      this.onSetRobotStatus,
      this.onSetBatteryUpdateTime,
      this.resetBatteryUpdateTime});

  factory _ViewModel.create(Store<MainState> store) {
    _onSetRobotPercentage(String percentage) {
      store.dispatch(SetRobotBatteryAction(percentage: percentage));
    }

    _onSetRobotStatus(String status) {
      store.dispatch(SetRobotStatusAction(status: status));
    }

    _onSetBatteryUpdateTime(String time) {
      store.dispatch(SetBatteryUpdateTimeAction(updateTime: time));
    }

    _resetBatteryUpdateTime() {
      store.dispatch(ResetBatteryUpdateTimeAction());
    }

    return _ViewModel(
      onSetRobotPercentage: _onSetRobotPercentage,
      onSetRobotStatus: _onSetRobotStatus,
      onSetBatteryUpdateTime: _onSetBatteryUpdateTime,
      resetBatteryUpdateTime: _resetBatteryUpdateTime,
    );
  }
}
