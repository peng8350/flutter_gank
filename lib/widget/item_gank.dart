/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/22 下午1:37
 */

import 'package:flutter/material.dart';
import 'package:flutter_gank/bean/info_gank.dart';

class GankItem extends StatefulWidget {
  final GankInfo info;

  GankItem({this.info});

  @override
  _GankItemState createState() => new _GankItemState();
}

class _GankItemState extends State<GankItem> {
  Widget _buildTop() {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        widget.info.img == ''
            ? new Container()
            : new Image.network(
                widget.info.img,
                height: 50.0,
                width: 50.0,
              ),
        new Flexible(
            child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(widget.info.desc, overflow: TextOverflow.fade)
          ],
        )),
        new Text(widget.info.publishedAt.substring(0, 10),
            style: new TextStyle(inherit: true, fontSize: 10.0))
      ],
    );
  }

  Widget _buildBottom() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Text(widget.info.who),
        new Text(widget.info.source)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new InkWell(
        child: new Container(
          padding: new EdgeInsets.all(15.0),
          child: new Column(
            children: <Widget>[_buildTop(), _buildBottom()],
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
