import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:robot_platform/widgets/common_button_with_icon.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:robot_platform/services/log_service.dart';
import 'package:robot_platform/pages/home/robot_info_widget.dart';
import 'package:robot_platform/widgets/common_card.dart';
import 'alarm_widget.dart';
import 'web_cam_widget.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:robot_platform/main_state.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
          heroTag: null,
          child: Icon(Icons.navigation),
          onPressed: () {},
        ),
        body: StoreConnector<MainState, _ViewModel>(
            converter: (store) => _ViewModel.create(store),
            builder: (store, viewModel) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RobotInfoWidget(controller: this.controller,),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        viewModel.params != null ? _WebCamDisplay() : Padding(padding: EdgeInsets.zero,),
                        viewModel.params != null ? Wrap(
                          direction: Axis.horizontal,
                          children: [
                            MyButtonWithIcon(
                              text: "前置摄像头",
                              onPressed: () => _getFrontCameraUrl(url: viewModel.params["frontUrl"]),
                            ),
                            MyButtonWithIcon(
                              text: "后置摄像头",
                              onPressed: () =>
                                  _getFrontCameraUrl(url: viewModel.params["backUrl"]),
                            ),
                            MyButtonWithIcon(
                              text: "左摄像头",
                              onPressed: () =>
                                  _getFrontCameraUrl(url: viewModel.params["leftUrl"]),
                            ),
                            MyButtonWithIcon(
                              text: "右摄像头",
                              onPressed: () =>
                                  _getFrontCameraUrl(url: viewModel.params["rightUrl"]),
                            ),
                          ],
                        ) : Padding(padding: EdgeInsets.zero,),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        WebCamWidget(),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        AlarmWidget(
                          title: "重要警报",
                          alarmMessage: alarmMessage3,
                          messageColor: Colors.red,
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        AlarmWidget(
                          title: "环境感知",
                          alarmMessage: alarmMessage2,
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        AlarmWidget(
                          title: "安防探测",
                          alarmMessage: alarmMessage1,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  _getFrontCameraUrl({@required String url}) async {
    print(url);
    await controller.stop();
    await controller.setNetworkDataSource(url, autoPlay: true);
    await controller.play();
  }

  _WebCamDisplay() {
    return MyCard(child: SizedBox(
      height: this.playerHeight,
      width: this.playerWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        child: IjkPlayer(
          mediaController: controller,
        ),
      ),
    ));
  }

  _getAllMapsInfo() async {
    final String robotId = "19WV430010";
    final String date = "2020-12-11";
    getHistoryLog(robotId: robotId, date: date).then((value) {
      print(value.data);
    });
  }
}

class _ViewModel {
  Map params;
  String status;

  _ViewModel({this.params, this.status});

  factory _ViewModel.create(Store<MainState> store) {
    return _ViewModel(
      params: store.state.robotInfoState.param,
      status: store.state.robotInfoState.status,
    );
  }
}
