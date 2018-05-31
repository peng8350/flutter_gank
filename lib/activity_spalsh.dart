/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/6/1 上午1:04
 */
import 'package:flutter/material.dart';
import 'package:flutter_gank/utils/utils_db.dart';

class SpalshActivity extends StatefulWidget {
  @override
  _SpalshActivityState createState() => new _SpalshActivityState();
}

class _SpalshActivityState extends State<SpalshActivity>
    with DbUtils, SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return new ScaleTransition(
        scale: _controller,
        alignment: Alignment.center,
        child: new Image.asset(
          "images/gank.jpg",
          width: double.infinity,
          height: double.infinity,

          centerSlice: new Rect.fromLTWH(200.0, 200.0, 300.0, 300.0),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new AnimationController(
        vsync: this,
        lowerBound: 1.0,
        upperBound: 1.5,
        value: 1.0,
        duration: const Duration(milliseconds: 1000));
    open().then((val) {
      _controller.animateTo(2.0).then((ccc) {
        Navigator.of(context).pushNamed("main");
      });
    });
  }
}
