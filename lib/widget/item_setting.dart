/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/31 上午9:52
 */

import 'package:flutter/material.dart';

class SettingItem extends StatefulWidget {
  final bool isSwitch;

  final Widget title, icon, right;

  final bool value;

  final Function onChange, onClick;

  SettingItem(
      {this.value,
      this.onChange,
      this.onClick,
      this.isSwitch: false,
      this.title,
      this.icon,
      this.right: const Icon(Icons.arrow_right, color: Colors.grey)});

  @override
  _SettingItemState createState() => new _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new ListTile(
        onTap: () {
          if(widget.onClick!=null){
            widget.onClick();
          }
        },
        enabled: true,
        title: widget.title,
        leading: widget.icon,
        trailing: widget.isSwitch
            ? new Switch(value: widget.value, onChanged: widget.onChange)
            : widget.right,
      ),
    );
  }
}
