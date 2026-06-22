import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:async';
import '../screens/detail_page.dart';

// 这是一个有状态的Widget
class StatePracticePage extends StatefulWidget {
  @override
  State<StatePracticePage> createState() => _StatePracticePageState();
}

// 这是专门用来管理上面那个 Widget 状态的类 (注意类名前面有个下划线，代表它是私有的)
class _StatePracticePageState extends State<StatePracticePage> {
  // A.顶一个内部状态变量（用来存放数字）
  int _counter = 0;
  // 用来存放当前的水管，初始为 null（水管还没接上）
  Stream<String>? _currentCookStream;

  // B.定义一个改变状态的方法
  void _incrementCounter() {
    // 🚨 核心重点：必须调用 setState()！
    // 只有把它包在 setState 里，Flutter 才知道要去刷新屏幕
    setState(() {
      _counter++;
    });
    log('按钮被点击了！当前数字是: $_counter', name: 'StatePractice');
    // print('按钮被点击了！$_counter');
  }

  // E.重置状态
  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  // 1. 返回类型是 Stream<String>，代表这是一根会流出字符串的水管
  // 2. 注意关键字变成了 async* (多了一个星号)，这代表它是一个"异步生成器"，可以持续产出数据
  Stream<String> _cookFoodStream(int cookTime) async* {
    // 先吐出第一句话
    yield '正在拼命炖佛跳墙，还剩 $cookTime 秒...';
    for (int i = cookTime; i > 0; i--) {
      // 每次循环，先死等 1 秒钟
      await Future.delayed(Duration(seconds: 1));
      // 1 秒过后，通过水管吐出最新的状态
      yield '正在拼命炖佛跳墙，还剩 ${i - 1} 秒...';
    }

    // 循环结束了，再等最后半秒假装端菜，然后吐出最终结果
    await Future.delayed(Duration(milliseconds: 500));
    yield '🍲 佛跳墙炖好啦！';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('状态练习室'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('你点击了右下角的+号按钮这么多次：', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              // C. 在界面上展示状态变量 $_counter
              Text('$_counter',
                  style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      // color: Theme.of(context).colorScheme.primary)),
                      color: _counter % 2 == 0 ? Colors.red : Colors.green)),
              SizedBox(height: 20),
              ElevatedButton.icon(
                  onPressed: _resetCounter,
                  icon: Icon(Icons.restore),
                  label: Text('重置计数器')),
              SizedBox(height: 20),
              FilledButton(
                // 🚨 核心代码 1：跳转到新页面 (Push)
                // 告诉管家，我要放一个新盘子（MaterialPageRoute）到最上面
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailPage(
                                passedNumber: _counter,
                              )));
                },
                child: Text('跳到详情页 🚀'),
              ),
              SizedBox(height: 20),
              // 🚨 核心体验：用 StreamBuilder 接住水管
              StreamBuilder<String>(
                // 接上水管，如果没有水管（初始状态），就传 null
                stream: _currentCookStream,
                // snapshot 就是从水管里流出来的那滴水（数据）
                builder: (context, snapshot) {
                  // 1.如果水管还没接上，或者水管里还没水，就显示等待中
                  if (snapshot.connectionState == ConnectionState.none) {
                    return Text(
                      '厨师正在休息...',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    );
                  }

                  // 2.接上了，正在等第一滴水
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  // 3.锅炸了（出错了）
                  if (snapshot.hasError) {
                    return Text(
                      '哎呀，做菜失败了${snapshot.error}',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    );
                  }

                  // 把水管里流出来的最新文字显示在屏幕上
                  // return Text(
                  //   snapshot.data ?? '',
                  //   style:
                  //       TextStyle(fontSize: 20, color: Colors.lightBlueAccent),
                  // );

                  // 4. 水管正常出水（active）或者 已经出完了（done）
                  if (snapshot.hasData) {
                    // 我们可以根据 connectionState 给出不同的颜色提示
                    Color textColor =
                        snapshot.connectionState == ConnectionState.done
                            ? Colors.green
                            : Colors.orange;

                    return Text(
                      snapshot.data ?? '',
                      style: TextStyle(fontSize: 20, color: textColor),
                    );
                  }

                  return Text('未知状态');
                },
              ),
              SizedBox(height: 10),

              // 点击按钮开始做菜
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // 点击按钮时，创造一根倒计时 3 秒的新水管，赋给变量。
                    // 只要 _currentCookStream 变了，StreamBuilder 就会自动开始接水并刷新 UI！
                    _currentCookStream = _cookFoodStream(3);
                  });
                },
                child: Text('点一道佛跳墙 (测试 Stream)'),
              ),
            ],
          ),
        ),
        // D. 放一个右下角的悬浮按钮来触发 _incrementCounter 方法
        floatingActionButton: FloatingActionButton(
          heroTag: 'counter_fab',
          onPressed: _incrementCounter,
          child: Icon(Icons.add),
        ));
    // floatingActionButton: Row(
    //   mainAxisAlignment: MainAxisAlignment.end,
    //   children: [
    //     FloatingActionButton(
    //       onPressed: _incrementCounter,
    //       child: Icon(Icons.add),
    //     ),
    //     // SizedBox(width: 10),
    //     // FloatingActionButton(
    //     //   onPressed: _resetCounter,
    //     //   child: Icon(Icons.restore),
    //     // ),
    //     // ElevatedButton(onPressed: _resetCounter, child: Icon(Icons.restore)),
    //   ],
    // ));
  }
}
