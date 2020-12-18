import 'package:flutter/material.dart';

class ConnectPage extends StatefulWidget {
  ConnectPage({Key key}) : super(key: key);

  @override
  _ConnectPageState createState() {
    return _ConnectPageState();
  }
}

class _ConnectPageState extends State<ConnectPage> {
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
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 30, 15, 30),
          child: Center(
            child: Text("connect page"),
          ),
        ),
      ),
    );
  }
}