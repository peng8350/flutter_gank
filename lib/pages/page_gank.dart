/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/21 下午11:03
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gank/bean/info_gank.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/utils/utils_db.dart';
import 'package:flutter_gank/utils/utils_indicator.dart';
import 'package:flutter_gank/widget/CircleClipper.dart';
import 'package:flutter_gank/widget/item_gank.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gank/utils/utils_http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GankPage extends StatefulWidget {
  final String title;


  GankPage({this.title, Key key}) : super(key: key);

  @override
  _GankPageState createState() => new _GankPageState();
}

class _GankPageState extends State<GankPage> with HttpUtils, IndicatorFactory ,DbUtils{
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

        for (GankInfo item in data){
          _dataList.add(item);
          insert("Gank", item.toMap()).then((val) {
          }).catchError((error){
          });
        }
        _pageIndex++;

        _refreshController.sendBack(false, RefreshStatus.idle);
        setState(() {


        });
      }
      return false;
    }).catchError((error) {
      _refreshController.sendBack(false, 4);
      return false;
    });
  }

  void _onOffsetCall(bool up, double offset) {
    if (up) {
      offsetLis.value = offset;
    }
  }

  void _onClickLike(int index) {
    _dataList[index].like = !_dataList[index].like;
    setState(() {});
    update("Gank", _dataList[index].toMap(), "id = ? ", [_dataList[index].id]);
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
          new ArcIndicator(
            offsetLis: offsetLis,
          ),
          new SmartRefresher(
            controller: _refreshController,
            child: new ListView.builder(
              itemBuilder: (context, index) =>
                  new GankItem(info: _dataList[index],onChange:(){
                    _onClickLike(index);
                  },),
              itemCount: _dataList.length,
            ),
            headerBuilder: buildDefaultHeader,
            footerBuilder: buildDefaultFooter,
            onRefresh: _onRefresh,
            enablePullUp: true,
            onOffsetChange: _onOffsetCall,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new RepaintBoundary(
      child: _buildContent(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshController = new RefreshController();

    open().then((val) {
      getList("Gank","type = ?",[widget.title]).then((List<dynamic> list){
        if(list.isEmpty){
          SharedPreferences.getInstance().then((SharedPreferences preferences) {
            if (preferences.getBool("autoRefresh") ?? false) {
              _fetchMoreData();
            }

          });
        }
        else{
          for(Map map in list){
            _dataList.add(new GankInfo.fromMap(map));
          }
          int aa = list.length~/20;
          _pageIndex = aa+1;


        }
      });

    });
  }
}
