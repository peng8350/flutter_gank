/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/21 下午10:19
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gank/App.dart';
import 'package:flutter_gank/constant/colors.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/pages/page_girl.dart';
import 'package:flutter_gank/pages/page_home.dart';
import 'package:flutter_gank/pages/page_like.dart';
import 'package:flutter_gank/pages/page_setting.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gank/pages/page_gank.dart';
import 'package:flutter_gank/utils/utils_db.dart';
import 'package:flutter_gank/widget/search_bar.dart';
import 'package:residemenu/residemenu.dart';

class MainActivity extends StatefulWidget {
  @override
  _MainActivityState createState() => new _MainActivityState();
}

class _MainActivityState extends State<MainActivity>
    with TickerProviderStateMixin, DbUtils {
  final List<String> _gankTitles = [
    STRING_GANK_WEB,
    STRING_GANK_ANDROID,
    STRING_GANK_IOS,
    STRING_GANK_TUIJIAN,
    STRING_GANK_EXTRA,
    STRING_GANK_APP,
    STRING_GANK_VIDEO
  ];
  MenuController _menuController;

  TabController _tabController;

  int selectIndex = 0;

  AnimationController _appbarController;

  bool isCard = false;

  bool _isSearching = false;

  int _lastClickTime = 0;

  final GlobalKey<ScaffoldState> _scffoldKey = new GlobalKey();

  List<GlobalKey<GankPageState>> _gankPageKeys = [];

  final PageController _pageController = PageController(initialPage: 0);


  void _onDismissAppbar(bool forward){
    _appbarController.animateTo(forward?0.0:11111.0,duration: const Duration(milliseconds: 300));
  }


  Widget _buildRight() {
    if (selectIndex == 1) {
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
    } else if (selectIndex == 2) {
      return new InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          isCard = !isCard;
          setState(() {});
        },
        child: new Container(
          alignment: Alignment.center,
          margin: new EdgeInsets.only(right: 10.0),
          child: new Text(isCard ? "缩略图" : "卡片",
              style: new TextStyle(
                  inherit: true,
                  color: App.of(context).night ? NIGHT_TEXT : Colors.white)),
        ),
      );
    }
    return null;
  }

  Widget _buildViewPagerIndicator() {
    return selectIndex == 1
        ? new TabBar(
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
          )
        : null;
  }

  Widget _buildBody() {
    return ScrollConfiguration(
      child: RefreshConfiguration(
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            new HomePage(),
            TabBarView(
              children: <Widget>[
                new GankPage(
                  key: _gankPageKeys[0],
                  title: _gankTitles[0],
                  isSeaching: _isSearching,
                  onDismiss:_onDismissAppbar,
                ),
                GankPage(
                  key: _gankPageKeys[1],
                  title: _gankTitles[1],
                  isSeaching: _isSearching,
                  onDismiss:_onDismissAppbar,
                ),
                new GankPage(
                  key: _gankPageKeys[2],
                  title: _gankTitles[2],
                  isSeaching: _isSearching,
                  onDismiss:_onDismissAppbar,
                ),
                GankPage(
                  key: _gankPageKeys[3],
                  title: _gankTitles[3],
                  isSeaching: _isSearching,
                  onDismiss:_onDismissAppbar,
                ),
                GankPage(
                  key: _gankPageKeys[4],
                  title: _gankTitles[4],
                  isSeaching: _isSearching,
                  onDismiss:_onDismissAppbar,
                ),
                GankPage(
                  key: _gankPageKeys[5],
                  title: _gankTitles[5],
                  isSeaching: _isSearching,
                  onDismiss:_onDismissAppbar,
                ),
                GankPage(
                  key: _gankPageKeys[6],
                  title: _gankTitles[6],
                  isSeaching: _isSearching,
                  onDismiss:_onDismissAppbar,
                )
              ],
              controller: _tabController,
            ),
            new GirlPage(isCard: isCard),
            new LikePage(),
            new SettingPage()
          ],
        ),
        clickLoadingWhenIdle: true,
        headerBuilder: () => WaterDropHeader(),
        footerBuilder: () => ClassicFooter(idleText: "上拉加载",loadingText: "火热加载中..",noDataText: "没有更多数据"),

      ),
      behavior: _GankScrollBehavior(),
    );
  }

  Widget _buildMenuItem(String title, IconData iconName, Function callback) {
    return new Material(
      color: Colors.transparent,
      child: new InkWell(
        child: new ResideMenuItem(
            title: title,
            titleStyle: new TextStyle(
                inherit: true, color: Colors.white, fontSize: 14.0),
            icon: new Icon(
              iconName,
              color: Colors.white,
            )),
        onTap: callback,
        enableFeedback: true,
      ),
    );
  }

  Widget _buildMiddleMenu() {
    return new MenuScaffold(
        itemExtent: 50.0,
        header: new Container(
          margin: new EdgeInsets.only(bottom: 20.0),
          child: new CircleAvatar(
            backgroundImage: new AssetImage('images/gank.jpg'),
            radius: 40.0,
          ),
        ),
        children: <Widget>[
          _buildMenuItem(STRING_HOME, Icons.apps, () {
            setState(() {
              selectIndex = 0;
            });
            _pageController.jumpToPage(selectIndex);
            _menuController.closeMenu();
          }),
          _buildMenuItem(STRING_GANK, Icons.explore, () {
            setState(() {
              selectIndex = 1;
            });
            _pageController.jumpToPage(selectIndex);
            _menuController.closeMenu();
          }),
          _buildMenuItem(STRING_GIRL, Icons.insert_photo, () {
            setState(() {
              selectIndex = 2;
            });
            _pageController.jumpToPage(selectIndex);
            _menuController.closeMenu();
          }),
          _buildMenuItem(STRING_LIKE, Icons.favorite, () {
            setState(() {
              selectIndex = 3;
            });
            _pageController.jumpToPage(selectIndex);
            _menuController.closeMenu();
          }),
          _buildMenuItem(STRING_SETTING, Icons.settings, () {
            setState(() {
              selectIndex = 4;
            });
            _pageController.jumpToPage(selectIndex);
            _menuController.closeMenu();
          }),
        ]);
  }

  void _onSearch(String text) {
    for (GlobalKey<GankPageState> key in _gankPageKeys) {
      key.currentState.searchGank(text);
    }
  }

  Future<bool> _doubleExit() {
    int nowTime = new DateTime.now().microsecondsSinceEpoch;
    if (_lastClickTime != 0 && nowTime - _lastClickTime > 1500) {
      return new Future.value(true);
    } else {
      _lastClickTime = new DateTime.now().microsecondsSinceEpoch;
      new Future.delayed(const Duration(milliseconds: 1500), () {
        _lastClickTime = 0;
      });
      _scffoldKey.currentState
          .showSnackBar(new SnackBar(content: new Text('再点多一次就退出程序!!!')));
      return new Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: new Scaffold(
            key: _scffoldKey,
            body: new ResideMenu.scaffold(
              enableFade: true,
              controller: _menuController,
              leftScaffold: _buildMiddleMenu(),
              child: new Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(selectIndex == 1?_appbarController.value:kToolbarHeight),
                  child: AppBar(
                    title: _isSearching && selectIndex == 1
                        ? new SearchBar(
                      onChangeText: _onSearch,
                    )
                        : new Text(
                        selectIndex == 0
                            ? STRING_HOME
                            : selectIndex == 1
                            ? STRING_GANK
                            : selectIndex == 2
                            ? STRING_GIRL
                            : selectIndex == 3
                            ? STRING_LIKE
                            : selectIndex == 4
                            ? STRING_SETTING
                            : STRING_ABOUTME,
                        style: new TextStyle(
                            inherit: true,
                            color: App.of(context).night
                                ? NIGHT_TEXT
                                : Colors.white)),
                    leading: new InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: new Icon(Icons.menu,
                          color:
                          App.of(context).night ? NIGHT_TEXT : Colors.white),
                      onTap: () {
                        _menuController.openMenu(true);
                      },
                    ),
                    bottom: _buildViewPagerIndicator(),
                    actions: _buildRight() != null ? [_buildRight()] : null,
                  ),
                ) ,
                body: _buildBody(),
              ),
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(colors: <Color>[
                Theme.of(context).primaryColor,
                const Color(0xff666666)
              ], begin: Alignment.topLeft)),
            )),
        onWillPop: _doubleExit);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    close();
    _appbarController.dispose();
    _menuController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _appbarController =AnimationController(vsync: this,lowerBound: kTextTabBarHeight,upperBound: kToolbarHeight+kTextTabBarHeight,value: 1202.0);
    _appbarController.addListener((){
      setState(() {

      });
    });
    for (int i = 0; i < 7; i++) _gankPageKeys.add(new GlobalKey());
    _tabController = new TabController(length: 7, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {});
    });
    _menuController = new MenuController(vsync: this,direction: ScrollDirection.LEFT);
  }


}

class _GankScrollBehavior extends ScrollBehavior{

  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    // TODO: implement buildViewportChrome
    return GlowingOverscrollIndicator(
      child: child,
      axisDirection: axisDirection,
      color: Theme.of(context).primaryColor,
    );
  }
}