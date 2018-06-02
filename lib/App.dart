/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/21 下午10:18
 */


import 'package:flutter/material.dart';
import 'package:flutter_gank/activity_main.dart';
import 'package:flutter_gank/activity_spalsh.dart';
import 'package:flutter_gank/constant/strings.dart';


class App extends StatefulWidget {

  static AppState of(BuildContext context, { bool nullOk: false }) {
    assert(nullOk != null);
    assert(context != null);
    final AppState result = context.ancestorStateOfType(const TypeMatcher<AppState>());
    if (nullOk || result != null)
      return result;
    throw new FlutterError(
        'get Static App failed'
    );
  }

  @override
  AppState createState() => new AppState();
}

class AppState extends State<App> {
  Color _themeColor;


  @override
  String toString({DiagnosticLevel minLevel: DiagnosticLevel.debug}) {
    // TODO: implement toString
    return "这是我的App";
  }

  void changeThemeColor(Color color){
    setState(() {
      _themeColor = color;
    });
  }

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
          textTheme: new TextTheme(
            title: new TextStyle(inherit: true,fontSize: 14.0),
            subhead: new TextStyle(inherit: true,fontSize: 13.0),
            body1: new TextStyle(inherit: true,fontSize: 12.0),
            body2: new TextStyle(inherit: true,fontSize: 10.0,color:Colors.grey),
          )
      ),
      routes: {
        "main": (BuildContext context){
          return new MainActivity();
        }
      },
      home: new SpalshActivity(),
    );
  }
}
