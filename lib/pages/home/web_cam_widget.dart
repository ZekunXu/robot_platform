import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:robot_platform/services/haikang_service.dart';
import 'package:robot_platform/widgets/common_card.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'dart:convert';

class WebCamWidget extends StatefulWidget {
  WebCamWidget({Key key}) : super(key: key);

  @override
  _WebCamWidgetState createState() {
    return _WebCamWidgetState();
  }
}

class _WebCamWidgetState extends State<WebCamWidget> {
  List urlList = [];
  String token;
  IjkMediaController controller = IjkMediaController();

  @override
  void initState() {
    _getUrls();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "固定摄像头",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        this.urlList.length > 0
            ? GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: this.urlList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.80),
                itemBuilder: (context, index) {
                  if (this.urlList[index]["status"] != 1) {
                    return MyCard(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.asset(
                          "images/offline.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    controller.stop();
                    controller.setNetworkDataSource(urlList[index]["rtmp"]);
                    controller.play();
                    return MyCard(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: IjkPlayer(
                        mediaController: controller,
                      ),
                    ));
                  }
                  return null;
                })
            : MyCard(
                child: CircularProgressIndicator(),
              ),
      ],
    );
  }

  ///此方法用于通过海康接口获取摄像头状态、名称、和直播地址。
  ///1. 获取设备的 token
  ///2. 获取账号下的设备号，生成 list
  ///3. 获取直播地址 url
  _getUrls() async {
    await getToken().then((value) {
      String token = value.data["data"]["accessToken"];
      setState(() {
        this.token = token;
      });
      return getDeviceStatus(token: token);
    }).then((value) {
      var idList = value.data["data"].map((e) => e["deviceSerial"]).toList();

      return getUrlByDeviceId(idList: idList, token: this.token);
    }).then((value) {
      print(value.data);
      setState(() {
        this.urlList = value.data["data"]
            .map((e) => {
                  "name": e["deviceName"],
                  "rtmp": e["rtmp"],
                  "status": e["status"]
                })
            .toList();
      });
    });
  }
}
