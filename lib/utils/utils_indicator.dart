import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gank/App.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../constant/colors.dart';
/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/30 上午10:25
 */

class IndicatorFactory {
  Widget buildDefaultHeader(BuildContext context) {
    return new ClassicHeader(
      failedText: '刷新失败!',
      completeText: '刷新完成!',
      releaseText: '释放可以刷新',
      idleText: '下拉刷新哦!',
      failedIcon: new Icon(Icons.clear,
          color: App.of(context).night ? Colors.white : Colors.black),
      completeIcon: new Icon(Icons.done,
          color: App.of(context).night ? Colors.white : Colors.black),
      idleIcon: new Icon(Icons.arrow_downward,
          color: App.of(context).night ? Colors.white : Colors.black),
      releaseIcon: new Icon(Icons.arrow_upward,
          color: App.of(context).night ? Colors.white : Colors.black),
      refreshingText: '正在刷新...',
      textStyle: new TextStyle(
          inherit: true,
          color: App.of(context).night ? Colors.white : Colors.black),
    );
  }

  Widget buildDefaultFooter(BuildContext context, [Function requestLoad]) {
    return new ClassicFooter(
        idleIcon: new Icon(Icons.arrow_upward,
            color: App.of(context).night ? Colors.white : Colors.black),
        textStyle: new TextStyle(
            inherit: true,
            color: App.of(context).night ? Colors.white : Colors.black),
        loadingText: '火热加载中...',
        idleText: '上拉加载',
        noDataText: '没有更多数据');
  }
}
