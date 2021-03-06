import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:robot_platform/widgets/common_card.dart';

class AlarmWidget extends StatefulWidget {
  final String title;
  final Color messageColor;
  final List alarmMessage;

  AlarmWidget(
      {Key key,
      @required this.title,
      @required this.alarmMessage,
      this.messageColor})
      : super(key: key);

  @override
  _AlarmWidgetState createState() => _AlarmWidgetState();
}

class _AlarmWidgetState extends State<AlarmWidget> {
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
          child: Text(
            widget.title,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        MyCard(
            child: Container(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.alarmMessage.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: ListTile(
                    onTap: (){},
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      widget.alarmMessage[index]["msg"],
                      style: TextStyle(color: widget.messageColor ?? null),
                    ),
                    subtitle: Text(formatDate(
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(widget.alarmMessage[index]["timestamp"])),
                        [mm, "月", dd, "日  ", HH, ":", nn, ":", ss])),
                  ),
                );
              }),
        )),
      ],
    );
  }
}
