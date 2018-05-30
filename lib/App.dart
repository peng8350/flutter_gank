/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/21 下午10:18
 */


import 'package:flutter/material.dart';
import 'package:flutter_gank/activity_main.dart';
import 'package:flutter_gank/constant/strings.dart';


class App extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: STRING_APP_NAME,
      showPerformanceOverlay: true,
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
        textTheme: new TextTheme(
          body1: new TextStyle(inherit: true,fontSize: 12.0),
          body2: new TextStyle(inherit: true,fontSize: 10.0,color:Colors.grey),
        )
      ),

      home: new MainActivity(),
    );
  }
}
