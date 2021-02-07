import 'dart:io';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:robot_platform/services/infrared_service.dart';
import 'dart:convert';
import 'package:package_info/package_info.dart';
import 'package:device_info/device_info.dart';
import 'package:robot_platform/services/update_service.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:extended_tabs/extended_tabs.dart';

class TestPage extends StatefulWidget {
  TestPage({Key key}) : super(key: key);

  @override
  _TestPageState createState() {
    return _TestPageState();
  }
}

class _TestPageState extends State<TestPage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  VlcPlayerController _vlcPlayerController;
  bool isPlay = false;
  int currentPage = 0;
  List<String> tabList = [
    "外围小黑",
    "7楼巡逻小黑",
    "大白1号",
    "大白2号",
    "大白3号",
    "大白4号",
  ];

  @override
  void initState() {
    _tabController = new TabController(length: tabList.length, vsync: this);
    _tabController.addListener(() async {
      if(await _vlcPlayerController.isPlaying()){
        _vlcPlayerController.stop();
        setState(() {
          this.isPlay = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() async {
    _vlcPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabList.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text("IFS 国金中心"),
            backgroundColor: Colors.blue,
            bottom: ExtendedTabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              onTap: (index){
                setState(() {
                  this.currentPage = index;
                });
              },
              tabs: [
                Tab(text: "外围小黑",),
                Tab(text: "7楼巡逻小黑",),
                Tab(text: "大白1号",),
                Tab(text: "大白2号"),
                Tab(text: "大白3号"),
                Tab(text: "大白4号"),
              ],
            ),
          ),
          body: ExtendedTabBarView(
            controller: _tabController,
            cacheExtent: 1,
            children: this.tabList.map((e){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(e),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * (9 / 16),
                    child: this.isPlay
                        ? VlcPlayer(
                      controller: _vlcPlayerController,
                      aspectRatio: 16 / 9,
                      placeholder: Center(child: CircularProgressIndicator()),
                    )
                        : Image.network(
                      "https://pic1.zhimg.com/v2-d9fc437d3d4a89ca85c3a5dd7201787f_1440w.jpg?source=172ae18b",
                      fit: BoxFit.cover,
                    ),
                  ),
                  FlatButton(
                      onPressed: () => _stopIjkMediaPlayer(), child: Text("暂停")),
                  FlatButton(onPressed: () => _getNetworkReady(), child: Text("播放")),
                ],
              );
            }).toList(),
          ),
        ),
    );
  }

  _getNetworkReady() async {
    if (this.isPlay) {
      await _vlcPlayerController.stop();
      await _vlcPlayerController.setMediaFromNetwork("https://flvopen.ys7.com:9188/openlive/6d40ed3f4601403eaa5086069328b70d.hd.flv");
      await _vlcPlayerController.play();
    } else {

      _vlcPlayerController = VlcPlayerController.network(
        "https://flvopen.ys7.com:9188/openlive/6d40ed3f4601403eaa5086069328b70d.hd.flv",
        hwAcc: HwAcc.AUTO,
        autoPlay: true,
        options: VlcPlayerOptions(),
      );
      setState(() {
        this.isPlay = true;
      });
    }
  }

  _stopIjkMediaPlayer() async {
    bool isPlaying = await _vlcPlayerController.isPlaying();

    if (isPlaying) {
      await _vlcPlayerController.pause();
    } else {
      await _vlcPlayerController.play();
    }
  }

  _continuePlayer() async {
    await _vlcPlayerController.play();
  }
}
