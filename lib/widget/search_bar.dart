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
      autofocus: true,
      style: Theme.of(context).textTheme.body1,
      decoration: new InputDecoration(
        labelStyle: Theme.of(context).textTheme.body1,
          hintText: "search Gank",
          enabled: true,
          filled: true,
          hintStyle: new TextStyle(inherit: true,color: const Color(0xdddddddd)),
          prefixIcon: const Icon(Icons.search,color:Colors.white,size: 18.0,),
          suffixIcon: new InkWell(
            child: new Icon(Icons.clear,color: Colors.white,size: 16.0),
            onTap: (){
              _controller.clear();
              onChangeText("");
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          ),
    );
  }
}
