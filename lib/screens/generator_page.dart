import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/my_app_state.dart';
import '../widgets/big_card.dart';

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
