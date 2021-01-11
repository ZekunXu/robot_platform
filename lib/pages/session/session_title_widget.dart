import 'package:flutter/material.dart';

class SessionTitle extends StatefulWidget {
  final String text;
  final double fontSize;

  SessionTitle({Key key, @required this.text, this.fontSize}) : super(key: key);

  _SessionTitleState createState() => _SessionTitleState();
}

class _SessionTitleState extends State<SessionTitle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      textAlign: TextAlign.left,
      style: TextStyle(
          fontSize: widget.fontSize ?? 16,
          fontWeight: FontWeight.bold),
    );
  }
}
