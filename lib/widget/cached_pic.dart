/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/30 下午10:13
 */
import 'package:flutter/material.dart';

class CachedPic extends StatefulWidget {
  final String url;

  final String placeholder;

  CachedPic({this.url, this.placeholder: "images/empty.png"});

  @override
  _CachedPicState createState() => new _CachedPicState();
}

class _CachedPicState extends State<CachedPic> {

  Widget _buildGirlItem() {
    return new FadeInImage.assetNetwork(
      placeholder: widget.placeholder,
      image: widget.url,
      fit: BoxFit.cover,
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
