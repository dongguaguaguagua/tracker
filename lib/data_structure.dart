// 单个电影的数据结构
class SingleMovie {
  bool adult;
  String backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  String releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  SingleMovie({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });
  // 为了从json里面快速生成数据
  factory SingleMovie.fromJson(Map<String, dynamic> json) {
    return SingleMovie(
      adult: json['adult'],
      backdropPath: json['backdrop_path'].toString(),
      genreIds: List<int>.from(json['genre_ids']),
      id: json['id'],
      originalLanguage: json['original_language'].toString(),
      originalTitle: json['original_title'].toString(),
      overview: json['overview'].toString(),
      popularity: json['popularity'].toDouble(),
      posterPath: json['poster_path'].toString(),
      releaseDate: json['release_date'].toString(),
      title: json['title'].toString(),
      video: json['video'],
      voteAverage: json['vote_average'].toDouble(),
      voteCount: json['vote_count'],
    );
  }
}