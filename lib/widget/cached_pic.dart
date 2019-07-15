/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/30 下午10:13
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gank/activities/activity_photo.dart';
import 'package:flutter_gank/pages/page_girl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedPic extends StatefulWidget {
  final String url;

  final int index;

  final String placeholder;

  CachedPic({this.url, this.placeholder: "images/empty.png", this.index: 0});

  @override
  _CachedPicState createState() => new _CachedPicState();
}

class _CachedPicState extends State<CachedPic> {

  Widget _buildGirlItem() {
    return GestureDetector(
      child: Card(
        child: Hero(
          child: FadeInImage(
            image: CachedNetworkImageProvider(
              widget.url,
            ),
            placeholder: AssetImage(
              widget.placeholder,
            ),
            fit: BoxFit.cover,
          ),
          tag: widget.url,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (c) {
          return GankPhotoActivity(
              urls: GirlPage.of(context).getPhotoListByIndex(widget.index),
              initIndex: widget.index % 5);
        }));
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildGirlItem();
  }
}
