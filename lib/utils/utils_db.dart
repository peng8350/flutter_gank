/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/31 下午10:16
 */
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

//GankInfo(
//    {this.desc,
//      this.id,
//      this.like,
//      this.publishedAt,
//      this.source: 'null',
//      this.type,
//      this.url,
//      this.who: 'null',
//      this.img: ''});

//final String id;
//final String desc, publicshedAt, who, url;
//final bool like;
class DbUtils {
  static Database db;

  final _lock = new Lock();


  Future open() async  {
    if (db == null) {
      await _lock.synchronized(() async {
        // Check again once entering the synchronized block
        if (db == null) {
          Directory documentsDirectory = await getApplicationDocumentsDirectory();
          String path = join(documentsDirectory.path, "demo.db");
          db = await openDatabase(path, version: 2,
              onCreate: (Database db, int version) async {
                // When creating the db, create the table
                await db.execute(
                    "create table Gank (id text primary key, img text, source text, type text, desc text, url text, publishedAt text, who text, like integer)");
                await db.execute(
                    "create table Girl (id text primary key, url text, publishedAt text,  who text, like integer)");
              });
        }
      });
    }
  }

  Future<int> insert(String table, Map<String, dynamic> map) async {
    return db.insert(table, map);
  }

  Future<int> update(
      String table, Map map, [String whereSql, List<String> params]) async {
    return await db.update(table, map, where: whereSql, whereArgs: params);
  }

  Future<int> delete(String table, String whereSql, List<String> params) async {
    return await db.delete(table, where: whereSql, whereArgs: params);
  }

  Future<dynamic> getBean(
      String table, String whereSql, List<String> params) async {
    List<Map> maps = await db.query(table,
        columns: ["*"], where: whereSql, whereArgs: params);
    return maps.first;
  }

  Future<List<dynamic>> getList(String table,
      [String whereSql, List<String> params]) async {
    List<Map> maps = await db.query(table,
        columns: ["*"], where: whereSql, whereArgs: params,groupBy: "publishedAt");
    return maps;
  }

  Future close() async => db.close();
}
