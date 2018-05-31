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

  bool isNight=false;

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new SettingItem(title: new Text('标题一'),icon: const Icon(Icons.add)),
        new SettingItem(title: new Text('标题二'),icon: const Icon(Icons.add),isSwitch: true,value:isNight ,onChange: (ccc){

          this.isNight = ccc;
          setState(() {

          });

        },)
      ],
    );
  }
}
