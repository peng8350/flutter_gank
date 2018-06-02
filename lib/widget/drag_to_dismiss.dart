/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/6/2 上午12:07
 */

import 'package:flutter/material.dart';

class DragToDismiss extends StatefulWidget {
  final Function onDismiss;

  final Widget child;

  DragToDismiss({this.onDismiss, this.child});

  createState() => new _DragToMissState();
}

class _DragToMissState extends State<DragToDismiss>
    with SingleTickerProviderStateMixin {
  bool _dragLeaved = false;
  AnimationController _controller;

  Widget dragTarget() {
    return new DragTarget(builder: (_, __, ___) {
      return new Container(
        color: Colors.transparent,
        height: 150.0,
      );
    }, onWillAccept: (_) {
      _controller.value = 1.0;
      _dragLeaved = false;
      return true;
    }, onLeave: (_) {
      _controller.value = 0.4;
      _dragLeaved = true;
    });
  }

  _onDragEnd(_, __) {
    if (_dragLeaved && widget.onDismiss != null) {
      widget.onDismiss();
    }
    _controller.value = 1.0;
    _dragLeaved = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100), value: 1.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new LayoutBuilder(builder: (context, cons) {
      return new Stack(
        children: <Widget>[
          new Container(
            height: 150.0,
            child: dragTarget(),
            width: double.infinity,
            margin: new EdgeInsets.only(left: 100.0, right: 100.0),
          ),
          new LongPressDraggable(
            child: widget.child,
            feedback: new FadeTransition(
              child: new Container(
                width: cons.biggest.width,
                height: 150.0,
                child: widget.child,
              ),
              opacity: _controller,
            ),
            childWhenDragging: new Container(
              width: cons.biggest.width,
              height: 145.0,
            ),
            onDraggableCanceled: _onDragEnd,
          )
        ],
      );
    });
  }
}
