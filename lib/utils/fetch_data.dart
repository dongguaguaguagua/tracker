import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'data_structure.dart';
import '/utils/database.dart';

// 获取发现页面的电影数据
Future<List<SingleMovie>> fetchDiscoverData(int page) async {
  final response = await http.get(Uri.parse(
      'https://tmdb.melonhu.cn/get/discover/movie?page=$page&language=zh-CN'));

  if (response.statusCode == 200) {
    // 需要把response转换成utf-8格式，否则都是乱码
    String jsonStr = const Utf8Decoder().convert(response.bodyBytes);
    // 需要的是results里面的数据，其他都不要
    List<dynamic> jsonData = jsonDecode(jsonStr)['results'];
    // 将json转换成singleMovie列表
    List<SingleMovie> movies = jsonData
        .map<SingleMovie>((item) => SingleMovie.apiFromJson(item))
        .toList();

    return movies;
  } else {
    // 如果请求失败，则抛出异常
    throw Exception('Failed to load movie data');
  }
}

// 搜索电影
Future<List<SingleMovie>> SearchMovieData(String query) async {
  final response = await http.get(Uri.parse(
      'https://tmdb.melonhu.cn/get/search/movie?query=$query&include_adult=false&language=zh-CN&page=1'));

  if (response.statusCode == 200) {
    // 需要把response转换成utf-8格式，否则都是乱码
    String jsonStr = const Utf8Decoder().convert(response.bodyBytes);
    // 需要的是results里面的数据，其他都不要
    List<dynamic> jsonData = jsonDecode(jsonStr)['results'];
    // 将json转换成singleMovie列表
    List<SingleMovie> movies = jsonData
        .map<SingleMovie>((item) => SingleMovie.apiFromJson(item))
        .toList();
    return movies;
  } else {
    // 如果请求失败，则抛出异常
    throw Exception('Failed to load movie data');
  }
}

// 获取 movie detail
Future<void> Add_country_runtime_genre(SingleMovie movie) async {
  // 在基础List<SingleMovie>上加另一个api解析的属性，最终一起传入discoverpage.dart
  final id = movie.tmdbId;
  final response2 = await http
      .get(Uri.parse('https://tmdb.melonhu.cn/get/movie/$id?language=zh-CN'));
  String jsonStr = const Utf8Decoder().convert(response2.bodyBytes);
  int runtime = jsonDecode(jsonStr)['runtime'];
  // print(jsonDecode(jsonStr)['origin_country']);
  final originalCountry = jsonDecode(jsonStr)['origin_country'];

  movie.runtime = runtime;
  movie.originalCountry = originalCountry[0];

  await ProjectDatabase().SI_update(movie);
}

// 获取演员表
Future<List<Map<String, dynamic>>> fetchCreditsData(int movieid) async {
  final creditsResp = await http.get(Uri.parse(
      'https://tmdb.melonhu.cn/get/movie/$movieid/credits?language=zh-CN'));
  String jsonStr = const Utf8Decoder().convert(creditsResp.bodyBytes);
  final cast = jsonDecode(jsonStr)['cast'];
  //print(cast.runtimeType);
  return List<Map<String, dynamic>>.from(cast);
}

// 获取电影关键词
Future<List<Map<String, dynamic>>> fetchKeyWordsData(int movieid) async {
  final keywordsResp = await http.get(Uri.parse(
      'https://tmdb.melonhu.cn/get/movie/$movieid/keywords?language=zh-CN'));
  String jsonStr = const Utf8Decoder().convert(keywordsResp.bodyBytes);
  final keywords = jsonDecode(jsonStr)['keywords'];
  //print(keywords.runtimeType);
  return List<Map<String, dynamic>>.from(keywords);
}
