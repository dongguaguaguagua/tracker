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

  @override
  void initState() {
    super.initState();
    refreshMedias();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text(watchedMovieCount.toString()));
  }

  // Future<void> countWatchedMovie() async {
  //   setState(() {
  //   watchedMovieCount = medias.length;
  //   }
  // }
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


