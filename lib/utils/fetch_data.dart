import 'dart:convert';
import 'package:http/http.dart' as http;
import 'data_structure.dart';

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
        .map<SingleMovie>((item) => SingleMovie.fromJson(item))
        .toList();
    return movies;
  } else {
    // 如果请求失败，则抛出异常
    throw Exception('Failed to load movie data');
  }
}

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
        .map<SingleMovie>((item) => SingleMovie.fromJson(item))
        .toList();
    return movies;
  } else {
    // 如果请求失败，则抛出异常
    throw Exception('Failed to load movie data');
  }
}
