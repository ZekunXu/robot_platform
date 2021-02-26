import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';

class TestPage extends StatefulWidget {
  TestPage({Key key}) : super(key: key);

  @override
  _TestPageState createState() {
    return _TestPageState();
  }
}

class _TestPageState extends State<TestPage>{

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(28.192646244226978, 112.97670573437703),
    zoom: 16.0,
  );
  List<Widget> _approvalNumberWidget = List<Widget>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

   AMapWidget map = AMapWidget(
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

    return Scaffold(
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
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
                    _mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(28.192646244226978, 112.97670573437703), zoom: 17.0)), duration: 250);
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