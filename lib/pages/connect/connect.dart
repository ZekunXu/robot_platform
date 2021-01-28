import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:robot_platform/widgets/color_theme/my_color.dart';
import 'package:robot_platform/widgets/common_card.dart';

class ConnectPage extends StatefulWidget {
  ConnectPage({Key key}) : super(key: key);

  @override
  _ConnectPageState createState() {
    return _ConnectPageState();
  }
}

class _ConnectPageState extends State<ConnectPage> {
  List deviceList = [
    {"name": "红外报警器001", "status": "在线", "msg": null},
    {"name": "红外报警器002", "status": "离线", "msg": null},
    {"name": "红外报警器003", "status": "在线", "msg": "十分钟前有人经过"}
  ];

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
        child: RefreshIndicator(
          onRefresh: _updateDeviceInfo,
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 30, 15, 30),
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              itemCount: this.deviceList.length,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              itemBuilder: (context, index) {

                Map myColor = {"backgroundColor": null, "textColor": null};

                if(this.deviceList[index]["status"] == "在线" && this.deviceList[index]["msg"] == null) {
                  myColor["backgroundColor"] = Colors.blue;
                  myColor["textColor"] = Colors.white;
                }else if(this.deviceList[index]["status"] == "在线" && this.deviceList[index]["msg"] != null) {
                  myColor["backgroundColor"] = Colors.red;
                  myColor["textColor"] = Colors.white;
                }
                return MyCard(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: myColor["backgroundColor"] ?? Colors.transparent
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(this.deviceList[index]["name"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: myColor["textColor"]),),
                          Padding(padding: EdgeInsets.only(top: 16)),
                          Text(this.deviceList[index]["status"], style: TextStyle(color: myColor["textColor"]),),
                          this.deviceList[index]["msg"] != null
                              ? Container(padding: EdgeInsets.only(top: 10), child: Text(this.deviceList[index]["msg"], style: TextStyle(color: myColor["textColor"]),),)
                              : Padding(padding: EdgeInsets.zero),
                        ],
                      ),
                    ),
                  ),
                );
              },
              staggeredTileBuilder: (index) {
                return StaggeredTile.fit(1);
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateDeviceInfo() async {
    await Future.delayed(Duration(seconds: 2), (){
      setState(() {
        this.deviceList[0]["status"] = "离线";
        this.deviceList[1]["status"] = "在线";
      });
    });

    Fluttertoast.showToast(msg: "更新成功");
  }


}
