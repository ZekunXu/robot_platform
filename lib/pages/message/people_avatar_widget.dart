import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PeopleAvatarWidget extends StatefulWidget {

  final List<Color> peopleList;

  PeopleAvatarWidget({Key key, @required this.peopleList}) : super(key: key);

  @override
  _PeopleAvatarWidgetState createState() {
    return _PeopleAvatarWidgetState();
  }
}

class _PeopleAvatarWidgetState extends State<PeopleAvatarWidget> {
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
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.peopleList.length,
        itemBuilder: (context, index){
          return Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                color: widget.peopleList[index],
              ),
            ),
          );
        },
      ),
    );
  }
}