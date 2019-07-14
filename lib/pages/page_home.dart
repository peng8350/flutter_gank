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
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
    with
        HttpUtils,
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin {
  bool showAlignmentCards = false;

  Map _dataMap;

  List<String> categories = [];

  AnimationController _aniController;

  RefreshController _refreshController = RefreshController(
      initialRefresh: true);

  @override
  void initState() {
    // TODO: implement initState

    _aniController = new AnimationController(
        vsync: this,
        lowerBound: 1.0,
        upperBound: 2.0,
        value: 1.0,
        duration: const Duration(milliseconds: 200));
    super.initState();
  }

  void _fetch() async {
    Map dateJson = await getToMap("http://gank.io/api/day/history");
    Map todayJson = await getToMap("http://gank.io/api/day/" +
        dateJson["results"][0].replaceAll("-", "/"));
    _dataMap = todayJson;
    categories = [];
    for (String s in _dataMap["category"]) {
      categories.add(s);
    }
    setState(() {});

    _refreshController.refreshCompleted();
  }

//  new SliverStickyHeader(
//  header: new Container(
//  height: 60.0,
//  color: Colors.lightBlue,
//  padding: EdgeInsets.symmetric(horizontal: 16.0),
//  alignment: Alignment.centerLeft,
//  child: new Text(
//  'Header #0',
//  style: const TextStyle(color: Colors.white),
//  ),
//  ),
//  sliver: new SliverList(
//  delegate: new SliverChildBuilderDelegate(
//  (context, i) => new ListTile(
//  leading: new CircleAvatar(
//  child: new Text('0'),
//  ),
//  title: new Text('List tile #$i'),
//  ),
//  childCount: 4,
//  ),
//  ),
//  );
  Widget _buildGroupByCategory(String category) {
    List<Widget> list = [];
    for (Map map in _dataMap["results"][category]) {
      list.add(HomeItem(info:new GankInfo.fromJson(map)));
    }
    return SliverStickyHeader(
      header: Container(
        height: 40.0,
        color: Color.fromRGBO(244, 244, 244, 0.8),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,

          children: <Widget>[
            new Icon(category == 'Android'
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
                : Icons.layers, color: Colors.grey, size: 18.0),
            new Container(
              child: new Text(category,
                  style: const TextStyle(inherit: true, fontSize: 16.0)),
              margin: const EdgeInsets.only(left: 10.0),
            )
          ],
        ),
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
            list
        ),
      ),
    );
  }
  void _handleScrollEnd(ScrollNotification notifcation) {
    _aniController.animateTo(1.0);
  }

  bool _dispatchEvent(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {} else
    if (notification is OverscrollNotification) {
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

  void _onRefresh() {
    _fetch();
  }

  void _onLoading() {

  }

  Widget _buildContent() {
    if (_dataMap == null) {
      return ListView(children: <Widget>[Container()],);
    }
    List<Widget> groups = [];
    for (String cate in categories) {
      groups.add(_buildGroupByCategory(cate));
    }
    groups.insert(
        0,
        SliverToBoxAdapter(
          child: new SizedBox(
              height: 300.0,
              child: new ScaleTransition(
                scale: _aniController,
                child: new CachedPic(url: _dataMap["results"]["福利"][0]["url"]),
              )),
        ));
    return CustomScrollView(slivers: groups,);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      child: Scrollbar(
        child: SmartRefresher(
            child: _buildContent() ??
                ListView(children: <Widget>[Container()],),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            header: WaterDropMaterialHeader(backgroundColor: Theme
                .of(context)
                .primaryColor, color: Colors.white,)
        ),
      ),
      onNotification: _dispatchEvent,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
