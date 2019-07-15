/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time:  2019-07-15 11:27
 */

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SliverImageHeader extends SingleChildRenderObjectWidget {
  final Widget child;
  final double hiddenHeight;

  SliverImageHeader({this.child, this.hiddenHeight}) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    return _RenderSliverImageHeader(hiddenHeight: hiddenHeight);
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderSliverImageHeader renderObject) {
    // TODO: implement updateRenderObject
    renderObject.hiddenHeight = hiddenHeight;
  }
}

class _RenderSliverImageHeader extends RenderSliverToBoxAdapter {
  _RenderSliverImageHeader({this.hiddenHeight, RenderBox child})
      : super(child: child);
  double hiddenHeight;

  @override
  void performLayout() {
    // TODO: implement performLayout
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    child.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child.size.width - hiddenHeight;
        break;
      case Axis.vertical:
        childExtent = child.size.height - hiddenHeight;
        break;
    }
    assert(childExtent != null);
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintOrigin: -hiddenHeight,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    setChildParentData(child, constraints, geometry);
  }
}
