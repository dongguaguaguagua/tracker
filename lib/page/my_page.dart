//import 'dart:convert';
//import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tracker/utils/data_structure.dart';
import 'package:tracker/utils/database.dart';
import '../utils/fetch_data.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tracker/widgets/movie_page.dart';
import 'package:tracker/page/discover_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('这里是你的观影历史档案！'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.list_alt_outlined),
                text: '准备看',
              ),
              Tab(
                icon: Icon(Icons.collections_bookmark),
                text: '合集',
              ),
              Tab(
                icon: Icon(Icons.place_sharp),
                text: '地区',
              ),
              Tab(
                icon: Icon(Icons.star),
                text: '你的评分',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: Text("It's 待观看的电影 here"),
            ),
            NestedBar_collection('合集'),
            const NestedBar_area('地区'),
            Center(
              child: Text("It's 自己的评分 here"),
            ),
          ],
        ),
      ),
    );
  }
}

class NestedBar_area extends StatefulWidget {
  const NestedBar_area(this.outerTab, {super.key});

  final String outerTab;

  @override
  State<NestedBar_area> createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedBar_area>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar.secondary(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: '美国'),
            Tab(text: '欧洲'),
            Tab(text: '中国大陆'),
            Tab(text: '港澳台'),
            Tab(text: '日韩'),
            Tab(text: '其他'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Card(
                margin: const EdgeInsets.all(16.0),
                child: Center(child: Text('${widget.outerTab}: Overview tab')),
              ),
              Card(
                margin: const EdgeInsets.all(16.0),
                child: Center(child: Text('${widget.outerTab}: Overview tab')),
              ),
              Card(
                margin: const EdgeInsets.all(16.0),
                child: Center(child: Text('${widget.outerTab}: Overview tab')),
              ),
              Card(
                margin: const EdgeInsets.all(16.0),
                child: Center(child: Text('${widget.outerTab}: Overview tab')),
              ),
              Card(
                margin: const EdgeInsets.all(16.0),
                child: Center(child: Text('${widget.outerTab}: Overview tab')),
              ),
              Card(
                margin: const EdgeInsets.all(16.0),
                child: Center(child: Text('${widget.outerTab}: Overview tab')),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class NestedBar_collection extends StatefulWidget {
  NestedBar_collection(this.outerTab, {super.key});

  final String outerTab;

  @override
  State<NestedBar_collection> createState() => _NestedTabBarState1();
}

class _NestedTabBarState1 extends State<NestedBar_collection>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int length = 1; //外部传入
  List<Map<dynamic, dynamic>> collectionname = [];
  List<Map<dynamic, List<SingleMovie>>> moviedata = [];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: length, vsync: this);
    getcollectiondata();
  }

  Future<void> getcollectiondata() async {
    String query = "select id from myCollectionTable";
    String query2 = "select collectionName from myCollectionTable";

    List<Map<dynamic, dynamic>> idlist =
        await ProjectDatabase().sudoQuery(query);
    List<Map<dynamic, dynamic>> colname =
        await ProjectDatabase().sudoQuery(query2);

    //将不同的合集list<singlemovie>加入
    for (var tmp in idlist) {
      final id = tmp.values.first;
      final moviedat = await ProjectDatabase().getcollectdata(id);
      moviedata.add({id: moviedat});
    }

    setState(() {
      length = idlist.length;
      collectionname = colname;
      //print(data[0].values.first);
      _tabController.dispose();
      _tabController = TabController(length: length, vsync: this);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (collectionname.isEmpty) {
      return const Center(child: Text('你还没有合集哦(＾-＾)v'));
      //CircularProgressIndicator()); // Show loading indicator while data is empty
    }
    return Column(
      children: <Widget>[
        TabBar(
          controller: _tabController,
          tabs: List<Widget>.generate(length, (index) {
            return Tab(text: '${collectionname[index].values.first}');
          }),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List<Widget>.generate(length, (index) {
              return ListView.builder(
                itemCount: moviedata[index].values.first.length,
                itemBuilder: (context, ind) {
                  return MovieListCard(
                      movie: moviedata[index].values.first[ind]);
                  // return MovieListCard(movie: _searchResults[index]);
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}

class MovieListCard extends StatelessWidget {
  SingleMovie movie;
  MovieListCard({super.key, required this.movie});
  @override
  Widget build(BuildContext context) {
    Future<void> createTables(SingleMovie movie) async {
      final media = MyMedia(
        tmdbId: movie.tmdbId,
        mediaType: "movie",
        watchStatus: "unwatched",
        watchTimes: 0,
        myRating: 0.0,
        myReview: '',
      );
      await ProjectDatabase().SI_add(movie);
      await ProjectDatabase().MM_add(media);
      await Add_country_runtime_genre(movie);
    }

    return GestureDetector(
      onTap: () async {
        createTables(movie);
        Get.to(MoviePage(movie: movie), transition: Transition.fadeIn);
      },
      child: Card(
        elevation: 3,
        child: ListTile(
          leading: Container(
            child: CachedNetworkImage(
              imageUrl: "https://image.tmdb.org/t/p/w500/${movie.posterPath}",
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          title: Text(
            movie.title!,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '上映日期: ${movie.releaseDate}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'TMDB评分: ${movie.voteAverage} (${movie.voteCount})',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
