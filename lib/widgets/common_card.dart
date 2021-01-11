import 'package:flutter/cupertino.dart';
/// 通用的卡片形状。使用圆角矩形的卡片风格，保持了和app设计风格的一致。
/// version:1.1.0
/// 删除了最外层的 Container，使用 ThemeData 的统一风格。
/// version: 1.0.0
/// 最后修改时间: 2021年1月2日

import 'package:flutter/material.dart';


class MyCard extends StatefulWidget {

  /// [child] 继承了 [Card] 的相同属性，必填。
  /// [margin] 继承了 [Card] 的内边距，非必填，可以改变内边距。

  final Widget child;
  final GestureTapCallback onTap;
  final BoxBorder border;
  final double height;

  MyCard({Key key, @required this.child, this.border, this.height, this.onTap}) : super(key: key);
  _MyCardState createState ()=> _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: widget.onTap ?? null,
        child: widget.child,
      ),
    );
  }
  
}