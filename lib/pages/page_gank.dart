/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/21 下午11:03
 */

import 'package:flutter/material.dart';
import 'package:flutter_gank/bean/info_gank.dart';
import 'package:flutter_gank/constant/strings.dart';
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

  void _fetchMoreData() {
    getGankfromNet(URL_GANK_FETCH + widget.title + "/20/$_pageIndex")
        .then((List<GankInfo> data) {
      if (data.isEmpty) {
        //空数据
        _refreshController.sendBack(false, RefreshStatus.noMore);
      } else {
        for (var item in data) {
          _dataList.add(item);
        }
        _pageIndex++;
        setState(() {});
        _refreshController.sendBack(false, RefreshStatus.idle);
      }
    }).catchError(() {
      _refreshController.sendBack(false, RefreshStatus.failed);
    });
  }

  void _onRefresh(bool up) {
    if (!up) {
      //上拉加载
      _fetchMoreData();
    }
  }

  Widget _buildContent() {
    return new Container(
      color: const Color.fromRGBO(249, 249, 249, 100.0),
      child: new SmartRefresher(

        enablePullDown: false,
        enablePullUp: true,
        headerBuilder: (context, mode) => new ClassicIndicator(mode: mode),
        footerBuilder: (context, mode) => new ClassicIndicator(
            mode: mode,
            idleIcon: const Icon(Icons.arrow_upward,color:Colors.grey),
            refreshingText: '',
            idleText: '上拉加载',
            failedText: '加载失败,网络异常'),
        controller: _refreshController,
        child: new Container(
          color: Colors.white,
          child: new ListView.builder(
              itemBuilder: (context,index) => new GankItem(info: _dataList[index]),
              itemCount: _dataList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true),
        ),
        onRefresh: _onRefresh,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshController = new RefreshController();
  }
}
