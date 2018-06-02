/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/6/2 下午1:21
 */

import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final Function onChangeText;
  TextEditingController _controller;

  SearchBar({this.onChangeText})
      : _controller = new TextEditingController(text: "we");

  @override
  Widget build(BuildContext context) {
    return new TextField(
      controller: _controller,
      enabled: true,
      onChanged: (String str) {
        if (onChangeText != null) onChangeText(str);
      },
      decoration: new InputDecoration(
          hintText: "search Gank",
          border: new UnderlineInputBorder(
              borderRadius: new BorderRadius.circular(1.0),
              borderSide: new BorderSide()),
          suffixIcon: const Icon(Icons.add),
          prefixIcon: const Icon(Icons.search)),
    );
  }
}
