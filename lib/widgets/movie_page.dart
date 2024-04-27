import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker/utils/database.dart';
import '../utils/data_structure.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MoviePage extends StatelessWidget {
  SingleMovie movie;
  MoviePage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title!),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                ElevatedButton(
                  onPressed: addWatchedMedia,
                  child: const Text('Watched'),
                ),
                // 电影图片
                CachedNetworkImage(
                  imageUrl:
                      "https://image.tmdb.org/t/p/w500/${movie.posterPath}",
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: 100,
                  height: 100,
                ),
                Text(
                  movie.title!,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'TMDB评分：${movie.voteAverage} (${movie.voteCount})',
                  style: const TextStyle(fontSize: 10),
                ),
                Text(
                  movie.overview!,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addWatchedMedia() async {
    final media = MyMedia(
      tmdbId: movie.tmdbId,
      mediaType: "movie",
      wantToWatchDate: null,
      watchedDate: DateTime.now(),
      browseDate: DateTime.now(),
      searchDate: null,
      watchStatus: "watched",
      watchTimes: 1,
      isOnShortVideo: false,
      myRating: 5,
      myReview: "myReview");
    final data = SingleMovie(
      tmdbId: movie.tmdbId,
      adult: movie.adult,
      backdropPath: movie.backdropPath,
      originalLanguage: movie.originalLanguage,
      originalTitle: movie.originalTitle,
      overview: movie.overview,
      popularity: movie.popularity,
      posterPath: movie.posterPath,
      releaseDate: movie.releaseDate,
      title: movie.title,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount);

    await ProjectDatabase().MM_add(media);
    await ProjectDatabase().createLocal(data);
  }
}
