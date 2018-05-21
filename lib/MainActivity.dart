import 'package:flutter/material.dart';
import 'package:flutter_gank/constant/colors.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/pages/GankPage.dart';
import 'package:residemenu/residemenu.dart';

class MainActivity extends StatefulWidget {
  @override
  _MainActivityState createState() => new _MainActivityState();
}

class _MainActivityState extends State<MainActivity>
    with TickerProviderStateMixin {
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

  Widget _buildViewPagerIndicator() {
    return selectIndex == 1
        ? new TabBar(
            isScrollable: true,
            tabs: <Widget>[
              new Tab(text: STRING_GANK_WEB),
              new Tab(text: STRING_GANK_ANDROID),
              new Tab(text: STRING_GANK_IOS),
              new Tab(text: STRING_GANK_TUIJIAN),
              new Tab(text: STRING_GANK_EXTRA),
              new Tab(text: STRING_GANK_APP),
              new Tab(text: STRING_GANK_VIDEO)
            ],
            controller: _tabController)
        : null;
  }

  Widget _buildBody() {
    return new Stack(
      children: <Widget>[
        new Offstage(
          offstage: selectIndex != 0,
          child: new Text('1'),
        ),
        new Offstage(
          offstage: selectIndex != 1,
          child: new TabBarView(
            children: <Widget>[
              new GankPage(title: _gankTitles[0]),
              new GankPage(title: _gankTitles[1]),
              new GankPage(title: _gankTitles[2]),
              new GankPage(title: _gankTitles[3]),
              new GankPage(title: _gankTitles[4]),
              new GankPage(title: _gankTitles[5])
            ],
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics()
          ),
        ),
        new Offstage(
          offstage: selectIndex != 2,
          child: new Text('3'),
        ),
        new Offstage(
          offstage: selectIndex != 3,
          child: new Text('4'),
        ),
        new Offstage(
          offstage: selectIndex != 4,
          child: new Text('5'),
        ),
        new Offstage(
          offstage: selectIndex != 5,
          child: new Text('6'),
        )
      ],
    );
  }

  Widget _buildMenuItem(String title, IconData iconName, Function callback) {
    return new InkWell(
      child: new ResideMenuItem(
          title: title,
          titleStyle: new TextStyle(inherit: true, color: Colors.white),
          icon: new Icon(
            iconName,
            color: Colors.white,
          )),
      onTap: callback,
    );
  }

  Widget _buildMiddleMenu() {
    return new MenuScaffold(
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
            _menuController.closeMenu();
          }),
          _buildMenuItem(STRING_GANK, Icons.explore, () {
            setState(() {
              selectIndex = 1;
            });
            _menuController.closeMenu();
          }),
          _buildMenuItem(STRING_GIRL, Icons.insert_photo, () {
            setState(() {
              selectIndex = 2;
            });
            _menuController.closeMenu();
          }),
          _buildMenuItem(STRING_LIKE, Icons.favorite, () {
            setState(() {
              selectIndex = 3;
            });
            _menuController.closeMenu();
          }),
          _buildMenuItem(STRING_SETTING, Icons.settings, () {
            setState(() {
              selectIndex = 4;
            });
            _menuController.closeMenu();
          }),
          _buildMenuItem(STRING_ABOUTME, Icons.info, () {
            setState(() {
              selectIndex = 5;
            });
            _menuController.closeMenu();
          })
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new ResideMenu.scafford(
      controller: _menuController,
      leftScaffold: _buildMiddleMenu(),
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(selectIndex == 0
              ? STRING_HOME
              : selectIndex == 1
                  ? STRING_GANK
                  : selectIndex == 2
                      ? STRING_GIRL
                      : selectIndex == 3
                          ? STRING_LIKE
                          : selectIndex == 4 ? STRING_SETTING : STRING_ABOUTME),
          leading: new GestureDetector(
            child: const Icon(Icons.menu),
            onTap: () {
              _menuController.openMenu(true);
            },
          ),
          bottom: _buildViewPagerIndicator(),
        ),
        body: _buildBody(),
      ),
      direction: ScrollDirection.LEFT,
      decoration: new BoxDecoration(
          gradient: const LinearGradient(
              colors: <Color>[DEFAULT_THEMECOLOR, const Color(0xff666666)],
              begin: Alignment.topLeft)),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 7, vsync: this, initialIndex: 0);
    _menuController = new MenuController(vsync: this);
  }
}
