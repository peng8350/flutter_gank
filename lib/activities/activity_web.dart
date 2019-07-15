/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/6/2 下午8:12
 */

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebActivity extends StatelessWidget {
  final String url;

  WebActivity(String url) : this.url = url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: url,
      ),
      appBar: AppBar(
        title: Text("浏览器"),
      ),
    );
  }
}
