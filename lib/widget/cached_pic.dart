/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/30 下午10:13
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class CachedPic extends StatefulWidget {
  final String url;

  final String placeholder;

  CachedPic({this.url, this.placeholder: "images/empty.png"});

  @override
  _CachedPicState createState() => new _CachedPicState();
}

class _CachedPicState extends State<CachedPic> {
  OverlayEntry _scaleImg;
  bool showScale = false;

  Future<bool> _onWillPop() {
    if (showScale) {
      _scaleImg.remove();
      showScale = false;
      return new Future.value(false);
    } else {
      return new Future.value(true);
    }
  }

  Widget _buildGirlItem() {
    return new WillPopScope(
        child: new GestureDetector(
          child: new FadeInImage.assetNetwork(
            placeholder: widget.placeholder,
            image: widget.url,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Overlay.of(context).insert(_scaleImg);
            showScale = true;
          },
        ),
        onWillPop: _onWillPop);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scaleImg = new OverlayEntry(builder: (context) {
      return new GestureDetector(
        child: new Container(
          color: Colors.black,
          padding: new EdgeInsets.only(top: 100.0,bottom: 100.0),
          child: new PhotoView(
            imageProvider: new NetworkImage(widget.url),

            loadingChild: new Image.asset(widget.placeholder,width: double.infinity,height: double.infinity,fit: BoxFit.cover,),
          ),
        ),
        onTap: () {
          _scaleImg.remove();
          showScale = false;
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildGirlItem();
  }
}
