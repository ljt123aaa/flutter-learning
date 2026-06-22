import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/my_app_state.dart';

import '../screens/generator_page.dart';
import '../screens/favorites_page.dart';
import '../screens/layout_practice_page.dart';
import '../screens/state_practice_page.dart';
import '../screens/network_practice_page.dart';
import '../screens/camera_practice_page.dart';


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
      case 4:
        page = NetworkPracticePage(); //显示网络练习页面
        break;
      case 5:
        page = CameraPracticePage(); //显示相机练习页面
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      // 在右下角放一个悬浮按钮
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: selectedIndex == 3 ? 70.0 : 0.0),
        child: FloatingActionButton(
          heroTag: 'theme_switcher_fab',
          onPressed: () {
            context.read<MyAppState>().toggleTheme();
          },
          // child: Icon(context.watch<MyAppState>().isDarkMode
          //     ? Icons.light_mode
          //     : Icons.dark_mode),
          // 👇 重点改造：用 Consumer 包裹需要局部刷新的部分
          child: Consumer<MyAppState>(
            builder: (context, appstate, child) {
              // 只有当 MyAppState 变化时，仅仅这一个小小的 Icon 会重新构建
              return Icon(
                  appstate.isDarkMode ? Icons.light_mode : Icons.dark_mode);
            },
          ),
        ),
      ),
      body: Container(
          color: Theme.of(context).colorScheme.primaryContainer, child: page),
      // 新增配置底部导航栏
      bottomNavigationBar: BottomNavigationBar(
        // 当按钮超过3个时，必须设置 type 为 fixed，否则显示会很奇怪
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Layout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.touch_app),
            label: 'State',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wifi),
            label: 'Network',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
