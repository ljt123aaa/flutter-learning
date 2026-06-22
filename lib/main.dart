import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/my_app_state.dart';
import 'screens/home_page.dart';

void main() {
  // 确保 Flutter 绑定初始化
  WidgetsFlutterBinding.ensureInitialized();
  
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