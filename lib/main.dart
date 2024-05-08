import 'package:flutter/material.dart';
import 'tab_index.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'cache_data/cachedata.dart';


void main() async{
  databaseFactory = databaseFactoryFfi;
  await cache_data.getInstance().initMovieData();
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
