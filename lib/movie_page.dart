import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'fetch_data.dart';
import 'dart:convert';
import 'data_structure.dart';
import 'search_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MoviePage extends StatelessWidget {
  SingleMovie movie;
  MoviePage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 电影图片
                CachedNetworkImage(
                  imageUrl:
                      "https://image.tmdb.org/t/p/w500/${movie.posterPath}",
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: 100,
                  height: 100,
                ),
                Text(
                  movie.title,
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'TMDB评分：${movie.voteAverage} (${movie.voteCount})',
                  style: TextStyle(fontSize: 10),
                ),
                Text(
                  movie.overview,
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
