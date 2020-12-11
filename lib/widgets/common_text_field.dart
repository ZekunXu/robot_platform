/// 这是自定义的输入框样式
/// version: 1.0.0
/// 最后修改日期: 2020年12月6日

import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  /// [hintText] 是未输入时候的提示文字，为必填项 @required，继承自 [TextField] 的相同方法
  /// [onChanged] 是用户的输入过程中处理变化的方法，继承自 [TextField] 的相同方法
  final String hintText;
  final Function onChanged;

  MyTextField({Key key, @required this.hintText, this.onChanged})
      : super(key: key);
  _MyTextField createState() => _MyTextField();
}

class _MyTextField extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: widget.hintText,
      ),
      onChanged: widget.onChanged,
    );
  }
}
