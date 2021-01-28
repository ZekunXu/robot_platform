import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:robot_platform/services/img_service.dart';
import 'dart:convert';

class PeopleAvatarWidget extends StatefulWidget {

  final List imgList;

  PeopleAvatarWidget({Key key, @required this.imgList}) : super(key: key);

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
        itemCount: widget.imgList.length,
        itemBuilder: (context, index) {
          return widget.imgList.length > 0 ?Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.all(Radius.circular(10.0))),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Image.network(
                  widget.imgList[index]["url"],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ) : Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}
