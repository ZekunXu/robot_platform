import 'package:flutter/material.dart';

class MyButtonWithIcon extends StatefulWidget {

  final IconData icon;
  final String text;
  final Function onPressed;
  final Color color;

  
  MyButtonWithIcon({Key key, this.icon, this.text, this.onPressed, this.color}) : super(key: key);
  _MyButtonWithIconState createState ()=> _MyButtonWithIconState();
}

class _MyButtonWithIconState extends State<MyButtonWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton.icon(
        color: widget.color ?? null,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0)),
        label: Text(widget.text),
        icon: Icon(widget.icon ?? Icons.check),
        onPressed: widget.onPressed,
      ),
    );
  }
  
}