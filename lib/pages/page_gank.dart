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
import 'package:flutter/scheduler.dart';

class GankPage extends StatefulWidget {
  final String title;

  final bool isSeaching;

  GankPage({this.title, Key key, this.isSeaching}) : super(key: key);

  @override
  GankPageState createState() => new GankPageState();
}

class GankPageState extends State<GankPage>
    with HttpUtils, IndicatorFactory, DbUtils {
  List<GankInfo> _dataList = [];
  List<GankInfo> _searchList = [];
  RefreshController _refreshController;
  ScrollController _scrollController;
  int _pageIndex = 1;
  final ValueNotifier<double> offsetLis = new ValueNotifier(0.0);

  //捕捉应该要插入多少个新的数据
  int _catchEndPos(List<GankInfo> newData) {
    if (_dataList.isEmpty) {
      return newData.length;
    } else {
      for (int i = 0; i < newData.length; i++) {
        if (newData[i].id == _dataList[0].id) {
          return i;
        }
        else{
          int j = i+1;
          //是否存在
          while(j<_dataList.length&&_dataList[j].desc==newData[j].desc){
            if(_dataList[j].id!=newData[i].id){
              j++;
            }
            else{
              return i;
            }
          }
        }
      }
    }
    return 0;
  }

  void _refreshNewData() {
    getGankfromNet(URL_GANK_FETCH + widget.title + "/20/1")
        .then((List<GankInfo> data) {

      for (int i = _catchEndPos(data)-1; i >= 0; i--) {
        _dataList.insert(0, data[i]);
        insert("Gank", data[i].toMap()).then((val) {}).catchError((error) {});
      }
      if (_dataList.length > 0)
        _pageIndex = (_dataList.length ~/ 20).toInt() + 1;
      _refreshController.refreshCompleted();
      setState(() {});
      return false;
    }).catchError((error) {
      print(error);
      _refreshController.refreshFailed();
      return false;
    });
  }

  void _fetchMoreData() {
    getGankfromNet(URL_GANK_FETCH + widget.title + "/20/$_pageIndex")
        .then((List<GankInfo> data) {
      if (data.isEmpty) {
        //空数据
        SchedulerBinding.instance.addPostFrameCallback((_){
          _refreshController.loadNoData();
        });

      } else {
        for (GankInfo item in data) {
          _dataList.add(item);
          insert("Gank", item.toMap()).then((val) {}).catchError((error) {});
        }
        _pageIndex++;

        SchedulerBinding.instance.addPostFrameCallback((_){
          _refreshController.loadComplete();

        });
        setState(() {});
      }
      return false;
    }).catchError((error) {

      return false;
    });
  }

  void _onOffsetCall(bool up, double offset) {
    print(offset);
    if (up) {
      offsetLis.value = offset;
    }
  }

  void _onClickLike(GankInfo item) {
    item.like = !item.like;

    update("Gank", item.toMap(), "id = ? ", [item.id]);
    setState(() {});
  }

  void _onRefresh() {
    _refreshNewData();

  }

  void _onLoad(){
    _fetchMoreData();
  }

  void searchGank(String searchText) {
    _searchList.clear();
    for (GankInfo item in _dataList) {
      if (item.isAvailableSearch(searchText)) {
        _searchList.add(item);
      }
    }
    setState(() {});
  }

  Widget _buildContent(showFoot) {
    if (!widget.isSeaching)
      return new Stack(
        children: <Widget>[
          new ArcIndicator(
            offsetLis: offsetLis,
          ),
          new SmartRefresher(
            controller: _refreshController,
            child: new ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) => new GankItem(
                    info: _dataList[index],
                    onChange: () {
                      _onClickLike(_dataList[index]);
                    },
                  ),
              itemCount: _dataList.length,
            ),
            header: buildDefaultHeader(context),
            footer: buildDefaultFooter(context,(){
              _refreshController.requestLoading();
            }),
            onRefresh: _onRefresh,
            onLoading: _onLoad,

            enablePullUp: showFoot,
            onOffsetChange: _onOffsetCall,
          )
        ],
      );
    else
      return new ListView.builder(
        itemBuilder: (context, index) => new GankItem(
              info: _searchList[index],
              onChange: () {
                _onClickLike(_searchList[index]);
              },
            ),
        itemCount: _searchList.length,
      );
  }

  @override
  Widget build(BuildContext context) {

    return new LayoutBuilder(builder: (BuildContext context,BoxConstraints size){
      double listHeight = size.biggest.height;
      double innerHeight = _dataList.length*135.0;
      return _buildContent(innerHeight>listHeight);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GankPage oldWidget) {
    // TODO: implement didUpdateWidget
    getList("Gank", "type = ?", [widget.title]).then((maps) {
      _dataList.clear();
      for (Map map in maps) {
        _dataList.add(new GankInfo.fromMap(map));
      }
      int aa = maps.length ~/ 20;
      _pageIndex = aa + 1;
      setState(() {});
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshController = new RefreshController();
    _scrollController = new ScrollController();
    getList("Gank", "type = ?", [widget.title]).then((List<dynamic> list) {
      if (list.isEmpty) {
        SharedPreferences.getInstance().then((SharedPreferences preferences) {
          if (preferences.getBool("autoRefresh") ?? false) {
            _refreshController.requestRefresh();
          }
        });
      } else {
        for (Map map in list) {
          _dataList.add(new GankInfo.fromMap(map));
        }
        int aa = list.length ~/ 20;
        _pageIndex = aa + 1;
      }
    });
  }
}
