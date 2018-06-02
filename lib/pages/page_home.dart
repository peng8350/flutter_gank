/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/31 下午1:20
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gank/bean/info_gank.dart';
import 'package:flutter_gank/constant/colors.dart';
import 'package:flutter_gank/utils/utils_http.dart';
import 'package:flutter_gank/widget/cached_pic.dart';
import 'package:flutter_gank/widget/item_gank.dart';
import 'package:flutter_gank/widget/search_bar.dart';
import '../App.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
    with HttpUtils, SingleTickerProviderStateMixin {
  bool showAlignmentCards = false;

  Future _future;

  Map _dataMap;

  List<String> categories = [];

  @override
  void initState() {
    // TODO: implement initState
    _fetch();
    super.initState();
  }

  void _fetch() {
    getToMap("http://gank.io/api/day/history").then((Map dateJson) {
      _future = getToMap("http://gank.io/api/day/" +
          dateJson["results"][0].replaceAll("-", "/")).then((Map todayJson) {
        _dataMap = todayJson;
        for (String s in _dataMap["category"]) {
          categories.add(s);
        }
        setState(() {

        });
      });
    });
  }

  Widget _buildGroupByCategory(String category){
    List<GankInfo> list = [];
    for(Map map in _dataMap["results"][category]){
      list.add(new GankInfo.fromJson(map));
    }
    return new HomeGroup(
      title: category,
      children: list,
    );
  }

  Widget _buildContent() {
    List<Widget> groups= [];
    for(String cate in categories){
      groups.add(_buildGroupByCategory(cate));
    }
    groups.insert(0, new SizedBox(height: 300.0,child: new CachedPic(url: _dataMap["results"]["福利"][0]["url"])));
    return new ListView(children: groups);
  }

  Widget _buildWaiting() {
    return new Center(child: const CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      builder: (context, shot) {
        if (shot.connectionState == ConnectionState.waiting ||
            shot.connectionState == ConnectionState.none) {
          return _buildWaiting();
        } else {
          if (shot.hasError) {
            return new InkWell(
              child: new Center(
                child: new Text('网络异常,点击重新加载'),
              ),
              onTap: () {
                _fetch();
              },
            );
          } else {
            return _buildContent();
          }
        }
      },
      future: _future,
    );
  }
}

