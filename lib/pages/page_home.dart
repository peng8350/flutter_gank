/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/31 下午1:20
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gank/bean/info_gank.dart';
import 'package:flutter_gank/utils/utils_http.dart';
import 'package:flutter_gank/widget/cached_pic.dart';
import 'package:flutter_gank/widget/item_gank.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
    with HttpUtils, SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  bool showAlignmentCards = false;

  Future _future;

  Map _dataMap;

  List<String> categories = [];

  AnimationController _aniController;

  @override
  void initState() {
    // TODO: implement initState
    _fetch();
    _aniController = new AnimationController(
        vsync: this,
        lowerBound: 1.0,
        upperBound: 2.0,
        value: 1.0,
        duration: const Duration(milliseconds: 200));
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
        setState(() {});
      });
    });
  }

  Widget _buildGroupByCategory(String category) {
    List<GankInfo> list = [];
    for (Map map in _dataMap["results"][category]) {
      list.add(new GankInfo.fromJson(map));
    }
    return new HomeGroup(
        title: category,
        children: list,
        icon: category == 'Android'
            ? Icons.android
            : category == '休息视频'
                ? Icons.video_label
                : category == 'App'
                    ? Icons.phone_android
                    : category == '福利'
                        ? Icons.tag_faces
                        : category == '拓展资源'
                            ? Icons.filter_none
                            : category == '前端'
                                ? Icons.language
                                : category == 'iOS'
                                    ? Icons.insert_emoticon
                                    : Icons.layers);
  }

  void _handleScrollEnd(ScrollNotification notifcation) {
    _aniController.animateTo(1.0);
  }

  bool _dispatchEvent(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
    } else if (notification is OverscrollNotification) {
      _aniController.value += -notification.overscroll / 300.0;
    } else if (notification is ScrollEndNotification) {
      _handleScrollEnd(notification);
    } else if (notification is ScrollUpdateNotification) {
      if (notification.dragDetails == null) {
        _handleScrollEnd(notification);
      }
    }
    return false;
  }

  Widget _buildContent() {
    List<Widget> groups = [];
    for (String cate in categories) {
      groups.add(_buildGroupByCategory(cate));
    }
    groups.insert(
        0,
        new SizedBox(
            height: 300.0,
            child: new ScaleTransition(
              scale: _aniController,
              child: new CachedPic(url: _dataMap["results"]["福利"][0]["url"]),
            )));
    return new NotificationListener(
      child: new ListView(
        children: groups,
        physics: const ClampingScrollPhysics(),
      ),
      onNotification: _dispatchEvent,
    );
  }

  Widget _buildWaiting() {
    return new Center(child: const CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
