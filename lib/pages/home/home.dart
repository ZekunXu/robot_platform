import 'package:another_flushbar/flushbar.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:robot_platform/widgets/common_card.dart';
import 'package:robot_platform/services/robot_info_service.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  TabController _tabController;
  VlcPlayerController _vlcPlayerController;
  bool isPlay = false;
  bool isPause = true;
  bool tabControllerIsInitialized = false;
  List robotInfoList = [];
  Future getRobotList;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    getRobotList = _getRobotList();
  }

  @override
  void dispose() async {
    super.dispose();
    _tabController.dispose();
    await _vlcPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    super.build(context);

    return FutureBuilder(
        future: getRobotList,
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.done:
              this.robotInfoList = snapshot.data;
              _tabController = new TabController(length: robotInfoList.length, vsync: this, initialIndex: this.currentPage);
              _tabController.addListener(() {
                /// 如果当前 controller 正在播放，则需要首先停止，再切换当前 page
                if (isPlay) {
                  _vlcPlayerController.stop();
                  setState(() {
                    this.isPlay = false;
                    this.isPause = true;
                  });
                }
                setState(() {
                  this.currentPage = _tabController.index;
                });
              });

              return Scaffold(
                appBar: AppBar(
                  title: Text("IFS 国金中心"),
                  bottom: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabs: this.robotInfoList.map((e){
                      return Tab(child: Text(e["name"]),);
                    }).toList(),
                  ),
                ),
                body: TabBarView(
                  controller: _tabController,
                  children: this.robotInfoList.map((e) {
                    return RefreshIndicator(
                      onRefresh: () => _refresh(hardwareID: e["hardwareID"]),
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Column(
                            children: [
                              RobotInfoCard(robotInfo: e),
                              Padding(padding: EdgeInsets.only(top: 10),),
                              RobotWebCamCard(
                                vlcPlayerController: _vlcPlayerController,
                                webCams: e["WebCams"],
                                isPlay: this.isPlay,
                                isPause: this.isPause,
                                isPauseCallback: (bool value){
                                  setState(() {
                                    this.isPause = value;
                                  });
                                },
                                vlcPlayerControllerCallback: (url)=> _initializeVlcPlayer(url: url),
                              ),
                              Padding(padding: EdgeInsets.only(top: 10),),
                              RobotLocationCard(GPSLocation: e["GPSLocation"],),
                              Padding(padding: EdgeInsets.only(bottom: 100)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            default:
              return Center(child: CircularProgressIndicator(),);
          }
        }
    );
  }

  _initializeVlcPlayer({@required String url}) async {
    _vlcPlayerController = VlcPlayerController.network(
      url,
      hwAcc: HwAcc.FULL,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
    setState(() {
      this.isPlay = true;
      this.isPause = false;
    });
  }

  _getRobotList () async {
    return await getRobotInfoToList();
  }

  _refresh({String hardwareID}) async {

    /// 如果当前 controller 正在播放，则让他停止
    if (isPlay) {
      _vlcPlayerController.stop();
      setState(() {
        this.isPlay = false;
        this.isPause = true;
      });
    }

    await updateRobotInfoById(hardwareID: hardwareID).then((value){
      setState(() {
        this.robotInfoList[_tabController.index] = value;
      });
    });
  }

  bool get wantKeepAlive=>true;
}


class RobotInfoCard extends StatefulWidget {

  Map robotInfo;

  RobotInfoCard({Key key, @required this.robotInfo}): super(key: key);

  @override
  _RobotInfoCardState createState() {
    return _RobotInfoCardState();
  }

}

class _RobotInfoCardState extends State<RobotInfoCard> {

  @override
  Widget build(BuildContext context) {

    String _realtimeStatus = _getRobotStatus(realtimeStatus: widget.robotInfo["realtimeStatus"]);
    String _robotType = _getRobotType(robotType: widget.robotInfo["hardwareType"]);


    return MyCard(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(Icons.android_outlined, color: Theme.of(context).primaryIconTheme.color),
                  ),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Text(widget.robotInfo["name"], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Text("实时状态", style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.caption.color),),
              Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: Colors.blue,
                  ),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Text(widget.robotInfo["status"] == "online" ? _realtimeStatus : "离线", style: TextStyle(fontSize: 16),),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Text("当前电量", style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.caption.color),),
              Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                children: [
                  Text("${widget.robotInfo["power"]??0}%", style: TextStyle(fontSize: 16),),
                  Spacer(),
                  Text(formatDate(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.robotInfo["powerUpdateTime"])), [mm, "月", dd, "日 ", HH, ":", nn, ":", ss]), style: TextStyle(color: Theme.of(context).textTheme.caption.color),)
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Text("机器人类型", style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.caption.color),),
              Padding(padding: EdgeInsets.only(top: 5)),
              Text(_robotType, style: TextStyle(fontSize: 16),),
            ],
          ),
        ),
      ),
    );
  }

  String _getRobotStatus({@required String realtimeStatus}) {
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
}


class RobotWebCamCard extends StatefulWidget {

  List webCams;
  bool isPlay;
  bool isPause;
  Function(bool) isPauseCallback;
  Function(String) vlcPlayerControllerCallback;
  VlcPlayerController vlcPlayerController;

  RobotWebCamCard({Key key, this.webCams, this.isPlay, this.isPause, this.isPauseCallback, this.vlcPlayerController, this.vlcPlayerControllerCallback}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RobotWebCamCardState();
  }
}

class _RobotWebCamCardState extends State<RobotWebCamCard> {

  int _currentButton;

  @override
  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width - 20.0;
    final List _buttonLength = Iterable<int>.generate(widget.webCams.length).toList();
    final Icon _pauseIcon = Icon(Icons.play_arrow, color: Theme.of(context).accentIconTheme.color,);
    final Icon _playIcon = Icon(Icons.pause, color: Theme.of(context).accentIconTheme.color,);

    return MyCard(
      child: Column(
        children: [
          SizedBox(
            width: _width,
            height: _width * (9/16),
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
              child: Stack(
                children: [
                  SizedBox(
                    width: _width,
                    child: widget.isPlay
                        ? VlcPlayer(
                      controller: widget.vlcPlayerController,
                      aspectRatio: 16 / 9,
                      placeholder:
                      Center(child: CircularProgressIndicator()),
                    )
                        : Image.network(
                      "http://www.chenkeai.com:3001/assets/appImgs/webcam_placeholder.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: IconButton(
                      onPressed: () => _pauseAndPlayController(),
                      icon: widget.isPause ? _pauseIcon : _playIcon,
                      iconSize: 35,
                      padding: EdgeInsets.zero,
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          Wrap(
            children: _buttonLength.map((index){
              String _url = widget.webCams[index]["url"];
              String _name = widget.webCams[index]["name"];
              return FlatButton(
                  onPressed: (){
                    setState(() {
                      this._currentButton = index;
                    });
                    Flushbar(
                      title: "开始直播",
                      message: "直播信号加载中，请闹心等待",
                      flushbarPosition: FlushbarPosition.TOP,
                      duration: Duration(seconds: 2),
                    );
                    _getNetworkReady(url: _url);
                  },
                  child: Text(_name),
                textColor: _currentButton == index ? Theme.of(context).buttonTheme.colorScheme.primary : Theme.of(context).buttonTheme.colorScheme.onSurface,
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  _getNetworkReady({@required String url}) async {
    if (widget.isPlay) {
      await widget.vlcPlayerController.stop();
      widget.isPauseCallback(true);
      await widget.vlcPlayerController.setMediaFromNetwork(
          url);
      await widget.vlcPlayerController.play();
      widget.isPauseCallback(false);
    } else {
      widget.vlcPlayerControllerCallback(url);
    }
  }

  void _pauseAndPlayController() async {
    // 如果用户根本没有开始打开直播就点这个按钮，应该是无效的。
    if (!widget.isPlay) {
      return null;
    }

    bool isPlaying = await widget.vlcPlayerController.isPlaying();

    if (isPlaying) {
      await widget.vlcPlayerController.pause();
    } else {
      await widget.vlcPlayerController.play();
    }
    widget.isPauseCallback(!widget.isPause);
  }
}

class RobotLocationCard extends StatefulWidget {

  Map GPSLocation;

  RobotLocationCard({Key key, this.GPSLocation}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RobotLocationCardState();
  }
}

class _RobotLocationCardState extends State<RobotLocationCard> {


  List<Widget> _approvalNumberWidget = List<Widget>();

  @override
  Widget build(BuildContext context) {
    final double _initLatitude = 28.192646244226978;
    final double _initLongitude = 112.97670573437703;

    final CameraPosition _kInitialPosition = CameraPosition(
      target: LatLng(widget.GPSLocation["latitude"] ?? _initLatitude, widget.GPSLocation["longitude"] ?? _initLongitude),
      zoom: 16.0,
    );

    LatLng _initGPS = LatLng(widget.GPSLocation["latitude"] ?? _initLatitude, widget.GPSLocation["longitude"] ?? _initLongitude);

    AMapWidget map = AMapWidget(
      gestureRecognizers: {
        Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
        ),
      },
      compassEnabled: true,
      initialCameraPosition: _kInitialPosition,
      onMapCreated: onMapCreated,
      myLocationStyleOptions: MyLocationStyleOptions(
          true
      ),
      onCameraMove: (cameraPosition){
        print("--------------$cameraPosition");
      },
    );


    return MyCard(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: map,
            ),
            Positioned(
                bottom: 20,
                right: 20,
                child: IconButton(
                  iconSize: 30,
                  icon: Icon(Icons.my_location, color: Theme.of(context).primaryColor,),
                  onPressed: (){
                    _mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _initGPS, zoom: 17.0)), duration: 250);
                  },
                )),
            Center(
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  AMapController _mapController;
  void onMapCreated(AMapController controller) {
    setState(() {
      _mapController = controller;
      getApprovalNumber();
    });
  }

  /// 获取审图号
  void getApprovalNumber() async {
    //普通地图审图号
    String mapContentApprovalNumber =
    await _mapController?.getMapContentApprovalNumber();
    //卫星地图审图号
    String satelliteImageApprovalNumber =
    await _mapController?.getSatelliteImageApprovalNumber();
    setState(() {
      if (null != mapContentApprovalNumber) {
        _approvalNumberWidget.add(Text(mapContentApprovalNumber));
      }
      if (null != satelliteImageApprovalNumber) {
        _approvalNumberWidget.add(Text(satelliteImageApprovalNumber));
      }
    });
    print('地图审图号（普通地图）: $mapContentApprovalNumber');
    print('地图审图号（卫星地图): $satelliteImageApprovalNumber');
  }
}