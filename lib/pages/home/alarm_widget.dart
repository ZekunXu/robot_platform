import 'package:flutter/material.dart';
import 'package:robot_platform/widgets/common_card.dart';

class AlarmWidget extends StatefulWidget {

  final String title;
  final Color messageColor;
  final List<String> alarmMessage;

  AlarmWidget({Key key, @required this.title, @required this.alarmMessage, this.messageColor}) : super(key: key);

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
          child: Text(widget.title, style: TextStyle(fontSize: 20),),
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        MyCard(
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.alarmMessage.length,
                  itemBuilder: (context, index){
                  return Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    alignment: Alignment.centerLeft,
                    child: Text(widget.alarmMessage[index], style: TextStyle(color: widget.messageColor ?? null),),
                  );
                  }
              ),
            )
        ),
      ],
    );
  }
}