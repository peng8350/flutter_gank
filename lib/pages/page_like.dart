/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/6/1 下午8:01
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gank/bean/info_gank.dart';
import 'package:flutter_gank/constant/colors.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/utils/utils_db.dart';
import 'package:flutter_gank/widget/cached_pic.dart';
import 'package:flutter_gank/widget/drag_to_dismiss.dart';
import 'package:flutter_gank/widget/item_gank.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class LikePage extends StatefulWidget {
  @override
  _LikePageState createState() => new _LikePageState();
}

class _LikePageState extends State<LikePage> with DbUtils {
  int _selectIndex = 0;
  Future<List<dynamic>> _catchGirls;
  List<GirlInfo> _girlList = [];

  Widget _buildGankList() {
    return new ListView(
      cacheExtent: 555555.0,
      children: <Widget>[
        new GankGroup(
          GANK_TITLES[0],
        ),
        new GankGroup(
          GANK_TITLES[1],
        ),
        new GankGroup(
          GANK_TITLES[2],
        ),
        new GankGroup(
          GANK_TITLES[3],
        ),
        new GankGroup(
          GANK_TITLES[4],
        ),
        new GankGroup(
          GANK_TITLES[5],
        ),
        new GankGroup(
          GANK_TITLES[6],
        )
      ],
    );
  }

  Widget _buildBottomSheet(int index, Function onClose) {
    return new Container(
      padding: const EdgeInsets.all(15.0),
      color: COLOR_BANTANSPARENT,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text('确定要删除吗?'),
          new Row(
            children: <Widget>[
              new InkWell(
                child: new Container(
                    child: const Icon(Icons.check),
                    margin: const EdgeInsets.all(5.0)),
                onTap: () {
                  _cancelLike(index);
                  onClose();
                },
              ),
              new InkWell(
                child: new Container(
                  margin: const EdgeInsets.all(5.0),
                  child: const Icon(Icons.clear),
                ),
                onTap: () {
                  onClose();
                },
              )
            ],
          )
        ],
      ),
    );
  }

  void _cancelLike(int index) {
    _girlList[index].like = false;
    update("Girl", _girlList[index].toMap(), " id = ? ", [_girlList[index].id]);
    _girlList.removeAt(index);
    setState(() {});
  }

  Widget _buildGirlList() {
    return new FutureBuilder(
        builder: (context, shot) {
          if (shot.connectionState == ConnectionState.none ||
              shot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: const CircularProgressIndicator(),
            );
          } else {
            if (shot.hasError) {
              return new Center(child: new Text('网络异常!!!'));
            } else
              return new StaggeredGridView.countBuilder(
                crossAxisCount: 6,
                itemCount: _girlList.length,
                itemBuilder: (context, index) => new GestureDetector(
                      child: new CachedPic(url: _girlList[index].url),
                      onLongPress: () {
                        PersistentBottomSheetController sheetController;
                        Function closeFun = () {
                          sheetController.close();
                        };
                        sheetController = showBottomSheet(
                            context: context,
                            builder: (context) {
                              return _buildBottomSheet(index, closeFun);
                            });
                      },
                    ),
                staggeredTileBuilder: (int index) =>
                    new StaggeredTile.count(3, index.isEven ? 3 : 2),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              );
          }
        },
        future: _catchGirls);
  }

  Widget _buildContent() {
    return new Stack(
      children: <Widget>[
        new Offstage(
          offstage: _selectIndex != 0,
          child: _buildGirlList(),
        ),
        new Offstage(
          offstage: _selectIndex != 1,
          child: _buildGankList(),
        )
      ],
    );
  }

  Widget _buildBottom() {
    return new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.insert_photo,
                  color: _selectIndex == 0 ? DEFAULT_THEMECOLOR : Colors.grey),
              title: new Text(
                '妹子',
                style: new TextStyle(
                    inherit: true,
                    color:
                        _selectIndex == 0 ? DEFAULT_THEMECOLOR : Colors.grey),
              )),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.explore,
                  color: _selectIndex == 1 ? DEFAULT_THEMECOLOR : Colors.grey),
              title: new Text(
                '干货',
                style: new TextStyle(
                    inherit: true,
                    color:
                        _selectIndex == 1 ? DEFAULT_THEMECOLOR : Colors.grey),
              ))
        ],
        onTap: (index) {
          _selectIndex = index;
          setState(() {});
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    _catchGirls = getList("Girl", " like = 1 ").then((List<dynamic> maps) {
      for (var m in maps) {
        _girlList.add(new GirlInfo.fromMap(m));
      }
    });
    super.initState();
  }

  @override
  void didUpdateWidget(LikePage oldWidget) {
    // TODO: implement didUpdateWidget
    _girlList.clear();
    _catchGirls = getList("Girl", " like = 1 ").then((List<dynamic> maps) {
      for (var m in maps) {
        _girlList.add(new GirlInfo.fromMap(m));
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Flexible(child: _buildContent()),
          _buildBottom()
        ],
      ),
    );
  }
}

class GankGroup extends StatefulWidget {
  final groupName;

  GankGroup(String groupName) : this.groupName = groupName;

  @override
  _GankGroupState createState() => new _GankGroupState();
}

class _GankGroupState extends State<GankGroup>
    with SingleTickerProviderStateMixin, DbUtils {
  AnimationController _controller;
  Future _future;
  List<GankInfo> _list=[];

  @override
  void initState() {
    // TODO: implement initState
    _controller = new AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        lowerBound: 0.75,
        value: 1.0);
    _future = getList("Gank", " type = ? and like = 1 ", [widget.groupName]).then((data){
      for(Map m in data){
        _list.add(new GankInfo.fromMap(m));
      }
    });
    super.initState();
  }

  @override
  void didUpdateWidget(GankGroup oldWidget) {
    // TODO: implement didUpdateWidget
    _list.clear();
    _future = getList("Gank", " type = ? and like = 1 ", [widget.groupName]).then((data){
      for(Map m in data){
        _list.add(new GankInfo.fromMap(m));
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return new ExpansionTile(
      title: new Text(widget.groupName),
      children: [
        new FutureBuilder(
            builder: (context, asnc) {
              if (asnc.connectionState == ConnectionState.waiting) {
                return new Column(
                    children: <Widget>[new CircularProgressIndicator()]);
              } else if (asnc.connectionState == ConnectionState.none) {
                return new Container();
              } else {
                if (asnc.hasError) {
                  return new Column(children: <Widget>[new Text('网络异常')]);
                } else {
                  List<Widget> childrens = [];
                  for(int i = 0 ;i<_list.length;i++)
                    childrens.add(new DragToDismiss(
                        child: new GankItem(
                          info: _list[i],
                          showLike: false,
                        ),
                        onDismiss: () {
                          _list[i].like = false;
                          update("Gank", _list[i].toMap(),"id = ? ",[_list[i].id]);
                          _list.removeAt(i);
                          setState(() {

                          });
                        })
                    );
                  return new Column(children: childrens);
                }
              }
            },
            future: _future)
      ],
      onExpansionChanged: (val) {
        _controller.animateTo(val ? 1.0 : 0.75);
      },
      initiallyExpanded: true,
      trailing: new Icon(
        Icons.keyboard_arrow_right,
      ),
      leading: new RotationTransition(
          turns: _controller, child: new Icon(Icons.arrow_drop_down_circle)),
    );
  }
}
