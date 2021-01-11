import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:robot_platform/widgets/common_card.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class WebCamWidget extends StatefulWidget {
  WebCamWidget({Key key}) : super(key: key);

  @override
  _WebCamWidgetState createState() {
    return _WebCamWidgetState();
  }
}

class _WebCamWidgetState extends State<WebCamWidget> {

  final List<String> webCamUrl = [
    "https://bing.nanxiongnandi.com/201205/Senganmon.jpg",
    "https://h2.gifposter.com/bingImages/SandiaSunrise_EN-US11331220835_1920x1080.jpg",
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
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text("固定摄像头", style: TextStyle(fontSize: 20),),
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: webCamUrl.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.78),
            itemBuilder: (context, index){
            return MyCard(child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                webCamUrl[index],
                fit: BoxFit.cover,
              ),
            ),);
            }),
      ],
    );
  }
}