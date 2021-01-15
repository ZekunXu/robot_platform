import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:robot_platform/main_state.dart';
import 'package:robot_platform/redux/actions/robot_info_action.dart';
import 'package:robot_platform/widgets/common_card.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'change_robot_info_widget.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:convert';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class RobotInfoWidget extends StatefulWidget {
  IjkMediaController controller;

  RobotInfoWidget({Key key, @required this.controller}) : super(key: key);

  @override
  _RobotInfoWidgetState createState() {
    return _RobotInfoWidgetState();
  }
}

class _RobotInfoWidgetState extends State<RobotInfoWidget> {

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
    return StoreConnector<MainState, _ViewModel>(
      converter: (store) => _ViewModel.create(store),
      builder: (store, viewModel) {
        return MyCard(
          child: InkWell(
            onTap: () => _showBottomSheet(viewModel),
            borderRadius: BorderRadius.circular(20.0),
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      viewModel.name,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("电量：30%"),
                      Text("更新时间: 20:20:20"),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      viewModel.status ?? "不在线",
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _showBottomSheet(_ViewModel viewModel) {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0))),
        builder: (BuildContext context) {
          return ChangeRobotInfoWidget();
        }).then((value) {
      if (value != null){
        widget.controller.stop();
        widget.controller.reset();
        viewModel.onSetRobotNameState(value["name"]);
        viewModel.onSetRobotIdState(value["hardwareID"]);
        if(value["param"].containsKey("robotCam")){
          List data = [
            {"name": "前摄像头","Rtmp": value["param"]["robotCam"]["frontRtmp"]},
            {"name": "后摄像头","Rtmp": value["param"]["robotCam"]["backRtmp"]},
            {"name": "左摄像头","Rtmp": value["param"]["robotCam"]["leftRtmp"]},
            {"name": "左摄像头","Rtmp": value["param"]["robotCam"]["rightRtmp"]},
          ];
          viewModel.onSetWebCamUrlsState(data);
        }else if(value["param"].containsKey("haiKangCam")){
          List data = [{"name": "摄像头","Rtmp": value["param"]["haiKangCam"]["SDRtmp"]}];
          viewModel.onSetWebCamUrlsState(data);
        }
      }
    });
  }
}

class _ViewModel {
  Function(String) onSetRobotNameState;
  Function(String) onSetRobotIdState;
  String name;
  String status;
  Function(List) onSetWebCamUrlsState;

  _ViewModel({this.onSetRobotIdState, this.onSetRobotNameState, this.name, this.onSetWebCamUrlsState, this.status});

  factory _ViewModel.create(Store<MainState> store) {
    _onSetRobotNameState(String name) {
      store.dispatch(SetRobotNameAction(name: name));
    }

    _onSetRobotIdState(String id) {
      store.dispatch(SetRobotIdAction(robotId: id));
    }

    _onSetWebCamUrlsState(List param) {
      store.dispatch(SetWebCamUrlsAction(webCamUrls: param));
    }

    return _ViewModel(
      onSetRobotNameState: _onSetRobotNameState,
      onSetRobotIdState: _onSetRobotIdState,
      name: store.state.robotInfoState.name,
      onSetWebCamUrlsState: _onSetWebCamUrlsState,
      status: store.state.robotInfoState.status,
    );
  }
}
