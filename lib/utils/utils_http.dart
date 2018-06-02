/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/22 上午11:26
 */
import 'dart:async';
import 'package:flutter_gank/bean/info_gank.dart';
import 'package:http/http.dart' as http ;
import 'dart:convert';

class HttpUtils {



  Future<String> get(String url, [Map params]) async {
    http.Response response = await http.get(url, headers: params);
    return response.body.toString();
  }

  List<GankInfo> toGankList(String responseStr) {
    Map<String, dynamic> map = json.decode(responseStr);
    List<GankInfo> list = [];
    for (var item in map['results']) {
      print(item);
      list.add(new GankInfo.fromJson(item));
    }
    return list;
  }

  List<GirlInfo> toGirlList(String responseStr) {
    Map<String, dynamic> map = json.decode(responseStr);
    List<GirlInfo> list = [];
    for (var item in map['results']) {
      list.add(new GirlInfo.fromJson(item));
    }
    return list;
  }

  Future<List<GankInfo>> getGankfromNet(String url) async {
    final responseStr = await get(url);
    return toGankList(responseStr);
  }

  Future<List<GirlInfo>> getGirlfromNet(String url) async {
    final String responseStr = await get(url);

    return toGirlList(responseStr);
  }



}
