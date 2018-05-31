/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/31 下午1:20
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gank/utils/utils_http.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>  with HttpUtils{
  bool showAlignmentCards = false;

  Future<String> getData(){
    return get("http://gank.io/api/history/content/1/1");
  }

  @override
  Widget build(BuildContext context) {

    return new FutureBuilder(builder: (context,asyc){
      if(!asyc.hasData){
        return new Center(
          child: new CircularProgressIndicator(),
        );
      }
      else{
        return new ListView(
            children: <Widget>[new HtmlView(
              data: json.decode(asyc.data)["results"][0]["content"],
            )]
        );
      }
    },future: getData());
  }
}
