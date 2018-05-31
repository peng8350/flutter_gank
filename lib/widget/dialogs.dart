/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/31 下午3:32
 */

import 'package:flutter/material.dart';

import 'dart:math' as math;

class TagFlowDeletegate extends FlowDelegate {
  double width = 0.0;
  double height = 0.0;
  @override
  void paintChildren(FlowPaintingContext context) {
    // TODO: implement paintChildren
    for (int i = 0; i < context.childCount; i++) {
      Matrix4 transform = new Matrix4.identity()..translate(width, height, 0.0);
      context.paintChild(i, transform: transform);
      width += context.getChildSize(i).width + 10.0;
      if (i < context.childCount - 1 &&
          width + context.getChildSize(i + 1).width > context.size.width) {
        width = 0.0;
        height += 40.0;
      }
    }
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    BoxConstraints boxConstraints = new BoxConstraints(
        maxHeight: constraints.maxHeight, maxWidth: constraints.maxWidth);
    return boxConstraints;
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    // TODO: implement shouldRepaint
    return this != oldDelegate;
  }
}

class AboutMeDialog extends StatelessWidget {
  List<String> tags = [
    "码农",
    "搬砖",
    "在校大学生",
    "专业逃课",
    "渣键盘爱好者",
    "青年",
    "爱好:女",
    "攻城狮",
    "Java",
    "DART",
    "C++",
    "Android",
    "IOS",
    "移动端Web",
    "React Native",
    "Flutter"
  ];
  List<Color> randomColors = [
    Colors.grey,
    Colors.tealAccent,
    Colors.blueGrey,
    Colors.green,
    Colors.purpleAccent,
    Colors.amberAccent,
    Colors.deepOrangeAccent,
    Colors.yellowAccent
  ];

  List<Widget> widgets = [];

  @override
  Widget build(BuildContext context) {
    math.Random random = new math.Random();
    for (String s in tags)
      widgets.add(new Container(
        decoration: new BoxDecoration(
            color: randomColors[random.nextInt(7)], borderRadius: new BorderRadius.circular(10.0)),
        padding: new EdgeInsets.all(5.0),
        child: new Text(
          s,
          style: new TextStyle(inherit: true, color: Colors.white),
        ),
      ));
    return new Column(
      children: <Widget>[
        new CircleAvatar(
          backgroundImage: new NetworkImage(
              'https://avatars3.githubusercontent.com/u/19425362?s=460&v=4'),
          radius: 50.0,
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(Icons.email, color: Colors.grey),
            new Text('  peng8350@gmail.com')
          ],
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(Icons.home, color: Colors.grey),
            new Text('  http://peng8350.cn/')
          ],
        ),
        new Container(
          height: 200.0,
          child: new Flow(
            delegate: new TagFlowDeletegate(),
            children: widgets,
          ),
        )
      ],
    );
  }
}
