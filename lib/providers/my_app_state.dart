import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_helper.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[]; //新增，存放点赞的单词
// 记录当前是否是深色模式，默认是false(浅色)
  var isDarkMode = false;

  // 新增：构造函数，在 MyAppState 被创建时立刻去读取本地数据
  MyAppState() {
    _loadFromPrefs();
  }

  // 新增：从本地读取数据的方法
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    // 1. 读取主题设置（如果没有存过，默认是 false）
    isDarkMode = prefs.getBool('isDarkMode') ?? false;

    // // 2. 读取收藏的单词列表（SharedPreferences 只能存字符串列表）
    // final savedFavorites = prefs.getStringList('favorites') ?? [];

    // // 把字符串列表转换回 WordPair 对象列表
    // favorites = savedFavorites.map((str) {
    //   // 简单处理：因为我们存的时候用 '_' 连起来了，现在拆开
    //   final parts = str.split('_');
    //   return WordPair(parts[0], parts[1]);
    // }).toList();

    // 2. 从 SQLite 数据库读取收藏的单词列表（替换原来的字符串拆分逻辑）
    favorites = await DatabaseHelper.instance.getAllFavorites();

    // 数据读完了，通知全页面刷新！
    notifyListeners();
  }

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  // 新增：切换点赞状态
  void toggleFavorite() async {
    if (favorites.contains(current)) {
      favorites.remove(current); //如果已经点赞过，取消点赞
      await DatabaseHelper.instance.removeFavorite(current); // 🌟 从数据库删除
    } else {
      favorites.add(current); //如果没有点赞过，点赞
      await DatabaseHelper.instance.addFavorite(current); // 🌟 加入数据库
    }
    notifyListeners(); // 刷新点赞状态

    // 把 WordPair 列表变成字符串列表，保存到本地
    // final prefs = await SharedPreferences.getInstance();
    // final stringList = favorites.map((pair) => '${pair.first}_${pair.second}').toList();
    // await prefs.setStringList('favorites', stringList);
  }

  // 新增：移除指定的收藏单词
  void removeFavorite(WordPair pair) async {
    favorites.remove(pair);
    notifyListeners();
    // 从数据库中彻底删除
    await DatabaseHelper.instance.removeFavorite(pair);
  }

  void toggleTheme() async {
    isDarkMode = !isDarkMode;
    notifyListeners();

    // 保存到本地
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }
}
