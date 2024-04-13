import 'package:flutter/material.dart';
import '../utils/data_structure.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'movie_page.dart';

class SearchBarView extends StatefulWidget {
  const SearchBarView({super.key});

  @override
  _SearchBarViewState createState() => _SearchBarViewState();
}

class _SearchBarViewState extends State<SearchBarView> {
  final TextEditingController _controller = TextEditingController();
  List<SingleMovie> _searchResults = [];

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
            .map<SingleMovie>((item) => SingleMovie.fromJson(item))
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
      body: Column(
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
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return MovieListCard(movie: _searchResults[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MovieListCard extends StatelessWidget {
  SingleMovie movie;
  MovieListCard({super.key, required this.movie});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
            movie.title,
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
