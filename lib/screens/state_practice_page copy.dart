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
  String _cookStatus = '厨师正在休息...'; // 新增：用来显示做菜状态;
  int _cookTime = 3;

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

  // 这是一个模拟网络请求/耗时任务的异步方法
  // 1. 在括号后面加 async 关键字，说明这个方法里有耗时操作
  // 2. 返回值前面加 Future<String>，代表它未来会返回一个字符串
  Future<String> _cookFood() async {
    // await 的意思是：停在这里等一等，但别卡死整个 App
    // Future.delayed 是 Dart 自带的方法，用来模拟等待一段时间
    // Completer 就像是一个“手动控制的开关”
    // 因为 Timer 是另外开的一个定时任务，我们没法直接在 Timer 里面 return 结果给外面的 async 方法。
    // 所以我们用 Completer，等倒计时结束时，手动拨动开关(complete)，把结果送出去。

    Completer<String> completer = Completer<String>();
    int remainingTime = _cookTime;

    // // Timer.periodic 的意思是：每隔指定的时间（这里是1秒），就执行一次大括号里的代码
    // await Future.delayed(Duration(seconds: remainingTime));
    // // $_cookTime 秒之后，执行下面这句，把结果返回
    // return '🍲 佛跳墙炖好啦！';

    Timer.periodic(Duration(seconds: 1), (timer) {
      remainingTime--; //每次执行，剩余时间减 1

      if (remainingTime > 0) {
        // 如果时间还没到 0，就用 setState 告诉 Flutter：哎，时间变啦，赶紧刷新一下界面！
        setState(() {
          _cookStatus = '正在拼命炖佛跳墙，还剩 $remainingTime 秒...';
        });
      } else {
        // 如果时间到了，就用 setState 告诉 Flutter：做菜完成啦！
        timer.cancel(); // 1. 赶紧把定时器关掉，不然它会一直跑下去
        completer.complete('🍲 佛跳墙炖好啦！'); //2. 拨动开关，把最终的菜端出去
      }
    });

    // 这里先返回一个“承诺”（Future）。
    // 外面的代码(比如按钮点击事件里的 await)会一直等，直到上面触发了 completer.complete()
    return completer.future;
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
              // 展示厨师的状态
              Text(_cookStatus,
                  style:
                      TextStyle(fontSize: 20, color: Colors.lightBlueAccent)),
              SizedBox(height: 10),
              // 点击按钮开始做菜
              ElevatedButton(
                // 注意这里：因为点击事件里面要用 await，所以这个匿名函数也要标记为 async
                onPressed: () async {
                  setState(() {
                    _cookStatus = '正在拼命炖佛跳墙，还剩 $_cookTime 秒...';
                  });
                  // 🚨 核心体验点：用 await 等待那道菜做完
                  // 在等待的这 $_cookTime 秒里，你可以去点右下角的 + 号，你会发现界面完全没卡住！
                  String result = await _cookFood();
                  setState(() {
                    _cookStatus = result;
                  });
                },
                child: Text('点一道佛跳墙 (测试异步)'),
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
