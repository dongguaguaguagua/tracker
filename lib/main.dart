import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tab_index.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'cache_data/cachedata.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    databaseFactory = databaseFactoryFfi;
  }
  await cache_data.getInstance().initMovieData();
  runApp(
    // ChangeNotifierProvider(
    // create: (context) => GlobalVar(),
    // child: const MyApp(),
    const MyApp(),
    // ),
  );
  //https://juejin.cn/post/7090900994023751688
  //安卓手机小白条沉浸
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // 原来是MaterialApp，现在用了GetX，变成了GetMaterialApp
    return GetMaterialApp(
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
