/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/31 上午9:52
 */

import 'package:flutter/material.dart';
import 'package:flutter_gank/constant/colors.dart';

class SettingItem extends StatefulWidget {
  final bool isSwitch;

  final Widget title, icon, right;

  final Color iconBgColor;

  final bool value;

  final Function onChange, onClick;

  SettingItem(
      {this.value,
      this.onChange,
      this.onClick,
      this.iconBgColor,
      this.isSwitch: false,
      this.title,
      this.icon,
      this.right: const Icon(Icons.arrow_forward, color: Colors.grey)});

  @override
  _SettingItemState createState() => new _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.white,
      child: new Container(
        decoration: new BoxDecoration(
            border: new Border(
                bottom: new BorderSide(color: COLOR_DIVIDER, width: 0.3))),
        child: new ListTile(
          onTap: () {
            if (widget.onClick != null) {
              widget.onClick();
            }
          },
          enabled: true,
          title: widget.title,
          leading: new ClipRRect(
            borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
            child: new Container(
              width: 30.0,
              height: 30.0,
              color: widget.iconBgColor,
              child: widget.icon,
            ),
          ),
          trailing: widget.isSwitch
              ? new Switch(value: widget.value, onChanged: widget.onChange)
              : widget.right,
        ),
      ),
    );
  }
}
