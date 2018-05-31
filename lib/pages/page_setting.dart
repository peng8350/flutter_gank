/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/31 上午9:49
 */

import 'package:flutter/material.dart';
import 'package:flutter_gank/widget/item_setting.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => new _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isNight = false;
  bool autoRefresh = false;

  Widget _buildSwitch(
      String title, IconData icon, bool value, Function onChange) {
    return new SettingItem(
        title: new Text(title,style: Theme.of(context).textTheme.subhead,),
        icon: new Icon(icon),
        isSwitch: true,
        value: value,
        onChange: onChange);
  }



  Widget _buildInter(String title, IconData icon, Function onClick) {
    return new SettingItem(
        title: new Text(title), icon: new Icon(icon), onClick: onClick);
  }

  void _clickAboutMe(){

  }

  void _clickEmail(){

  }

  void _clickShare(){

  }

  void _clickColorSelect(){

  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[new Column(
        children: <Widget>[
          new Container(
            height: 30.0,
          )
          ,
          _buildSwitch("夜间模式", Icons.brightness_2, isNight, (val) {
            this.isNight = val;
            setState(() {});
          }),
          _buildSwitch("进入刷新数据", Icons.wb_cloudy, autoRefresh, (val) {
            this.autoRefresh = val;
            setState(() {});
          }),
          new Container(
            height: 30.0,
          )
          ,
          _buildInter("主题颜色", Icons.border_color, _clickColorSelect),
          _buildInter("反馈", Icons.email, _clickEmail),
          _buildInter("分享", Icons.share, _clickShare),
          _buildInter("关于我", Icons.person , _clickAboutMe)
        ],
      )],
    );
  }
}
