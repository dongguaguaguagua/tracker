import 'package:flutter/material.dart';
import 'package:tracker/statistic_page.dart';
import 'home_page.dart';
import 'settings_page.dart';
import 'discover_page.dart';
import 'my_page.dart';
import 'package:provider/provider.dart';

// 底栏tab的定义页面
class IndexPage extends StatefulWidget {
  const IndexPage({super.key});
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final List<BottomNavigationBarItem> bottomTabs = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: '首页',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: '发现',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.bar_chart),
      label: '统计',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: '设置',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: '我的',
    )
  ];
  // 页面列表，注意要按照上面的顺序排
  final List tabBodies = [
    const HomePage(),
    const DiscoverPage(),
    const StatisticPage(),
    const SettingsPage(),
    const MyPage(),
  ];

  int currentIndex = 0;
  var currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = tabBodies[currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 245, 245, 1),
      bottomNavigationBar: BottomNavigationBar(
        // 设置未选中的标签不显示
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: bottomTabs,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            currentPage = tabBodies[currentIndex];
          });
        },
      ),
      body: currentPage,
    );
  }
}
