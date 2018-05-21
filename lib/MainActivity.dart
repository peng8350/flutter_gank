import 'package:flutter/material.dart';


class MainActivity extends StatefulWidget {


  @override
  _MainActivityState createState() => new _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Gank'),
      ),
      drawer: new Drawer(
        child: new Text('asd'),
      ),
    );
  }
}
