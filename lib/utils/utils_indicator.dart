import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/30 上午10:25
 */

class IndicatorFactory{


  Widget buildDefaultHeader(BuildContext context, int mode) {
    return new ClassicIndicator(
      failedText: '刷新失败!',
      completeText: '刷新完成!',
      releaseText: '释放可以刷新',
      idleText: '下拉刷新哦!',
      refreshingIcon:   const CircularProgressIndicator(strokeWidth: 2.0),
      failedIcon: const Icon(Icons.clear, color: Colors.black),
      completeIcon: const Icon(Icons.done, color: Colors.black),
      idleIcon: const Icon(Icons.arrow_downward, color: Colors.black),
      releaseIcon: const Icon(Icons.arrow_upward, color: Colors.black),
      refreshingText: '正在刷新...',
      mode: mode,
    );
  }

  Widget buildDefaultFooter(BuildContext context, int mode) {
    return new ClassicIndicator(
        mode: mode,
        idleIcon: const Icon(Icons.arrow_upward,color:Colors.grey),

        refreshingText: '火热加载中...',
        idleText: '上拉加载',
        failedText: '网络异常',
        noDataText: '没有更多数据');
  }


}