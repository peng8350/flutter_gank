import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gank/bean/info_gank.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/utils/utils_http.dart';
import 'package:flutter_gank/utils/utils_indicator.dart';
import 'package:flutter_gank/widget/item_gank.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../widget/CircleClipper.dart';

/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/22 下午1:16
 */

class GirlPage extends StatefulWidget {
  @override
  _GirlPageState createState() => new _GirlPageState();
}

class _GirlPageState extends State<GirlPage> with IndicatorFactory, HttpUtils {
  List<GirlInfo> _dataList = [];

  RefreshController _refreshController;

  int _pageIndex = 1;

  ValueNotifier<double> offsetLis = new ValueNotifier(0.0);

  void _fetchMoreData() {
    getGirlfromNet(URL_GANK_FETCH + "福利" + "/20/$_pageIndex")
        .then((List<GirlInfo> data) {
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

  @override
  void initState() {
    // TODO: implement initState
    _refreshController = new RefreshController();

    super.initState();
  }

  void _onOffsetCall(bool up, double offset) {
    if (up) {
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

  Widget _buildGirlItem(BuildContext context, int index) {
    return new RepaintBoundary(
      child: new FadeInImage.assetNetwork(
          placeholder: 'images/empty.png',
          image: _dataList[index].url,
          fit: BoxFit.cover,
          imageScale: 0.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: const Color.fromRGBO(249, 249, 249, 100.0),
      child: new Stack(
        children: <Widget>[
          new ArcIndicator(
            offsetLis: offsetLis,
          ),
          new SmartRefresher(
            controller: _refreshController,
            child: new StaggeredGridView.countBuilder(
              crossAxisCount: 6,
              itemCount: _dataList.length,
              itemBuilder: _buildGirlItem,
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(3, index.isEven ? 3 : 2),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
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
}
