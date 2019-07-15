/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/31 下午1:20
 */

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/bean/info_gank.dart';
import 'package:flutter_gank/utils/utils_http.dart';
import 'package:flutter_gank/widget/cached_pic.dart';
import 'package:flutter_gank/widget/item_gank.dart';
import 'package:flutter_gank/widget/sliver_image_header.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  final Widget leading;

  HomePage({this.leading});

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
    with
        HttpUtils,
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin {
  bool showAlignmentCards = false;

  final Key linkKey = GlobalKey();

  Map _dataMap;

  AnimationController _appBarOpcity ;

  List<String> categories = [];

  int appBarAlpha = 0;

  ScrollController _scrollController = ScrollController();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    _appBarOpcity = AnimationController(vsync: this,value: 1.0);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels <= 200) {
        _appBarOpcity.value = (100.0-_scrollController.position.pixels) / 100.0;
      }
      setState(() {});
    });
    _fetch();
    super.initState();
  }

  void _fetch() async {
    Map dateJson = await getToMap("http://gank.io/api/today");
    _dataMap = dateJson;
    categories = [];
    for (String s in _dataMap["category"]) {
      categories.add(s);
    }
    setState(() {});

    _refreshController.refreshCompleted();
  }

  Widget _buildGroupByCategory(String category) {
    List<Widget> list = [];
    for (Map map in _dataMap["results"][category]) {
      list.insert(0, HomeItem(info: new GankInfo.fromJson(map)));
    }
    return SliverStickyHeader(
      overlapsContent:true,
      header: Container(
        height: 40.0,
        color: Color.fromRGBO(244, 244, 244, 0.8),
        padding: EdgeInsets.only(left: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Icon(
                category == 'Android'
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
                                            : Icons.layers,
                color: Colors.grey,
                size: 18.0),
            new Container(
              child: new Text(category,
                  style: const TextStyle(inherit: true, fontSize: 16.0)),
              margin: const EdgeInsets.only(left: 10.0),
            )
          ],
        ),
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(list),
      ),
    );
  }

  void _onRefresh() {
    _fetch();
  }

  void _onLoading() {}

  Widget _buildContent() {
    if (_dataMap == null) {
      return ListView(
        children: <Widget>[Container()],
      );
    }
    List<Widget> groups = [];
    for (String cate in categories) {
      groups.add(_buildGroupByCategory(cate));
    }

    groups.insert(
        0,
        SliverImageHeader(
          hiddenHeight: 150.0,
          child: Container(
            height: 300.0,
            child: Image.network(
                _dataMap["results"]["福利"][_dataMap.length - 1]["url"],
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter),
          ),
        ));
    return CustomScrollView(
      slivers: groups,
      physics: BouncingScrollPhysics(),
      controller: _scrollController,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        Scrollbar(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: CustomHeader(
              height: 0.0,
              builder: (c, m) {
                return Container();
              },
            ),
            child: _buildContent() ??
                ListView(
                  children: <Widget>[Container()],
                ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
          ),
        ),
        IgnorePointer(
          child: FadeTransition(
            child: Container(
              child: AppBar(
                backgroundColor:
                Colors.transparent,
                leading: widget.leading,
                elevation: 0,
                title: Row(
                  children: <Widget>[
                    Text("首页"),
                    Container(
                      width: 10.0,
                    ),
                    _refreshController.headerStatus == RefreshStatus.refreshing
                        ? CupertinoActivityIndicator()
                        : Container(),
                  ],
                ),
              ),
              height: kToolbarHeight,
            ),
            opacity: _appBarOpcity,
          ),
          ignoring: _appBarOpcity.value==0.0,
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
