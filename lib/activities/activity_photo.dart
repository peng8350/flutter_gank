/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time:  2019-07-14 17:41
 */

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';

/// 展示图片列表

class GankPhotoActivity extends StatefulWidget {
  final List<String> urls;
  final int initIndex;

  GankPhotoActivity({this.urls, this.initIndex});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GankPhotoActivityState();
  }
}

class _GankPhotoActivityState extends State<GankPhotoActivity> {
  int _selectIndex;
  PageController _pageController;

  Widget _buildImg(String url) {
    return new PhotoView(
      imageProvider: new NetworkImage(url),
      loadingChild: new Image.asset(
        "empty.png",
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState)
    _selectIndex = widget.initIndex;
    _pageController = PageController(initialPage: _selectIndex);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<Widget> imgs = [];
    List<Widget> dots = [];
    for (int i = 0; i < widget.urls.length; i++) {
      imgs.add(_buildImg(widget.urls[i]));
      dots.add(_DotIndicator(
        selected: _selectIndex == i,
      ));
    }

    return GestureDetector(
      child: Stack(
        children: <Widget>[
          PageView(
            controller: _pageController,
            onPageChanged: (i) {
              _selectIndex = i;
              setState(() {});
            },
            children: imgs,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: dots,
              ),
              margin: EdgeInsets.only(bottom: 30.0),
            ),
          )
        ],
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final bool selected;

  _DotIndicator({this.selected});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: CircleAvatar(
        backgroundColor: selected ? Colors.white : Colors.grey,
        radius: 3,
      ),
      margin: EdgeInsets.all(2.0),
    );
  }
}
