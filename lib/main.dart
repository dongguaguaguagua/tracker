import 'package:flutter/material.dart';
import 'tab_index.dart';
import 'package:provider/provider.dart';
import 'global_var.dart';

void main() {
  runApp(
    // ChangeNotifierProvider(
      // create: (context) => GlobalVar(),
      // child: const MyApp(),
    const MyApp(),
    // ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // 全局颜色定义
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 定义indexPage为主页面
      home: const IndexPage(),
    );
  }
}



