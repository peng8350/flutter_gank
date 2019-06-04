/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/6/2 下午8:12
 */

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebActivity extends StatelessWidget {

  final String url;

  WebActivity(String url):this.url = url;



  @override
  Widget build(BuildContext context) {
    return  new WebviewScaffold(
        url: url,
        enableAppScheme: true,

        appBar: new AppBar(
          title: new Text("浏览器"),
        ),
      );
  }
}
