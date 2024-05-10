import 'package:flutter/material.dart';
import 'package:tracker/utils/data_structure.dart';
import 'package:tuple/tuple.dart';
import '../utils/database.dart';
import 'package:tracker/widgets/stats_MovieList.dart';
import 'package:tracker/widgets/movie_page.dart';
import 'package:get/get.dart';
//import 'package:tuple/tuple.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  //之后会有几个功能的分区，我先来负责一下
  //我先嫖了一个其中一个的功能模板，
  Widget build(BuildContext context) {
    //List<SingleMovie> movies = getmovies();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: GetHistory(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return const Icon(Icons.error, size: 80);
            }
            if (snapshot.hasData) {
              return Container(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 150),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.headlineSmall,
                          children: [
                            TextSpan(
                              text: '你的观影记录：',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Builder(
                        builder: (BuildContext context) {
                          String lastDate = '';
                          List<Widget> listItems = [];
                          for (final movie in snapshot.data) {
                            String currentMonthYear;
                            String status;
                            if (movie.item2.watchedDate == null) {
                              currentMonthYear =
                                  '${movie.item2.wantToWatchDate.year}-${movie.item2.wantToWatchDate.month}';
                              status = '想看';
                            } else {
                              currentMonthYear =
                                  '${movie.item2.watchedDate.year}-${movie.item2.watchedDate.month}';
                              status = '看过';
                            }

                            if (currentMonthYear != lastDate) {
                              // 如果当前电影的年月与上一个不同
                              lastDate = currentMonthYear;
                              // 添加年月标注，无左边距
                              listItems.add(
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10),
                                  child: Text(
                                    currentMonthYear,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(color: Colors.black),
                                  ),
                                ),
                              );
                            }
                            listItems.add(
                              Padding(
                                padding: const EdgeInsets.only(left: 60),
                                child: Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            right: 8), // 右边距增加一些空间
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center, // 左对齐文本
                                          children: [
                                            Text(
                                              status,
                                              style: const TextStyle(
                                                fontSize: 20, // 调整字体大小
                                                fontWeight:
                                                    FontWeight.bold, // 字体加粗
                                                color: Colors.black, // 设置字体颜色
                                              ),
                                              //textAlign: ,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          Get.to(MoviePage(movie: movie.item1),
                                              transition: Transition.fadeIn);
                                        },
                                        child: MovieListItem(
                                          imageUrl:
                                              "https://image.tmdb.org/t/p/w500/${movie.item1.posterPath}",
                                          name: movie.item1.title,
                                          information:
                                              '${movie.item1.runtime}分钟 | ${movie.item1.voteAverage}',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                          return Column(children: listItems);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

Future<List<Tuple2<SingleMovie, MyMedia>>> GetHistory() async {
  final tuple = ProjectDatabase().gethistory();

  return tuple;
}
