import 'package:flutter/cupertino.dart';
/// 通用的卡片形状。使用圆角矩形的卡片风格，保持了和app设计风格的一致。
/// version: 1.0.0
/// 最后修改时间: 2020年12月5日

import 'package:flutter/material.dart';


class MyCard extends StatefulWidget {

  /// [child] 继承了 [Card] 的相同属性，必填。
  /// [margin] 继承了 [Card] 的内边距，非必填，可以改变内边距。

  final Widget child;
  final BoxBorder border;
  final double height;

  MyCard({Key key, @required this.child, this.border, this.height}) : super(key: key);
  _MyCardState createState ()=> _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: widget.height ?? null,
      decoration: BoxDecoration(
        border: widget.border ?? null,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(197, 198, 199, 0.25),
            offset: Offset(0.0, 3.0),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child: widget.child,
      ),
    );
  }
  
}