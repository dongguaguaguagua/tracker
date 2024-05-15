import '../utils/fetch_data.dart';
import '../utils/data_structure.dart';
import '/utils/database.dart';


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