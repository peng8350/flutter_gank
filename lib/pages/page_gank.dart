/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/21 下午11:03
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gank/bean/info_gank.dart';
import 'package:flutter_gank/constant/colors.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/utils/utils_db.dart';
import 'package:flutter_gank/utils/utils_indicator.dart';
import 'package:flutter_gank/widget/CircleClipper.dart';
import 'package:flutter_gank/widget/item_gank.dart';
import 'package:flutter_gank/widget/search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gank/utils/utils_http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';

import '../App.dart';

class GankPage extends StatefulWidget {
  final Widget leading;

  GankPage({this.leading});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GankPageState();
  }
}

class _GankPageState extends State<GankPage>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  int _gankSelectIndex = 0;
  TabController _tabController;
  List<GlobalKey<_GankRefreshViewState>> _gankKeys = [];
  final List<String> _gankTitles = [
    STRING_GANK_WEB,
    STRING_GANK_ANDROID,
    STRING_GANK_IOS,
    STRING_GANK_TUIJIAN,
    STRING_GANK_EXTRA,
    STRING_GANK_APP,
    STRING_GANK_VIDEO
  ];

  @override
  void initState() {
    // TODO: implement initState|
    for (int i = 0; i < 7; i++) _gankKeys.add(new GlobalKey());
    _tabController = new TabController(length: 7, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      _gankSelectIndex = _tabController.index;
      setState(() {});
    });
    super.initState();
  }

  Widget _buildViewPagerIndicator() {
    return TabBar(
      indicatorColor: Theme.of(context).primaryColor,
      isScrollable: true,
      labelColor: Colors.white,
      tabs: <Widget>[
        new Tab(text: STRING_GANK_WEB),
        new Tab(text: STRING_GANK_ANDROID),
        new Tab(text: STRING_GANK_IOS),
        new Tab(text: STRING_GANK_TUIJIAN),
        new Tab(text: STRING_GANK_EXTRA),
        new Tab(text: STRING_GANK_APP),
        new Tab(text: STRING_GANK_VIDEO)
      ],
      controller: _tabController,
    );
  }

  Widget _buildSearch() {
    return new InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: new Container(
        alignment: Alignment.center,
        child: _isSearching
            ? new Text('取消',
                style: new TextStyle(
                    inherit: true,
                    color: App.of(context).night ? NIGHT_TEXT : Colors.white))
            : new Icon(
                Icons.search,
                color: App.of(context).night ? NIGHT_TEXT : Colors.white,
                size: 25.0,
              ),
        margin: new EdgeInsets.all(10.0),
      ),
      onTap: () {
        _isSearching = !_isSearching;
        setState(() {});
      },
    );
  }

  void _onSearch(String text) {
    for (GlobalKey<_GankRefreshViewState> key in _gankKeys) {
      key.currentState.searchGank(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (c, _) {
          return [
            SliverAppBar(
              title: _isSearching
                  ? new SearchBar(
                      onChangeText: _onSearch,
                    )
                  : Text("干货"),
              floating: true,
              snap: true,
              pinned: true,
              expandedHeight: kBottomNavigationBarHeight + kToolbarHeight,
              leading: widget.leading,
              actions: <Widget>[_buildSearch()],
              bottom: _buildViewPagerIndicator(),
            )
          ];
        },
        body: TabBarView(
          children: <Widget>[
            _GankRefreshView(
              key: _gankKeys[0],
              title: _gankTitles[0],
              isSeaching: _isSearching,
            ),
            _GankRefreshView(
              key: _gankKeys[1],
              title: _gankTitles[1],
              isSeaching: _isSearching,
            ),
            _GankRefreshView(
              key: _gankKeys[2],
              title: _gankTitles[2],
              isSeaching: _isSearching,
            ),
            _GankRefreshView(
              key: _gankKeys[3],
              title: _gankTitles[3],
              isSeaching: _isSearching,
            ),
            _GankRefreshView(
              key: _gankKeys[4],
              title: _gankTitles[4],
              isSeaching: _isSearching,
            ),
            _GankRefreshView(
              key: _gankKeys[5],
              title: _gankTitles[5],
              isSeaching: _isSearching,
            ),
            _GankRefreshView(
              key: _gankKeys[6],
              title: _gankTitles[6],
              isSeaching: _isSearching,
            )
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}

class _GankRefreshView extends StatefulWidget {
  final String title;

  final bool isSeaching;

  _GankRefreshView({this.title, Key key, this.isSeaching}) : super(key: key);

  @override
  _GankRefreshViewState createState() => new _GankRefreshViewState();
}

class _GankRefreshViewState extends State<_GankRefreshView>
    with HttpUtils, DbUtils, AutomaticKeepAliveClientMixin {
  List<GankInfo> _dataList = [];
  List<GankInfo> _searchList = [];
  RefreshController _refreshController;
  int _pageIndex = 1;
  final ValueNotifier<double> offsetLis = new ValueNotifier(0.0);

  //捕捉应该要插入多少个新的数据
  int _catchEndPos(List<GankInfo> newData) {
    if (_dataList.isEmpty) {
      return newData.length;
    } else {
      for (int i = 0; i < newData.length; i++) {
        if (newData[i].id == _dataList[0].id) {
          return i;
        } else {
          int j = i + 1;
          //是否存在
          while (j < _dataList.length && _dataList[j].desc == newData[j].desc) {
            if (_dataList[j].id != newData[i].id) {
              j++;
            } else {
              return i;
            }
          }
        }
      }
    }
    return 0;
  }

  void _refreshNewData() {
    getGankfromNet(URL_GANK_FETCH + widget.title + "/20/1")
        .then((List<GankInfo> data) {
      for (int i = _catchEndPos(data) - 1; i >= 0; i--) {
        _dataList.insert(0, data[i]);
        insert("Gank", data[i].toMap()).then((val) {}).catchError((error) {});
      }
      if (_dataList.length > 0)
        _pageIndex = (_dataList.length ~/ 20).toInt() + 1;
      _refreshController.refreshCompleted();
      setState(() {});
      return false;
    }).catchError((error) {
      _refreshController.refreshFailed();
      return false;
    });
  }

  void _fetchMoreData() {
    getGankfromNet(URL_GANK_FETCH + widget.title + "/20/$_pageIndex")
        .then((List<GankInfo> data) {
      if (data.isEmpty) {
        //空数据
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _refreshController.loadNoData();
        });
      } else {
        for (GankInfo item in data) {
          _dataList.add(item);
          insert("Gank", item.toMap()).then((val) {}).catchError((error) {});
        }
        _pageIndex++;

        SchedulerBinding.instance.addPostFrameCallback((_) {
          _refreshController.loadComplete();
        });
        setState(() {});
      }
      return false;
    }).catchError((error) {
      return false;
    });
  }

  void _onClickLike(GankInfo item) {
    item.like = !item.like;

    update("Gank", item.toMap(), "id = ? ", [item.id]);
    setState(() {});
  }

  void _onRefresh() {
    _refreshNewData();
  }

  void _onLoad() {
    _fetchMoreData();
  }

  void searchGank(String searchText) {
    _searchList.clear();
    for (GankInfo item in _dataList) {
      if (item.isAvailableSearch(searchText)) {
        _searchList.add(item);
      }
    }
    setState(() {});
  }

  Widget _buildContent() {
    if (!widget.isSeaching)
      return SmartRefresher(
        controller: _refreshController,
        child: new ListView.builder(
          itemBuilder: (context, index) => new GankItem(
            info: _dataList[index],
            onChange: () {
              _onClickLike(_dataList[index]);
            },
          ),
          itemCount: _dataList.length,
        ),
        onRefresh: _onRefresh,
        onLoading: _onLoad,
        enablePullDown: true,
        enablePullUp: true,
      );
    else
      return new ListView.builder(
        itemBuilder: (context, index) => new GankItem(
          info: _searchList[index],
          onChange: () {
            _onClickLike(_searchList[index]);
          },
        ),
        itemCount: _searchList.length,
      );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshController = new RefreshController();
    if (_dataList?.length == 0) {
      getList("Gank", "type = ?", [widget.title]).then((List<dynamic> list) {
        if (list.isEmpty) {
          SharedPreferences.getInstance().then((SharedPreferences preferences) {
            if (preferences.getBool("autoRefresh") ?? false) {
              _refreshController.requestRefresh();
            }
          });
        } else {
          for (Map map in list) {
            _dataList.add(new GankInfo.fromMap(map));
          }
          int aa = list.length ~/ 20;
          _pageIndex = aa + 1;
        }
      });
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
