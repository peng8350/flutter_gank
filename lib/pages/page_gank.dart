/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/21 下午11:03
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gank/bean/info_gank.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/widget/CircleClipper.dart';
import 'package:flutter_gank/widget/item_gank.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gank/utils/utils_http.dart';

class GankPage extends StatefulWidget {
  final String title;

  GankPage({this.title, Key key}) : super(key: key);

  @override
  _GankPageState createState() => new _GankPageState();
}

class _GankPageState extends State<GankPage> with HttpUtils {
  List<GankInfo> _dataList = [];
  RefreshController _refreshController;
  int _pageIndex = 1;
  final ValueNotifier<double> offsetLis = new ValueNotifier(0.0);

  void _fetchMoreData() {
    getGankfromNet(URL_GANK_FETCH + widget.title + "/20/$_pageIndex")
        .then((List<GankInfo> data) {
      if (data.isEmpty) {
        //空数据
        _refreshController.sendBack(false, RefreshStatus.noMore);
      } else {
        setState(() {
          for (var item in data) {
            _dataList.add(item);
          }
          _pageIndex++;
        });
        _refreshController.sendBack(false, RefreshStatus.idle);
      }
      return false;
    }).catchError((error) {

      _refreshController.sendBack(false, 4);
      return false;
    });
  }

  void _onOffsetCall(bool up,double offset){
    if(up){
      offsetLis.value = offset;
    }
  }

  void _onRefresh(bool up) {
    if (!up) {
      //上拉加载
      _fetchMoreData();
    } else {
      new Future.delayed(const Duration(milliseconds: 1000)).then((val) {
        _refreshController.sendBack(true, RefreshStatus.completed);
      });
    }
  }

  Widget _buildContent() {
    return new Container(
      color: const Color.fromRGBO(249, 249, 249, 100.0),
      child: new Stack(
        children: <Widget>[
          new ArcIndicator(offsetLis: offsetLis,),
          new SmartRefresher(
            controller: _refreshController,
            child: new ListView.builder(
              itemBuilder: (context, index) =>
                  new GankItem(info: _dataList[index]),
              itemCount: _dataList.length,
            ),
            headerBuilder: (context, mode) => new ClassicIndicator(
                  mode: mode,
                ),
            onRefresh: _onRefresh,
            enablePullUp: true,
            onOffsetChange: _onOffsetCall,
            footerBuilder: (context, mode) => new ClassicIndicator(
                  mode: mode,
                ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new RepaintBoundary(
      child:  _buildContent(),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchMoreData();
    _refreshController = new RefreshController();
  }
}
