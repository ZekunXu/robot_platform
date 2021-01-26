import 'dart:io';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:robot_platform/services/infrared_service.dart';
import 'dart:convert';
import 'package:package_info/package_info.dart';
import 'package:device_info/device_info.dart';
import 'package:robot_platform/services/update_service.dart';
import 'package:install_plugin/install_plugin.dart';

class TestPage extends StatefulWidget {
  TestPage({Key key}) : super(key: key);

  @override
  _TestPageState createState() {
    return _TestPageState();
  }
}

class _TestPageState extends State<TestPage> {
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
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("开始了哦"),
            FutureBuilder(
                future: getLatestInfraredMsg(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(snapshot.data["data"].toString());
                  } else {
                    return Text("loading...");
                  }
                }),
            MaterialButton(
                child: Text("click"),
                onPressed: () async {
                  PackageInfo packageInfo = await PackageInfo.fromPlatform();
                  String version = packageInfo.version;
                  String packageName = packageInfo.packageName;
                  String platform = Platform.isAndroid ? "android" : "ios";
                  getAppUpdateInfo()
                    .then((value) async {
                      var data = json.decode(value.data);
                      if(version == data["data"]["version"]){
                        throw "newest";
                      }
                      Fluttertoast.showToast(msg: "开始下载...");
                      File apkfile = await downloadApp(url: data["data"]["downloadlink"]);
                      String apkFilePath = apkfile.path;
                      if(apkFilePath.isEmpty){
                        throw "download_fail";
                      }
                      InstallPlugin.installApk(apkFilePath, packageName)
                      .then((value){
                        print("install apk $value");
                      })
                      .catchError((err){
                        print("install apk err: $err");
                      });
                  })
                  .catchError((err){
                    switch(err){
                      case "newest":
                        return Fluttertoast.showToast(msg: "当前已经是最新版本");
                        break;
                      case "download_fail":
                        return Fluttertoast.showToast(msg: "下载文件失败");
                      default:
                        return Fluttertoast.showToast(msg: err.toString());
                        break;
                    }
                  });
                }),
            RaisedButton(
              child: Text("通知测试"),
                onPressed: () async {
                PackageInfo packageInfo = await PackageInfo.fromPlatform();
                var build = packageInfo.buildNumber;
                Fluttertoast.showToast(msg: build.runtimeType.toString());
                }
            ),
          ],
        )),
      ),
    );
  }
}
