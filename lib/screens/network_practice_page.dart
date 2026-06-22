import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/daily_quote.dart';

class NetworkPracticePage extends StatefulWidget {
  @override
  State<NetworkPracticePage> createState() => _NetworkPracticePageState();
}

class _NetworkPracticePageState extends State<NetworkPracticePage> {
  // 定义一个 Future 变量，用来装我们即将从网络上获取的一句话
  Future<DailyQuote>? _quoteFuture;

  // 🚨核心体验 1：这是核心的网络请求方法！
  Future<DailyQuote> fetchQuote() async {
    // 1. 换一个国内非常稳定且不需要证书校验的 API (这是一个返回随机一言的接口)
    // final url =
    //     Uri.parse('http://api.btstu.cn/yan/api.php?charset=utf-8&encode=json');
    final url = Uri.parse('https://v2.xxapi.cn/api/yiyan?type=hitokoto');

    // 🌟 新增错误处理：用 try-catch 包裹网络请求，捕获断网或超时等异常
    try {
      // 加上 timeout 限制，如果 10 秒连不上就直接抛出异常，不让用户死等
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      // 3. 检查服务器返回的状态码 (200 代表成功)
      if (response.statusCode == 200) {
        // 打印服务器返回的原始 JSON 字符串
        print('服务器返回的原始 JSON 字符串: ${response.body}');

        // 4. 服务器返回的是一长串 JSON 字符串，我们需要用 jsonDecode 把它变成 Dart 认识的 Map (字典)
        Map<String, dynamic> jsonMap = jsonDecode(response.body);

        //直接拿到 data 字段的字符串！
        String theQuote = jsonMap['data'];

        // 5. 这个国内 API 返回的数据结构中，文字放在 'text' 字段里
        //  🚨核心改动：不再手动取字段，直接把整个 Map 扔给模型的 fromJson 方法！
        // return DailyQuote.fromJson(jsonMap);
        return DailyQuote(text: theQuote);
      } else {
        // 如果失败了（比如404找不到，500服务器崩溃）
        throw Exception('网络请求失败啦！状态码: ${response.statusCode}');
      }
    } on Exception catch (e) {
      // 🌟 如果根本没连上服务器（比如断网、超时）
      // e.toString() 会打印出具体的错误原因
      throw Exception('网络似乎开小差了，请检查网络设置或稍后再试。\n具体原因: $e');
    }

    // 2. 发送 GET 请求，并用 await 停在这里死等结果回来！
    // final response = await http.get(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('网络请求练习室')),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🚨核心体验 2：用 FutureBuilder 接住这唯一的包裹
              // 上节课我们用 StreamBuilder 接源源不断的水管
              // 这节课我们用 FutureBuilder 接只送一次的快递 (Future)
              FutureBuilder<DailyQuote>(
                  future: _quoteFuture,
                  builder: (context, snapshot) {
                    // 1. 还没点按钮，连快递都没发
                    if (snapshot.connectionState == ConnectionState.none) {
                      return Text('点击下面按钮获取每日一句',
                          style: TextStyle(fontSize: 18));
                    }

                    // 2. 快递正在路上 (网络请求中)
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // return CircularProgressIndicator(); // 显示原生的转圈圈动画
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                    }

                    // 3. 快递翻车了 (网络报错)
                    if (snapshot.hasError) {
                      // return Text('网络请求失败啦！${snapshot.error}',
                      //     style: TextStyle(fontSize: 18, color: Colors.red));

                      // 🌟 新增：优雅的报错界面
                      return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // 让 Column 紧凑一点
                            children: [
                              Icon(Icons.wifi_off,
                                  size: 50, color: Colors.redAccent),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                // replaceAll 用来去掉系统自动加的难看的 'Exception: ' 前缀
                                '${snapshot.error}'
                                    .replaceAll('Exception:', ''),
                                style: TextStyle(
                                    fontSize: 16, color: Colors.redAccent),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ));
                    }

                    // 4. 快递顺利送达！
                    if (snapshot.hasData) {
                      // return Text(
                      //   snapshot.data!.text,
                      //   style: TextStyle(
                      //       fontSize: 24, fontStyle: FontStyle.italic),
                      //   textAlign: TextAlign.center,
                      // );
                      return AnimatedSwitcher(
                          duration: Duration(milliseconds: 800), // 动画持续 0.8 秒
                          // transitionBuilder 可以自定义动画效果，这里我们让它既有透明度变化，又有缩放效果
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: FadeTransition(
                                opacity: animation, // 透明度动画
                                child: child,
                              ),
                            );
                          },
                          // 注意：这里必须要加一个 key！
                          // 这是为了告诉 Flutter，每次文字变了，这是一个全新的组件，请重新播放动画！
                          child: Text(
                            snapshot.data!.text,
                            key: ValueKey<String>(snapshot.data!.text),
                            style: TextStyle(
                                fontSize: 24, fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ));
                    }

                    return SizedBox();
                  }),

              SizedBox(
                height: 40,
              ),

              FilledButton.icon(
                  onPressed: () {
                    // 🚨核心体验 3：点击按钮，发起一次全新的网络请求！
                    setState(() {
                      _quoteFuture = fetchQuote();
                    });
                  },
                  icon: Icon(Icons.transform_outlined),
                  label: Text('获取每日一言'))
            ],
          ),
        )));
  }
}
