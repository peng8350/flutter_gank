/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/31 下午1:20
 */

import 'package:flutter/material.dart';
import 'package:flutter_gank/utils/utils_http.dart';
import 'package:flutter_gank/widget/search_bar.dart';
import '../App.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
    with HttpUtils, SingleTickerProviderStateMixin {
  bool showAlignmentCards = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return new MaterialButton(
      child: new Text('获取 App'),
      onPressed: (){
      },
    );
  }
}
