//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker/utils/database.dart';
import 'package:tracker/utils/data_structure.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class CountAnimation extends StatefulWidget {
  final int startValue;
  final int endValue;

  const CountAnimation({
    super.key,
    required this.startValue,
    required this.endValue,
  });

  @override
  _CountAnimationState createState() => _CountAnimationState();
}

class _CountAnimationState extends State<CountAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = IntTween(
      begin: widget.startValue,
      end: widget.endValue,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          '${_animation.value}',
          style: const TextStyle(
            fontSize: 30.0,
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}

class _StatisticPageState extends State<StatisticPage> {
  late List<MyMedia> medias;
  bool isLoading = false;
  int watchedMovieCount = 0;
  int wantWatchMovieCount = 0;
  int myRatingCount = 0;
  int watchedMovieTime = 0;
  Map<DateTime, int> heatMapData = {};

  @override
  void initState() {
    super.initState();
    refreshMedias();
    getWatchedMovieCount();
    getWantWatchMovieCount();
    getRatingCount();
    getWatchedMovieTime();
    getHeatMapData();
  }

  @override
  void dispose() {
    // MediaDatabase.instance.close();
    super.dispose();
  }

  Future refreshMedias() async {
    setState(() => isLoading = true);
    medias = await ProjectDatabase().MM_read_all();
    setState(() => isLoading = false);

    setState(() {
      isLoading = false;
    });
  }

  Future getWatchedMovieCount() async {
    setState(() => isLoading = true);
    const String query = "select count(*) from myTable where watchedDate != ''";
    dynamic count = await ProjectDatabase().sudoQuery(query);
    setState(() => isLoading = false);

    setState(() {
      watchedMovieCount = count[0]["count(*)"];
    });
  }

  Future getWantWatchMovieCount() async {
    setState(() => isLoading = true);
    const String query =
        "select count(*) from myTable where wantToWatchDate != ''";
    dynamic count = await ProjectDatabase().sudoQuery(query);
    setState(() => isLoading = false);

    setState(() {
      wantWatchMovieCount = count[0]["count(*)"];
    });
  }

  Future getRatingCount() async {
    setState(() => isLoading = true);
    const String query = "select count(*) from myTable where myRating != 0";
    dynamic count = await ProjectDatabase().sudoQuery(query);
    setState(() => isLoading = false);

    setState(() {
      myRatingCount = count[0]["count(*)"];
    });
  }

  Future getWatchedMovieTime() async {
    setState(() => isLoading = true);
    const String query = """
SELECT runtime
FROM infoTable
JOIN myTable ON infoTable.tmdbId = myTable.tmdbId
WHERE watchStatus = 'watched';
""";
    List<dynamic> count = await ProjectDatabase().sudoQuery(query);
    setState(() => isLoading = false);
    setState(() {
      watchedMovieTime = count
          .map((e) => e['runtime'] as int)
          .reduce((value, element) => value + element);
    });
  }

  Future getHeatMapData() async {
    setState(() => isLoading = true);
    const String query =
        "select watchedDate,wantToWatchDate,myRating from myTable";
    List<dynamic> data = await ProjectDatabase().sudoQuery(query);
    data.forEach((item) {
      // 提取日期字符串
      String? watchedDateString = item['watchedDate'];
      String? wantToWatchDateString = item['wantToWatchDate'];

      // 如果watchedDate不为空，提取日期并加入heatMapData
      if (watchedDateString != null) {
        DateTime watchedDate = DateTime.parse(watchedDateString.split('T')[0]);
        DateTime date=dateTimeBuilder(watchedDate);
        heatMapData[date] = (heatMapData[date] ?? 0) + 1;
      }

      // 如果wantToWatchDate不为空，提取日期并加入heatMapData
      if (wantToWatchDateString != null) {
        DateTime wantToWatchDate =
            DateTime.parse(wantToWatchDateString.split('T')[0]);
        DateTime date=dateTimeBuilder(wantToWatchDate);
        heatMapData[date] = (heatMapData[date] ?? 0) + 1;
      }
    });
    setState(() => isLoading = false);
  }

  DateTime dateTimeBuilder(DateTime date){
    String month=date.month < 10 ? '0${date.month}' : '${date.month}';
    String day=date.day < 10 ? '0${date.day}' : '${date.day}';
    date = DateTime.parse('${date.year}-$month-$day');
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 选择一个主题颜色
        elevation: 0, // 阴影强度
        title: const Text(
          "我的观影统计", // 标题文本
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20), // 增加与顶部的距离
            mediaHeatMap(),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.2, // 更改卡片的高宽比以更好的适应内容
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  statNumberCard("我总共看过", watchedMovieCount, "部电影"),
                  statNumberCard("我想观看", wantWatchMovieCount, "部电影"),
                  statNumberCard("我发布了", myRatingCount, "个评分"),
                  statNumberCard("我总共看了", watchedMovieTime, "分钟的电影"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mediaHeatMap() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: HeatMap(
          datasets: heatMapData,
          colorMode: ColorMode.opacity,
          showText: false,
          scrollable: true,
          colorsets: const {
            1: Colors.red,
            3: Colors.orange,
            5: Colors.yellow,
            7: Colors.green,
            9: Colors.blue,
            11: Colors.indigo,
            13: Colors.purple,
          },
          onClick: (value) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(value.toString())));
          },
        ),
      ),
    );
  }

  Widget statNumberCard(String title, int number, String otherWord) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 195, 147, 203),
              Colors.purple[100]!
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 调整文字间的间距
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // number会变化。初始值为0
            number == 0
                ? Text(
                    number.toString(),
                    style: const TextStyle(
                      fontSize: 30.0,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : CountAnimation(
                    startValue: 1,
                    endValue: number,
                  ),
            Text(
              otherWord,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Center(
//   child: isLoading
//     ? const CircularProgressIndicator()
//     : medias.isEmpty
//       ? const Text(
//           'No Medias',
//           style: TextStyle(color: Colors.black, fontSize: 24),
//         )
//       : ListView.builder(
//         itemCount: medias.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text("tmdb ID:${medias[index].tmdbId}"),
//             subtitle: Text(medias[index].watchedDate.toString()),
//           );
//         },
//       ),
// ),

// // extract a widget
// class BigCard extends StatelessWidget {
//   const BigCard({
//     super.key,
//     required this.pair,
//   });

//   final WordPair pair;

//   @override
//   Widget build(BuildContext context) {
//     return Text(pair.asLowerCase);
//   }
// }
