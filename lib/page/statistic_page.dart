import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tracker/utils/database.dart';
import 'package:tracker/utils/data_structure.dart';

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
  List<int> mediaCalendar = [];


  @override
  void initState() {
    super.initState();
    refreshMedias();
    getWatchedMovieCount();
    getWantWatchMovieCount();
    getRatingCount();
    getWatchedMovieTime();
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
    const String query = "select count(*) from myTable where watchStatus=\"watched\"";
    dynamic count = await ProjectDatabase().sudoQuery(query);
    setState(() => isLoading = false);

    setState(() {
      watchedMovieCount = count[0]["count(*)"];
    });
  }

  Future getWantWatchMovieCount() async {
    setState(() => isLoading = true);
    const String query = "select count(*) from myTable where watchStatus=\"wanttowatch\"";
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
      watchedMovieTime = count.map((e) => e['runtime'] as int).reduce((value, element) => value + element);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatNumberCard("我总共看过",watchedMovieCount,"部电影"),
            StatNumberCard("我想观看",wantWatchMovieCount,"部电影"),
            StatNumberCard("我发布了",myRatingCount,"个评分"),
            StatNumberCard("我总共看了",watchedMovieTime,"分钟的电影"),
          ],
        ),
      ),
    );
  }

  Widget StatNumberCard(String title,int num,String otherWord) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 20)),
              Text(num.toString(), style: TextStyle(fontSize: 25,color: Colors.purple)),
              Text(otherWord, style: TextStyle(fontSize: 20)),
            ]
        ),
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
