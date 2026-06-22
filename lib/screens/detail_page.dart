import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  // 1.定义一个变量来接收传过来的数字
  final int passedNumber;

  // 2.在构造函数中接收这个数字
  const DetailPage({super.key, required this.passedNumber});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我是详情页'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('恭喜你，成功跳转到详情页了！', style: TextStyle(fontSize: 24)),
          SizedBox(
            height: 20,
          ),
          // 3.在界面上展示传递过来的数字
          Text('你传递的数字是：${widget.passedNumber}',
              style: TextStyle(fontSize: 32, color: Colors.lightBlue)),
          ElevatedButton(
              onPressed: () {
                // 🚨 核心代码 2：返回上一页 (Pop)
                // 告诉管家，把当前这个页面从栈顶拿走
                Navigator.pop(context);
              },
              child: Text('返回上一页'))
        ],
      )),
    );
  }
}
