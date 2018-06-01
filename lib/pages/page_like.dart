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



  Widget _buildGankList(){
    return new ListView.builder(

    )
  }

  Widget _buildGirlList(){
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
