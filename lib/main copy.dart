import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MyAppState(),
        // child: MaterialApp(
        //   title: 'Namer App',
        //   theme: ThemeData(
        //     useMaterial3: true,
        //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        //   ),
        //   home: MyHomePage(),
        // ),
        child: Builder(builder: (context) {
          var appState = context.watch<MyAppState>(); //监听状态
          return MaterialApp(
            title: 'Namer App',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            ),
            // 新增：深色主题
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.deepOrange,
                  brightness: Brightness.dark), //核心：告诉Flutter这是深色配置
            ),
            // 根据状态来判断使用哪个主题模式
            themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: MyHomePage(),
          );
        }));
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[]; //新增，存放点赞的单词
// 记录当前是否是深色模式，默认是false(浅色)
  var isDarkMode = false;

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  // 新增：切换点赞状态
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current); //如果已经点赞过，取消点赞
    } else {
      favorites.add(current); //如果没有点赞过，点赞
    }
    notifyListeners();
    // 刷新点赞状态
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; //这个变量用来记录当前选中的是哪个页面

  @override
  Widget build(BuildContext context) {
    Widget page;
    // 根据selectedIndex来判断显示哪个页面
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage(); //显示生成页面
        break;
      case 1:
        page = FavoritesPage(); //显示收藏页面
        break;
      case 2:
        page = LayoutPracticePage(); //显示布局练习页面
        break;
      case 3:
        page = StatePracticePage(); //显示状态练习页面
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        // 在右下角放一个悬浮按钮
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70.0),
          child: FloatingActionButton(
            onPressed: () {
              context.read<MyAppState>().toggleTheme();
            },
            child: Icon(context.watch<MyAppState>().isDarkMode
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
        ),
        body: Row(children: [
          // 左侧导航栏
          SafeArea(
              child: NavigationRail(
            extended: constraints.maxWidth >= 600, //屏幕宽的时候展开
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.favorite),
                label: Text('Favorites'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.build),
                label: Text('Layout Practice'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.touch_app),
                label: Text('State'),
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          )),

          // 右边的主体内容区域
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page, // 显示选中的页面
            ),
          ),
        ]),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    // 判断当前单词是否在收藏列表中
    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite; //如果点赞过，显示点赞图标
    } else {
      icon = Icons.favorite_border; //如果没有点赞过，显示点赞图标
    }

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('A random AWESOME idea:'),
        SizedBox(height: 10),
        // Text(appState.current.asLowerCase),
        // Text(pair.asLowerCase),
        BigCard(pair: pair),
        // ElevatedButton(
        //   onPressed: () {
        //     // print('button pressed!');
        //     appState.getNext();
        //   },
        //   child: Text('Next'),
        // ),
        SizedBox(height: 10),
        Row(
            mainAxisSize: MainAxisSize.min, //让按钮在中间紧凑排列
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // print('button pressed!');
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ])
      ],
    ));
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pair.asLowerCase),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet'),
      );
    }

    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(20),
        child: Text('You have ' '${appState.favorites.length} favorites:'),
      ),
      for (var pair in appState.favorites)
        ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
            // 👇 这里是我们新加的代码：一个删除按钮
            trailing: IconButton(
              icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                appState.favorites.remove(pair);
                appState.notifyListeners();
              },
            ))
    ]);
  }
}

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

// 这是一个有状态的Widget
class StatePracticePage extends StatefulWidget {
  @override
  State<StatePracticePage> createState() => _StatePracticePageState();
}

// 这是专门用来管理上面那个 Widget 状态的类 (注意类名前面有个下划线，代表它是私有的)
class _StatePracticePageState extends State<StatePracticePage> {
  // A.顶一个内部状态变量（用来存放数字）
  int _counter = 0;

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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DetailPage()));
                },
                child: Text('跳到详情页 🚀'),
              ),
            ],
          ),
        ),
        // D. 放一个右下角的悬浮按钮来触发 _incrementCounter 方法
        floatingActionButton: FloatingActionButton(
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

class DetailPage extends StatefulWidget {
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
