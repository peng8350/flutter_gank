/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/21 下午10:18
 */

import 'package:flutter/material.dart';
import 'package:flutter_gank/activities/activity_main.dart';
import 'package:flutter_gank/activities/activity_spalsh.dart';
import 'package:flutter_gank/activities/activity_web.dart';
import 'package:flutter_gank/constant/colors.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  static AppState of(BuildContext context, {bool nullOk: false}) {
    assert(nullOk != null);
    assert(context != null);
    final AppState result =
        context.ancestorStateOfType(const TypeMatcher<AppState>());
    if (nullOk || result != null) return result;
    throw new FlutterError('get Static App failed');
  }

  @override
  AppState createState() => new AppState();
}

class AppState extends State<App> {
  Color _themeColor = DEFAULT_THEMECOLOR;
  bool _isNight = false;

  @override
  String toString({DiagnosticLevel minLevel: DiagnosticLevel.debug}) {
    // TODO: implement toString
    return "这是我的App";
  }

  void changeThemeColor(Color color) {
    SharedPreferences.getInstance().then((preferences) {
      preferences.setInt("themeColor", _themeColor.value);
    });
    setState(() {
      _themeColor = color;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    SharedPreferences.getInstance().then((preferences) {
      _themeColor = new Color(
          preferences.getInt("themeColor") ?? DEFAULT_THEMECOLOR.value);
      _isNight = preferences.getBool("isNight") ?? false;
      setState(() {});
    });

    super.initState();
  }

  set night(bool isNight) {
    this._isNight = isNight;
    setState(() {});
  }

  get night => this._isNight;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: STRING_APP_NAME,
      theme: new ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
          // counter didn't reset back to zero; the application is not restarted.
          primaryColor: _themeColor,
          backgroundColor: Colors.redAccent,
          scaffoldBackgroundColor: _isNight ? NIGHT_COLOR_BG : COLOR_BG,
          dialogBackgroundColor: _isNight ? NIGHT_COLOR_BG : COLOR_BG,
          canvasColor: _isNight ? NIGHT_ITEM_BG : Colors.white,

          bottomAppBarColor: Colors.grey,
          dividerColor: _isNight ? NIGHT_COLOR_DIVIDER : COLOR_DIVIDER,
          textTheme: new TextTheme(
            title: new TextStyle(inherit: true, fontSize: 14.0),
            subhead: new TextStyle(
                inherit: true,
                fontSize: 13.0,
                color: _isNight ? NIGHT_TEXT : Colors.black),
            body1: new TextStyle(
                inherit: true,
                fontSize: 12.0,
                color: _isNight ? NIGHT_TEXT : Colors.black),
            body2: new TextStyle(
                inherit: true, fontSize: 10.0, color: Colors.grey),
          )),
      routes: {
        "main": (BuildContext context) {
          return new MainActivity();
        },
      },
      home: new SpalshActivity(),
    );
  }
}

