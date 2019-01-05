import 'package:flutter/material.dart';

void main() => runApp(MyApp());

//容器类widgets

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Row demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Row '),
        ),
//        body: DemoForRow(),
//        body: WrapLayoutTestRoute(),
//        body: FlowLayoutTestRoute(),
//        body: StackLayoutTestRoute(),
//        body: EdgeInsetsLayoutTestRoute(),
//        body: ConstrainedBoxLayoutTestRoute(),
//        body: DecoratedBoxLayoutTestRoute(),
        body: ContainerLayoutTestRoute(),
      ),
    );
  }
}

class ContainerLayoutTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 50, left: 120), //容器补白
      constraints: BoxConstraints.tightFor(width: 200, height: 150), //卡片大小
      decoration: BoxDecoration(
          //背景装饰
          gradient: RadialGradient(
              colors: [Colors.red, Colors.orange],
              center: Alignment.topLeft,
              radius: .98),
          boxShadow: [
            BoxShadow(
                color: Colors.black54, offset: Offset(2, 2), blurRadius: 4)
          ]),
      transform: Matrix4.rotationZ(.2),
      alignment: Alignment.center,
      child: Text('赵二娃',style: TextStyle(color: Colors.white,fontSize: 40),),
    );
  }
}

//Transform的变换不是在布局(layout)阶段，不会影响子widget的实际位置和大小，比较节省性能。RotatedBox的变换是在layout阶段，会影响子widget的实际位置和大小。
class DecoratedBoxLayoutTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DecoratedBox(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.red, Colors.orange[700]]),
          //背景颜色渐变
          borderRadius: BorderRadius.circular(3),
          //圆角
          boxShadow: [
            BoxShadow(
                color: Colors.black54, offset: Offset(2.0, 2.0), blurRadius: 4)
          ]),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 18),
        child: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

Widget redBox = DecoratedBox(decoration: BoxDecoration(color: Colors.red));

class ConstrainedBoxLayoutTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ConstrainedBox(
      constraints: BoxConstraints(
          //限制widget大小
          minWidth: double.infinity, //宽度尽可能大
          minHeight: 50.0 // 最小高度50
          ),
      child: Container(
        height: 5,
        child: redBox,
      ),
    );
  }
}

class EdgeInsetsLayoutTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      //上下左右各添加16像素边距
      padding: EdgeInsets.all(16.0),
      child: Column(
        //显示指定对齐方式为左对齐，排除对齐干扰
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            //左边添加8像素补白
            padding: const EdgeInsets.only(left: 8.0),
            child: Text('Hello World'),
          ),
          Padding(
            //上下
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('I am nice'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Text('Your friend!'),
          )
        ],
      ),
    );
  }
}

class StackLayoutTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            left: 18.0,
            child: Text('I am nice'),
          ),
          Container(
            child: Text(
              "Hello flutter",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.red,
          ),
          Positioned(
            top: 18,
            child: Text('Your best friend!'),
          )
        ],
      ),
    );
  }
}

class FlowLayoutTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Flow(
      delegate: TestFlowDelegate(margin: EdgeInsets.all(10.0)),
      children: <Widget>[
        new Container(
          width: 80.0,
          height: 80.0,
          color: Colors.red,
        ),
        new Container(
          width: 80.0,
          height: 80.0,
          color: Colors.green,
        ),
        new Container(
          width: 80.0,
          height: 80.0,
          color: Colors.blue,
        ),
        new Container(
          width: 80.0,
          height: 80.0,
          color: Colors.yellow,
        ),
        new Container(
          width: 80.0,
          height: 80.0,
          color: Colors.brown,
        ),
        new Container(
          width: 80.0,
          height: 80.0,
          color: Colors.purple,
        ),
      ],
    );
  }
}

class TestFlowDelegate extends FlowDelegate {
  EdgeInsets margin = EdgeInsets.zero;

  TestFlowDelegate({this.margin});

  @override
  void paintChildren(FlowPaintingContext context) {
    //确定每个子widget位置
    var x = margin.left;
    var y = margin.top;
    //计算每一个子widget的位置
    for (int i = 0; i < context.childCount; i++) {
      var w = context.getChildSize(i).width + x + margin.right;
      debugPrint('w: $w');
      if (w < context.size.width) {
        debugPrint('< x,y=($x,$y)');
        context.paintChild(i,
            transform: new Matrix4.translationValues(x, y, 0.0));
        x = w + margin.left;
      } else {
        x = margin.left;
        y += context.getChildSize(i).height + margin.top + margin.bottom;
        debugPrint('> x,y=($x,$y)');
        //绘制子widget
        context.paintChild(i,
            transform: new Matrix4.translationValues(x, y, 0.0));
      }
      x += context.getChildSize(i).width + margin.left + margin.right;
    }
  }

  @override
  Size getSize(BoxConstraints constraints) {
    // TODO: implement getSize
    //需要返回一个固定大小来指定Flow的大小
    return Size(double.infinity, 300.0);
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate != this;
  }
}

//wrap超出部分折行
class WrapLayoutTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Wrap(
      spacing: 18.0, //主轴方向间距
      runSpacing: 14.0, //纵轴方向间距
      alignment: WrapAlignment.center, // /沿主轴方向居中
      children: <Widget>[
        new Chip(
          label: new Text('Hamilton ' * 5),
          avatar: new CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text('A'),
          ),
        ),
        new Chip(
            label: new Text('Lafayette'),
            avatar: new CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text('B'),
            )),
        new Chip(
          label: new Text('Mulligan'),
          avatar: new CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text('H'),
          ),
        ),
        new Chip(
          label: new Text('Laurens'),
          avatar: new CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text('J'),
          ),
        )
      ],
    );
  }
}

//Expanded 按比例'扩伸' Row/Column/Flex子Widget所占用的空间
class FlexLayoutTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        //Flex的两个字widget按1：2来占据水平空间
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                height: 30.0,
                color: Colors.red,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 30.0,
                color: Colors.green,
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SizedBox(
            height: 100.0,
            //Flex的三个子widget，在垂直方向按2：1：1来占用100像素的空间
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 30.0,
                    color: Colors.red,
                  ),
                ),
                Spacer(
                  //占用指定比例的空间，实际是Expanded的一个包装
                  flex: 1,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 30.0,
                    color: Colors.green,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

//线性布局Row/Column
class DemoForRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Column(
      //测试Row的对齐方式
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text("hello world"), Text("I am Nice")],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text("hello world"), Text("I am Nice")],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          textDirection: TextDirection.rtl,
          children: <Widget>[Text("hello world"), Text("I am Nice")],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          verticalDirection: VerticalDirection.up,
          children: <Widget>[
            Text(
              "hello world",
              style: TextStyle(fontSize: 30.0),
            ),
            Text("I am Nice")
          ],
        )
      ],
    );
  }
}
