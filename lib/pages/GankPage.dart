import 'package:flutter/material.dart';


class GankPage extends StatefulWidget {

  final String title;

  GankPage({this.title,Key key}):super(key:key);

  @override
  _GankPageState createState() => new _GankPageState();
}

class _GankPageState extends State<GankPage> {
  @override
  Widget build(BuildContext context) {

    return new Container(
      child: new Text(widget.title),
    );
  }
}
