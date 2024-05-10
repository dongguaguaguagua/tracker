import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker/utils/database.dart';
import 'package:tracker/utils/data_structure.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
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
    const String query =
        "select count(*) from myTable where watchStatus=\"watched\"";
    dynamic count = await ProjectDatabase().sudoQuery(query);
    setState(() => isLoading = false);

    setState(() {
      watchedMovieCount = count[0]["count(*)"];
    });
  }

  Future getWantWatchMovieCount() async {
    setState(() => isLoading = true);
    const String query =
        "select count(*) from myTable where watchStatus=\"wanttowatch\"";
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
        heatMapData[watchedDate] = (heatMapData[watchedDate] ?? 0) + 1;
      }

      // 如果wantToWatchDate不为空，提取日期并加入heatMapData
      if (wantToWatchDateString != null) {
        DateTime wantToWatchDate =
            DateTime.parse(wantToWatchDateString.split('T')[0]);
        heatMapData[wantToWatchDate] = (heatMapData[wantToWatchDate] ?? 0) + 1;
      }
    });
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            mediaHeatMap(),
            StatNumberCard("我总共看过", watchedMovieCount, "部电影"),
            StatNumberCard("我想观看", wantWatchMovieCount, "部电影"),
            StatNumberCard("我发布了", myRatingCount, "个评分"),
            StatNumberCard("我总共看了", watchedMovieTime, "分钟的电影"),
          ],
        ),
      ),
    );
  }

  Widget mediaHeatMap() {
    return HeatMap(
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
    );
  }

  Widget StatNumberCard(String title, int num, String otherWord) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontSize: 20)),
          Text(num.toString(),
              style: TextStyle(fontSize: 25, color: Colors.purple)),
          Text(otherWord, style: TextStyle(fontSize: 20)),
        ]),
      ),
    );
  }
}

// Center(
//         child: isLoading
//             ? const CircularProgressIndicator()
//             : medias.isEmpty
//                 ? const Text(
//                     'No Medias',
//                     style: TextStyle(color: Colors.black, fontSize: 24),
//                   )
//                 : ListView.builder(
//                     itemCount: medias.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text("tmdb ID:${medias[index].tmdbId}"),
//                         subtitle: Text(medias[index].watchedDate.toString()),
//                       );
//                     },
//                   ),
//       ),

//extract a widget
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
