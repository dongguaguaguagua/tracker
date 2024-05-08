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
        //title: Text(movie.title!),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    //borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: "https://image.tmdb.org/t/p/w500/${movie.posterPath}",
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          CircularProgressIndicator(value: downloadProgress.progress),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      width: 150,
                      height: 200,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //const SizedBox(height: 10,),
                          Text(
                            movie.title!,
                            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              'TMDB评分：${movie.voteAverage} (${movie.voteCount})',
                              style: const TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text(
                              movie.overview!,
                              style: const TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.only(top:25.0),
              child: ElevatedButton(
                onPressed: addWatchedMedia,
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.deepPurple, // 按钮颜色
                  minimumSize: Size(double.infinity, 50), // 按钮大小
                ),
                child: const Text('看过'),
              ),
            ),
          ],
        ),
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
