import 'package:flutter/material.dart';
import 'package:flutter_gank/constant/colors.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:residemenu/residemenu.dart';

class MainActivity extends StatefulWidget {
  @override
  _MainActivityState createState() => new _MainActivityState();
}

class _MainActivityState extends State<MainActivity>
    with TickerProviderStateMixin {
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
    print(_tabController.index);
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
    _tabController = new TabController(length: 7, vsync: this,initialIndex: 0);
    _menuController = new MenuController(vsync: this);
  }
}
