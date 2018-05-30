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

  Widget _buildImg(){
    return widget.info.img == ''
        ? new Image.asset('images/empty.png',
        width: 50.0, height: 80.0, fit: BoxFit.cover)
        : new Image.network(
      widget.info.img+"?imageView2/0/w/100",
      height: 80.0,
      fit: BoxFit.cover,
      width: 50.0,
    );
  }

  Widget _buildDesc(){
    return new Expanded(child: new Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 10.0),
      child: new Text(widget.info.desc,maxLines: 10,),
    ));
  }

  Widget _buildTop() {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[

        _buildImg(),
        _buildDesc(),
        new Container(
          padding: new EdgeInsets.only(left: 10.0),
          child: new Text(
            widget.info.publishedAt.substring(0, 10),
            style: Theme.of(context).textTheme.body2,
          ),
        )
      ],
    );
  }

  Widget _buildBottom() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Text(
          widget.info.who,
          style: Theme.of(context).textTheme.body2,
        ),
        new Text(
          widget.info.source,
          style: Theme.of(context).textTheme.body2,
        )
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  new Card(
        margin: new EdgeInsets.all(5.0),
        elevation: 3.0,
        color: Colors.white,
        child: new InkWell(
          child: new Container(

            padding: new EdgeInsets.all(5.0),
            child: new Column(
              children: <Widget>[_buildTop(), _buildBottom()],
            ),
          ),
          onTap: () {},
        ),
      );
  }
}
