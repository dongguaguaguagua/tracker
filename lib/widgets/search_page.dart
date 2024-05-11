import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/data_structure.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'movie_page.dart';
import 'package:tracker/page/discover_page.dart';
import 'package:tracker/utils/database.dart';
import '../utils/fetch_data.dart';

class SearchBarView extends StatefulWidget {
  const SearchBarView({super.key});

  @override
  _SearchBarViewState createState() => _SearchBarViewState();
}

class _SearchBarViewState extends State<SearchBarView> {
  final TextEditingController _controller = TextEditingController();
  List<SingleMovie> _searchResults = [];
  List<SingleMovie> _searchHistory = [];

  void initState() {
    super.initState();
    initSearchHistory();
  }

  Future<void> initSearchHistory() async {
    String query = """
SELECT infoTable.tmdbId, adult, backdropPath, originalLanguage,
       originalTitle, overview, popularity, posterPath, releaseDate, title, voteAverage,
       voteCount, runtime, originalCountry 
FROM myTable 
JOIN infoTable ON myTable.id = infoTable.id 
WHERE searchDate != ''
ORDER BY searchDate DESC;
       """;
    List<dynamic> res = await ProjectDatabase().sudoQuery(query);
    setState(() {
      // 清空搜索历史
      _searchHistory.clear();
      // 遍历结果列表，并将每个元素转换为 SingleMovie 对象
      for (var item in res) {
        // 将动态对象转换为 Map<String, dynamic>
        Map<String, dynamic> json = Map<String, dynamic>.from(item);
        // 创建 SingleMovie 对象并添加到搜索历史中
        _searchHistory.add(SingleMovie.fromJson(json));
      }
    });
  }

  void _search() async {
    String query = _controller.text;
    final response = await http.get(Uri.parse(
        'https://tmdb.melonhu.cn/get/search/movie?query=$query&include_adult=false&language=zh-CN&page=1'));

    if (response.statusCode == 200) {
      // 需要把response转换成utf-8格式，否则都是乱码
      String jsonStr = const Utf8Decoder().convert(response.bodyBytes);
      // 需要的是results里面的数据，其他都不要
      List<dynamic> jsonData = jsonDecode(jsonStr)['results'];
      setState(() {
        // 将json转换成singleMovie列表
        _searchResults = jsonData
            .map<SingleMovie>((item) => SingleMovie.apiFromJson(item))
            .toList();
      });
    } else {
      // 如果请求失败，则抛出异常
      throw Exception('Failed to load movie data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              SearchBar(
                controller: _controller,
                hintText: 'Enter your search query',
                onChanged: (value) {
                  _search();
                },
                autoFocus: true,
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              _controller.text == '' ? searchHistoryList() : searchResultList(),
            ],
          )),
    );
  }

  // 搜索历史
  Widget searchHistoryList() {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Wrap(
          spacing: 8.0, // 设置Chip之间的水平间距
          runSpacing: 4.0, // 设置Chip之间的垂直间距
          children: _searchHistory.map((history) {
            return historyCard(history);
          }).toList(),
        ));
  }

  Widget historyCard(SingleMovie movie) {
    return ActionChip(
      label: Text('${movie.title}'),
      onPressed: () {
        Get.to(MoviePage(movie: movie), transition: Transition.fadeIn);
      },
    );
  }

  Widget searchResultList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          return MovieListCard(movie: _searchResults[index]);
        },
      ),
    );
  }
}

class MovieListCard extends StatelessWidget {
  SingleMovie movie;
  MovieListCard({super.key, required this.movie});

  Future<void> addSearchDate(SingleMovie movie) async {
    DateTime date = DateTime.now();
    String query =
        "update myTable set searchDate='${date.toString()}' where tmdbId=${movie.tmdbId}";
    ProjectDatabase().sudoQuery(query);
  }

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
    await addSearchDate(movie);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        createTables(movie); //创建改电影的所有表，到本地media.db,有些列初始为空，待update
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
