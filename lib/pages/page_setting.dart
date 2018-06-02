/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/31 上午9:49
 */

import 'package:flutter/material.dart';
import 'package:flutter_gank/constant/colors.dart';
import 'package:flutter_gank/widget/dialogs.dart';
import 'package:flutter_gank/widget/item_gank.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../App.dart';

class SettingPage extends StatefulWidget {
  final Color themeColor;

  SettingPage({this.themeColor});

  @override
  _SettingPageState createState() => new _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  SharedPreferences preferences;
  bool autoRefresh = false;

  Color _currentColor = new Color(0xff443a49);

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
        title: new Text(title,style: Theme.of(context).textTheme.subhead,),
        icon: new Icon(
          icon,
          color: Colors.white,
          size: 18.0,
        ),
        onClick: onClick);
  }

  void _clickAboutMe() {
    showDialog(
        context: context,

        child: new SimpleDialog(
            title: new Text("作者"),

            children: <Widget>[new AboutMeDialog()],
            contentPadding: new EdgeInsets.all(10.0)));
  }

  void _clickEmail() {}

  void _clickShare() {
    Share.share('这是一个使用flutter写的干货集中营客户端');
  }

  void _clickColorSelect() {
    // raise the [showDialog] widget
    showDialog(
      context: context,
      child: new AlertDialog(
        title: const Text('选择主题颜色'),
        content: new SingleChildScrollView(
          child: new ColorPicker(
            pickerColor: _currentColor,
            onColorChanged: (color) => setState(() {
                  _currentColor = color;
                }),
            enableLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('确定'),
            onPressed: () {
              App.of(context).changeThemeColor(_currentColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new Container(
            height: 30.0,
            decoration: new BoxDecoration(
                border: new Border(
                    bottom:
                    const BorderSide(color: COLOR_DIVIDER, width: 0.4)))),
        _buildSwitch("夜间模式", Icons.brightness_2, Colors.blueGrey,
            App.of(context).night, (val) {
              preferences.setBool("isNight", val);
              App.of(context).night = val;
            }),
        _buildSwitch(
            "进入刷新数据", Icons.wb_cloudy, Colors.orangeAccent, autoRefresh,
                (val) {
              this.autoRefresh = val;
              preferences.setBool("autoRefresh", autoRefresh);
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
        _buildInter(
            "主题颜色", Icons.border_color, Colors.cyanAccent, _clickColorSelect),
        _buildInter("反馈", Icons.email, Colors.purpleAccent, _clickEmail),
        _buildInter("分享", Icons.share, Colors.teal, _clickShare),
        _buildInter("关于我", Icons.person, Colors.redAccent, _clickAboutMe),
        new Container(
            height: 30.0,
            decoration: new BoxDecoration(
                border: new Border(
                    top: const BorderSide(color: COLOR_DIVIDER, width: 0.4))))
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((val) {
      preferences = val;
      autoRefresh = preferences.getBool("autoRefresh") ?? false;
    });
  }
}
