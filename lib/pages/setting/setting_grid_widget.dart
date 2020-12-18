import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:robot_platform/widgets/common_card.dart';

class SettingGridWidget extends StatefulWidget {
  final List<String> content;

  SettingGridWidget({Key key, @required this.content}) : super(key: key);

  @override
  _SettingGridWidgetState createState() {
    return _SettingGridWidgetState();
  }
}

class _SettingGridWidgetState extends State<SettingGridWidget> {
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
    return MyCard(
        child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Radius radius = Radius.circular(15.0);
              BorderRadius borderRadius = BorderRadius.zero;

              if (index == 0 && widget.content.length != 1) {
                borderRadius =
                    BorderRadius.only(topLeft: radius, topRight: radius);
              } else if (index == widget.content.length - 1 &&
                  widget.content.length != 1) {
                borderRadius =
                    BorderRadius.only(bottomLeft: radius, bottomRight: radius);
              } else if (widget.content.length == 1) {
                borderRadius = BorderRadius.all(radius);
              }

              return InkWell(
                borderRadius: borderRadius,
                onTap: () {
                  Fluttertoast.showToast(msg: "你点击了 ${widget.content[index]}");
                },
                child: ListTile(
                  title: Text(widget.content[index]),
                ),
              );
            },
            separatorBuilder: (BuildContext context, index) {
              return Divider(
                endIndent: 15.0,
                indent: 15.0,
                height: 0.0,
              );
            },
            itemCount: widget.content.length));
  }
}
