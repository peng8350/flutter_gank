/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/6/1 下午8:01
 */

import 'package:flutter/material.dart';
import 'package:flutter_gank/constant/colors.dart';
import 'package:flutter_gank/constant/strings.dart';

class LikePage extends StatefulWidget {
  @override
  _LikePageState createState() => new _LikePageState();
}

class _LikePageState extends State<LikePage> {
  int _selectIndex = 0;

  Widget _buildGankList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        return new GankGroup(
          GANK_TITLES[index],
          children: <Widget>[new Text('dddd')],
        );
      },
      itemCount: 7,
    );
  }

  Widget _buildGirlList() {
    return new Container();
  }

  Widget _buildContent() {
    return new Stack(
      children: <Widget>[
        new Offstage(
          offstage: _selectIndex != 0,
          child: _buildGankList(),
        ),
        new Offstage(
          offstage: _selectIndex != 1,
          child: _buildGirlList(),
        )
      ],
    );
  }

  Widget _buildBottom() {
    return new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.insert_photo,
                  color: _selectIndex == 0 ? DEFAULT_THEMECOLOR : Colors.grey),
              title: new Text(
                '妹子',
                style: new TextStyle(
                    inherit: true,
                    color:
                        _selectIndex == 0 ? DEFAULT_THEMECOLOR : Colors.grey),
              )),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.explore,
                  color: _selectIndex == 1 ? DEFAULT_THEMECOLOR : Colors.grey),
              title: new Text(
                '干货',
                style: new TextStyle(
                    inherit: true,
                    color:
                        _selectIndex == 1 ? DEFAULT_THEMECOLOR : Colors.grey),
              ))
        ],
        onTap: (index) {
          _selectIndex = index;
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[new Flexible(child: _buildContent()), _buildBottom()],
    );
  }
}

class GankGroup extends StatefulWidget {
  final groupName;

  final bool isOpen;

  final List<Widget> children;

  GankGroup(String groupName, {this.children, this.isOpen:true})
      : this.groupName = groupName;

  @override
  _GankGroupState createState() => new _GankGroupState();
}

class _GankGroupState extends State<GankGroup>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    _controller = new AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        lowerBound: 0.75,
        value: widget.isOpen ? 1.0 : 0.75);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new ExpansionTile(
      title: new Text(widget.groupName),
      children: widget.children,
      onExpansionChanged: (val) {
        _controller.animateTo(val ? 1.0 : 0.75);
      },
      initiallyExpanded: widget.isOpen,
      trailing: new Icon(
        Icons.keyboard_arrow_right,
      ),
      leading: new RotationTransition(
          turns: _controller, child: new Icon(Icons.arrow_drop_down_circle)),
    );
  }
}
