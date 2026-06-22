import 'package:flutter/material.dart';

class LayoutPracticePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('布局练习室'),
      ),
      // 1. SingleChildScrollView: 如果内容超出了屏幕高度，它可以让页面滚动
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1.Container与Row（横向排列）',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  // 2.Row：横向排列子组件
                  Row(
                    children: [
                      // 3.Container：用于包裹其他组件，设置容器的大小、颜色等属性，就像 HTML 的 div，可以设置宽高、颜色、边框等
                      Container(
                          width: 100,
                          height: 100,
                          color: Colors.red,
                          child: Center(
                              child: Text('1',
                                  style: TextStyle(color: Colors.white)))),
                      SizedBox(width: 10),
                      Container(
                          width: 50,
                          height: 50,
                          color: Colors.green,
                          child: Center(
                              child: Text('2',
                                  style: TextStyle(color: Colors.white)))),
                      SizedBox(width: 10),
                      // 4. Expanded: 这是一个弹簧组件！它会把 Row 里剩下的空间全部占满
                      Expanded(
                        child: Container(
                            height: 50,
                            color: Colors.blue,
                            child: Center(
                              child: Text('Expanded（占满剩余空间）',
                                  style: TextStyle(color: Colors.white)),
                            )),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  // 5. Stack: 像一叠纸一样，后面的子组件会盖在前面的组件上面
                  Stack(
                    children: [
                      // 底层：一个大的紫色正方形
                      Container(
                        width: 200,
                        height: 200,
                        color: Colors.purple.shade200,
                      ),
                      // 第二层：中间偏右的一个黄色方块
                      Positioned(
                        top: 20, //距离顶部20像素
                        right: 20, //距离右侧20像素
                        width: 100,
                        height: 100,
                        child: Container(
                          width: 80,
                          height: 80,
                          color: Colors.amber,
                          child: Center(
                            child: Text('盖在上面'),
                          ),
                        ),
                      ),
                      // 第三层：放在正中间的文字
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Text(
                          '我是最上层！',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  // 👇 新增：用一个 for 循环生成大量占位色块，把屏幕撑爆！
                  SizedBox(height: 40),
                  Text('2. 体验 SingleChildScrollView 的滚动',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  for (var i = 0; i < 8; i++)
                    Container(
                      height: 60,
                      margin: EdgeInsets.only(bottom: 10),
                      color: Colors.teal
                          .withValues(alpha: (i % 10 + 1) / 10), // 颜色渐变
                      child: Center(child: Text('我是第 ${i + 1} 个色块，往下滑！')),
                    ),
                  SizedBox(height: 40),
                  Text('3. Flexible vs Expanded',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                          width: 50,
                          height: 50,
                          color: Colors.red,
                          child: Center(
                            child: Text('1',
                                style: TextStyle(color: Colors.white)),
                          )),
                      SizedBox(width: 10),
                      // Flexible: 会按需缩小，但不会强制拉伸占满空间
                      Flexible(
                        child: Container(
                            height: 50,
                            color: Colors.orangeAccent,
                            child: Center(
                              child: Text('Flexible: 内容多我就长，内容少我就短，但我不会超出屏幕',
                                  style: TextStyle(color: Colors.white)),
                            )),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 50,
                        height: 50,
                        color: Colors.greenAccent,
                        child: Center(
                          child:
                              Text('2', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Text('4. GridView (网格布局)',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  // 因为 SingleChildScrollView 里不能直接放无限高的 GridView，所以要限制高度
                  SizedBox(
                      height: 300, //给网格一个固定高度，方便演示
                      child: GridView.count(
                        crossAxisCount: 3, //每行3个
                        mainAxisSpacing: 10, //上下间距
                        crossAxisSpacing: 10, //左右间距
                        children: [
                          // 用循环快速生成 9 个带星星图标的格子
                          for (var i = 0; i < 9; i++)
                            Container(
                              width: 200,
                              height: 200,
                              color: Colors.deepPurple.shade100,
                              child: Center(
                                child: Icon(Icons.star,
                                    size: 50, color: Colors.deepPurple),
                              ),
                            ),
                        ],
                      ))
                ],
              ))),
    );
  }
}
