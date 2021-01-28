import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';
import 'package:robot_platform/main_state.dart';
import 'package:robot_platform/widgets/common_button_with_icon.dart';
import 'package:robot_platform/widgets/common_card.dart';

class RobotCamWidget extends StatefulWidget {
  IjkMediaController controller;

  RobotCamWidget({Key key, @required this.controller}) : super(key: key);

  @override
  _RobotCamWidgetState createState() {
    return _RobotCamWidgetState();
  }
}

class _RobotCamWidgetState extends State<RobotCamWidget> {
  final double playerWidth = double.maxFinite;
  final double playerHeight = 200;

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
      builder: (context, viewModel) {
        return Column(
          children: [
            viewModel.param != null
                ? _webCamDisplay()
                : Padding(
                    padding: EdgeInsets.zero,
                  ),
            viewModel.param != null
                ? Wrap(
                    direction: Axis.horizontal,
                    children: viewModel.param
                        .map((e) => FlatButton(
                              onPressed: () => _displayWebCam(url: e["Rtmp"]),
                              child: Text(e["name"]),
                            ))
                        .toList()
                        .cast<Widget>(),
                  )
                : Padding(
                    padding: EdgeInsets.zero,
                  ),
          ],
        );
      },
    );
  }

  _webCamDisplay() {
    return MyCard(
        child: SizedBox(
      height: this.playerHeight,
      width: this.playerWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: IjkPlayer(
          mediaController: widget.controller,
          controllerWidgetBuilder: (mediaController) {
            return DefaultIJKControllerWidget(
              controller: widget.controller,
              verticalGesture: false,
              horizontalGesture: false,
            );
          },
        ),
      ),
    ));
  }

  _displayWebCam({@required String url}) async {
    if (url == null) {
      return Fluttertoast.showToast(msg: "摄像头不在线");
    }
    Fluttertoast.showToast(msg: "正在加载直播信号");
    await widget.controller.stop();
    await widget.controller.setNetworkDataSource(url, autoPlay: true);
    await widget.controller.play();
  }
}

class _ViewModel {
  List param;

  _ViewModel({this.param});

  factory _ViewModel.create(Store<MainState> store) {
    return _ViewModel(
      param: store.state.robotInfoState.param,
    );
  }
}
