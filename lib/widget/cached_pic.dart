/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/30 下午10:13
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gank/activities/activity_photo.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
          child: new CachedNetworkImage(
            placeholder: (c, s) => new Image.asset(
              widget.placeholder,
              fit: BoxFit.cover,
            ),
            imageUrl: widget.url,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return GankPhotoActivity(urls: [
                "https://pics5.baidu.com/feed/359b033b5bb5c9ea80848d91324096053bf3b3c8.jpeg?token=f4a0bcef6d4700e457fc058423758431&s=84A2E5B046610AA87A252C4C03009052",
                "https://pics5.baidu.com/feed/359b033b5bb5c9ea80848d91324096053bf3b3c8.jpeg?token=f4a0bcef6d4700e457fc058423758431&s=84A2E5B046610AA87A252C4C03009052"
              ], initIndex: 0);
            }));
//            Overlay.of(context).insert(_scaleImg);
//            showScale = true;
          },
        ),
        onWillPop: _onWillPop);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _scaleImg = new OverlayEntry(builder: (context) {
//      return new GestureDetector(
//        child: new Container(
//          color: Colors.black,
//          padding: new EdgeInsets.only(top: 100.0,bottom: 100.0),
//          child: new PhotoView(
//            imageProvider: new NetworkImage(widget.url),
//
//            loadingChild: new Image.asset(widget.placeholder,width: double.infinity,height: double.infinity,fit: BoxFit.cover,),
//          ),
//        ),
//        onTap: () {
//          _scaleImg.remove();
//          showScale = false;
//        },
//      );
//    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildGirlItem();
  }
}
