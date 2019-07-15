/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/22 下午1:37
 */

import 'package:flutter/material.dart';
import 'package:flutter_gank/App.dart';
import 'package:flutter_gank/activities/activity_web.dart';
import 'package:flutter_gank/bean/info_gank.dart';
import 'package:flutter_gank/constant/colors.dart';
import 'package:flutter_gank/pages/page_girl.dart';
import 'package:flutter_gank/widget/cached_pic.dart';

class GankItem extends StatefulWidget {
  final GankInfo info;

  final Function onChange;

  final bool showLike;

  GankItem({this.info, this.onChange, this.showLike: true});

  @override
  _GankItemState createState() => new _GankItemState();
}

class _GankItemState extends State<GankItem> {
  Widget _buildImg() {
    return widget.info.img == ''
        ? new Image.asset('images/empty.png',
            width: 50.0, height: 80.0, fit: BoxFit.cover)
        : new Image.network(
            widget.info.img + "?imageView2/0/w/100",
            height: 80.0,
            fit: BoxFit.cover,
            width: 50.0,
          );
  }

  Widget _buildDesc() {
    return new Expanded(
        child: new Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 10.0),
      child: new Text(
        widget.info.desc,
        maxLines: 10,
      ),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              alignment: Alignment.center,
              color: Colors.greenAccent,
              child: new Text(
                widget.info.who,
                style: const TextStyle(inherit: true, color: Colors.white),
              ),
            ),
            new Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              alignment: Alignment.center,
              color: Colors.purpleAccent,
              child: new Text(
                widget.info.source,
                style: new TextStyle(inherit: true, color: Colors.white),
              ),
            )
          ],
        ),
        new Offstage(
          offstage: !widget.showLike,
          child: new InkWell(
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Icon(
                    !widget.info.like ? Icons.favorite_border : Icons.favorite,
                    color: Colors.redAccent),
                new Text(
                  widget.info.like ? "取消收藏" : "收藏",
                  style: Theme.of(context).textTheme.body2,
                ),
              ],
            ),
            onTap: () {
              if (widget.onChange != null) {
                widget.onChange();
              }
              setState(() {});
            },
          ),
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
    return new Container(
      color: App.of(context).night ? NIGHT_COLOR_BG : COLOR_BG,
      child: new Card(
        color: App.of(context).night ? NIGHT_ITEM_BG : Colors.white,
        margin: new EdgeInsets.all(5.0),
        elevation: 3.0,
        child: new InkWell(
          child: new Container(
            padding: new EdgeInsets.all(5.0),
            child: new Column(
              children: <Widget>[
                _buildTop(),
                new Container(
                  height: 0.5,
                  color: Theme.of(context).dividerColor,
                  margin: const EdgeInsets.only(top: 10.0),
                ),
                _buildBottom()
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new WebActivity(widget.info.url)));
          },
        ),
      ),
    );
  }
}

class SettingItem extends StatefulWidget {
  final bool isSwitch;

  final Widget title, icon, right;

  final Color iconBgColor;

  final bool value;

  final Function onChange, onClick;

  SettingItem(
      {this.value,
      this.onChange,
      this.onClick,
      this.iconBgColor,
      this.isSwitch: false,
      this.title,
      this.icon,
      this.right: const Icon(Icons.arrow_forward, color: Colors.grey)});

  @override
  _SettingItemState createState() => new _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  @override
  Widget build(BuildContext context) {
    final bool isNight = App.of(context).night;
    return new Material(
      color: isNight ? NIGHT_ITEM_BG : Colors.white,
      child: new Container(
        decoration: new BoxDecoration(
            border: new Border(
                bottom: new BorderSide(
                    color: Theme.of(context).dividerColor, width: 0.4))),
        child: new ListTile(
          onTap: () {
            if (widget.onClick != null) {
              widget.onClick();
            }
          },
          enabled: true,
          title: widget.title,
          leading: new ClipRRect(
            borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
            child: new Container(
              width: 30.0,
              height: 30.0,
              color: widget.iconBgColor,
              child: widget.icon,
            ),
          ),
          trailing: widget.isSwitch
              ? new Switch(
                  value: widget.value,
                  onChanged: widget.onChange,
                  activeColor: Theme.of(context).primaryColor,
                )
              : widget.right,
        ),
      ),
    );
  }
}

class GirlCardItem extends StatefulWidget {
  final String time;
  final String who;
  final String url;
  final bool isLike;
  final int index;
  final Function onChangeVal;

  GirlCardItem(
      {this.time,
      this.url,
      this.who,
      this.isLike,
      this.onChangeVal,
      this.index});

  @override
  _GirlCardItemState createState() => new _GirlCardItemState();
}

class _GirlCardItemState extends State<GirlCardItem> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final time = widget.time;
    final who = widget.who;
    final bool isLike = widget.isLike;
    return new Card(
      color: App.of(context).night ? NIGHT_ITEM_BG : Colors.white,
      child: new Column(
        children: <Widget>[
          new Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              new CachedPic(
                url: widget.url,
                index: widget.index,
                viewList:
                    GirlPage.of(context).getPhotoListByIndex(widget.index),
              ),
              new Container(
                height: 40.0,
                color: COLOR_BANTANSPARENT,
                child: new Padding(
                  padding: new EdgeInsets.only(left: 10.0, right: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                        time,
                        style:
                            const TextStyle(inherit: true, color: Colors.white),
                      ),
                      new Text(
                        "by:$who",
                        style:
                            const TextStyle(inherit: true, color: Colors.white),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          new Align(
              alignment: Alignment.centerRight,
              child: new InkWell(
                onTap: () {
                  if (widget.onChangeVal != null) {
                    widget.onChangeVal();
                    setState(() {});
                  }
                },
                child: new Container(
                  margin: const EdgeInsets.all(10.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Icon(!isLike ? Icons.favorite_border : Icons.favorite,
                          color: Colors.redAccent),
                      new Text(
                        isLike ? "取消收藏" : "收藏",
                        style: Theme.of(context).textTheme.body2,
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

class HomeItem extends StatelessWidget {
  final GankInfo info;

  HomeItem({this.info});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final time = info.publishedAt;
    final desc = info.desc;
    return new Material(
      child: new Container(
        child: new ListTile(
          title: new Text(
            "● $desc",
            style: Theme.of(context).textTheme.body1,
          ),
          trailing: new Text(time.substring(0, 10),
              style: Theme.of(context).textTheme.body2),
          enabled: true,
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new WebActivity(info.url)));
          },
        ),
        decoration: new BoxDecoration(
            border: new Border(
                bottom: new BorderSide(
                    color: Theme.of(context).dividerColor, width: 0.4))),
      ),
    );
  }
}
