/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/31 下午1:20
 */

import 'package:flutter/material.dart';
import 'package:flutter_gank/utils/utils_http.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
    with HttpUtils, SingleTickerProviderStateMixin {
  bool showAlignmentCards = false;
  TabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    _controller = new TabController(length: 7, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return new MaterialButton(child: new Text('sdsdsdsd'),onPressed: (){
      showBottomSheet(context: context, builder: (context){
        return new Text('sdsds');
      });
    },);
  }
}
