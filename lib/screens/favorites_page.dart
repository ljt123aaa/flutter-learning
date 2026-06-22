import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/my_app_state.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // 新增：引入 slidable 插件

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet'),
      );
    }

    // 🌟 核心：用 RefreshIndicator 包裹可以滚动的列表
    return RefreshIndicator(
        onRefresh: () async {
          // 在实际开发中，这里通常是发起网络请求去获取最新数据
          // 这里我们用 Future.delayed 模拟一个耗时 1.5 秒的网络请求
          await Future.delayed(const Duration(microseconds: 1500));

          // 刷新完成后，给用户一个反馈
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('列表已刷新')));
        },
        child: ListView.builder(
          // 🌟 重点：为了让列表在不满一屏幕时也能被下拉，需要强制它总是可滚动
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: appState.favorites.length,
          itemBuilder: (context, index) {
            final pair = appState.favorites[index];
            // 🌟 核心：用 Dismissible 包裹你的列表项
            return Slidable(
                key: ValueKey(pair.asLowerCase),

                // endActionPane 代表从右向左滑（在列表项的尾部露出）
                endActionPane: ActionPane(
                    // motion 决定了滑动时的动画效果，ScrollMotion 是经典抽屉效果
                    motion: const ScrollMotion(),
                    // 比例：决定滑动菜单占整个宽度的多少 (0.25就是露出四分之一)
                    extentRatio: 0.25,
                    children: [
                      // 🌟 这是真正露出来的、可以点击的按钮
                      SlidableAction(
                        onPressed: (context) {
                          // 点击按钮时执行删除
                          appState.removeFavorite(pair);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('${pair.asLowerCase} 已被移除')));
                        },
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: '删除', // 你甚至可以给它加文字标签！
                      )
                    ]),
                child: ListTile(
                  leading: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  title: Text(pair.asLowerCase),
                ));
          },
        ));

    // return ListView.builder(
    //   itemCount: appState.favorites.length,
    //   itemBuilder: (context, index) {
    //     final pair = appState.favorites[index];
    //     // 🌟 核心：用 Dismissible 包裹你的列表项
    //     return Dismissible(
    //       // 1. 必须提供一个独一无二的 Key，Flutter 靠它来认识谁是谁
    //       key: ValueKey(pair.asLowerCase),

    //       // 2. 设置滑动方向：这里设置为只能从右向左滑动 (EndToStart)
    //       direction: DismissDirection.endToStart,

    //       // 3. 滑动时露出的背景：这里我们画一个红色的背景和一个居右的垃圾桶图标
    //       background: Container(
    //         color: Colors.redAccent,
    //         alignment: Alignment.centerRight,
    //         padding: EdgeInsets.only(right: 20),
    //         child: Icon(Icons.delete, color: Colors.white),
    //       ),

    //       // 4. 当用户滑到底松手后，触发的回调函数
    //       onDismissed: (direction) {
    //         // 调用状态管理里的方法，把这个单词删掉
    //         appState.removeFavorite(pair);

    //         // 顺便在底部弹个黑色的提示框 (SnackBar) 告诉用户删除了啥
    //         ScaffoldMessenger.of(context).showSnackBar(
    //             SnackBar(content: Text('${pair.asLowerCase} 已被移除')));
    //       },

    //       // 5. 这就是你原本就有的列表项 UI (注意：去掉了原来的 trailing 垃圾桶按钮)
    //       child: ListTile(
    //         leading: Icon(
    //           Icons.favorite,
    //           color: Colors.red,
    //         ),
    //         title: Text(pair.asLowerCase),
    //       ),
    //     );
    //   },
    // );

    // return ListView(children: [
    //   Padding(
    //     padding: const EdgeInsets.all(20),
    //     child: Text('You have ' '${appState.favorites.length} favorites:'),
    //   ),
    //   for (var pair in appState.favorites)
    //     ListTile(
    //         leading: Icon(Icons.favorite),
    //         title: Text(pair.asLowerCase),
    //         // 👇 这里是我们新加的代码：一个删除按钮
    //         trailing: IconButton(
    //           icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
    //           color: Theme.of(context).colorScheme.primary,
    //           onPressed: () {
    //             // appState.favorites.remove(pair);
    //             // appState.notifyListeners();

    //             // 改成调用刚写的新方法：
    //             appState.removeFavorite(pair);
    //           },
    //         ))
    // ]);
  }
}
