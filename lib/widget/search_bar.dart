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
      : _controller = new TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return new TextField(
      controller: _controller,
      enabled: true,
      onChanged: (String str) {
        if (onChangeText != null) onChangeText(str);
      },
      style: new TextStyle(inherit: true,color: Colors.white),
      decoration: new InputDecoration(
        labelStyle: new TextStyle(inherit: true,color: Colors.white),
          hintText: "search Gank",
          enabled: true,
          filled: true,
          hintStyle: new TextStyle(inherit: true,color: const Color(0xdddddddd)),
          prefixIcon: const Icon(Icons.search,color:Colors.white,size: 18.0,),
          suffixIcon: new InkWell(
            child: new Icon(Icons.clear,color: Colors.white,size: 16.0),
            onTap: (){
              _controller.clear();
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          ),
    );
  }
}
