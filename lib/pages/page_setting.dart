/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/31 上午9:49
 */

import 'package:flutter/material.dart';
import 'package:flutter_gank/constant/colors.dart';
import 'package:flutter_gank/widget/dialogs.dart';
import 'package:flutter_gank/widget/item_setting.dart';
import 'package:share/share.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => new _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isNight = false;
  bool autoRefresh = false;

  Widget _buildSwitch(String title, IconData icon, Color iconColor, bool value,
      Function onChange) {
    return new SettingItem(
        iconBgColor: iconColor,
        title: new Text(
          title,
          style: Theme.of(context).textTheme.subhead,
        ),
        icon: new Icon(icon, color: Colors.white, size: 18.0),
        isSwitch: true,
        value: value,
        onChange: onChange);
  }

  Widget _buildInter(
      String title, IconData icon, Color iconColor, Function onClick) {
    return new SettingItem(
        iconBgColor: iconColor,
        title: new Text(title),
        icon: new Icon(
          icon,
          color: Colors.white,
          size: 18.0,
        ),
        onClick: onClick);
  }

  void _clickAboutMe() {
    showDialog(context: context,child: new SimpleDialog(title: new Text("作者"),
    children: <Widget>[
      new AboutMeDialog()
    ],contentPadding: new EdgeInsets.all(10.0)));
  }

  void _clickEmail() {}

  void _clickShare() {
    print("doit");
    Share.share('这是一个使用flutter写的干货集中营客户端');
  }

  void _clickColorSelect() {}

  @override
  Widget build(BuildContext context) {
    return new Container(
      color:COLOR_BG,
      child:         new ListView(
        children: <Widget>[
          new Container(
              height: 30.0,
              decoration: new BoxDecoration(
                  border: new Border(
                      bottom: const BorderSide(
                          color: COLOR_DIVIDER, width: 0.4)))),
          _buildSwitch("夜间模式", Icons.brightness_2, Colors.blueGrey, isNight,
                  (val) {
                this.isNight = val;
                setState(() {});
              }),
          _buildSwitch(
              "进入刷新数据", Icons.wb_cloudy, Colors.orangeAccent, autoRefresh,
                  (val) {
                this.autoRefresh = val;
                setState(() {});
              }),
          new Container(
            height: 30.0,
            decoration: new BoxDecoration(
                border: new Border(
                    top: const BorderSide(color: COLOR_DIVIDER, width: 0.4),
                    bottom:
                    const BorderSide(color: COLOR_DIVIDER, width: 0.4))),
          ),
          _buildInter("主题颜色", Icons.border_color, Colors.cyanAccent,
              _clickColorSelect),
          _buildInter("反馈", Icons.email, Colors.purpleAccent, _clickEmail),
          _buildInter("分享", Icons.share, Colors.teal, _clickShare),
          _buildInter("关于我", Icons.person, Colors.redAccent, _clickAboutMe),
          new Container(
              height: 30.0,
              decoration: new BoxDecoration(
                  border: new Border(
                      top: const BorderSide(
                          color: COLOR_DIVIDER, width: 0.4))))
        ],
      ),
    );
  }
}
