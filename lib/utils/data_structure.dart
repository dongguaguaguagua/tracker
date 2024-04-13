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
//
// class MyMedia {
//   String id=const Uuid().v4();
//   int tmDbId;
//   String mediaType;   // 分为电影，电视剧和书
//   DateTime wantToWatchDate;
//   DateTime watchedDate;
//   DateTime browseDate;
//   DateTime searchDate;
//   String watchStatus; // 分为想看，看过和在看
//   int watchTimes; // 刷的次数
//   bool isOnShortVideo;  // 是否在短视频上看的
//   int myRating;
//   String myReview;
//
//   MyMedia({
//     required this.tmDbId,
//     required this.mediaType,
//     required this.wantToWatchDate,
//     required this.watchedDate,
//     required this.browseDate,
//     required this.searchDate,
//     required this.watchStatus,
//     required this.watchTimes,
//     required this.isOnShortVideo,
// //     required this.myRating,
//     required this.myReview,
//   });
// }

class MediaFields {
  static final List<String> values = [
    /// Add all fields
    id, mediaType, tmdbId, watchTimes, isOnShortVideo,
    watchedDate, wantToWatchDate, browseDate, searchDate,
    watchStatus, myRating, myReview,
  ];

  static const String id = '_id';
  static const String mediaType = 'mediaType';
  static const String tmdbId = 'tmdbId';
  static const String watchTimes = 'watchTimes';
  static const String isOnShortVideo = 'isOnShortVideo';
  static const String watchedDate = 'watchedDate';
  static const String wantToWatchDate = 'wantToWatchDate';
  static const String browseDate = 'browseDate';
  static const String searchDate = 'searchDate';
  static const String watchStatus = 'watchStatus';
  static const String myRating = 'myRating';
  static const String myReview = 'myReview';
}

class MyMedia {
  final int? id;
  final String tmdbId;
  final String mediaType; // 分为电影，电视剧和书
  final DateTime? wantToWatchDate;
  final DateTime? watchedDate;
  final DateTime? browseDate;
  final DateTime? searchDate;
  final String watchStatus; // 分为想看，看过和在看
  final int watchTimes; // 刷的次数
  final bool isOnShortVideo; // 是否在短视频上看的
  // final int myRating;
  final int? myRating; // 刷的次数
  final String myReview;

  const MyMedia({
    this.id,
    required this.tmdbId,
    required this.mediaType,
    required this.wantToWatchDate,
    required this.watchedDate,
    required this.browseDate,
    required this.searchDate,
    required this.watchStatus,
    required this.watchTimes,
    required this.isOnShortVideo,
    required this.myRating,
    required this.myReview,
  });

  MyMedia copy({
    int? id,
    String? tmdbId,
    String? mediaType,
    DateTime? wantToWatchDate,
    DateTime? watchedDate,
    DateTime? browseDate,
    DateTime? searchDate,
    String? watchStatus,
    int? watchTimes,
    bool? isOnShortVideo,
    int? myRating,
    String? myReview,
  }) =>
      MyMedia(
        id: id ?? this.id,
        tmdbId: tmdbId ?? this.tmdbId,
        mediaType: mediaType ?? this.mediaType,
        wantToWatchDate: wantToWatchDate ?? this.wantToWatchDate,
        watchedDate: watchedDate ?? this.watchedDate,
        browseDate: browseDate ?? this.browseDate,
        searchDate: searchDate ?? this.searchDate,
        watchStatus: watchStatus ?? this.watchStatus,
        watchTimes: watchTimes ?? this.watchTimes,
        isOnShortVideo: isOnShortVideo ?? this.isOnShortVideo,
        myRating: myRating ?? this.myRating,
        myReview: myReview ?? this.myReview,
      );

  static MyMedia fromJson(Map<String, Object?> json) => MyMedia(
        id: json[MediaFields.id] as int?,
        tmdbId: json[MediaFields.tmdbId] as String,
        mediaType: json[MediaFields.mediaType] as String,
        wantToWatchDate: json[MediaFields.wantToWatchDate] != null
            ? DateTime.parse(json[MediaFields.wantToWatchDate] as String)
            : null,
        watchedDate: json[MediaFields.watchedDate] != null
            ? DateTime.parse(json[MediaFields.watchedDate] as String)
            : null,
        browseDate: json[MediaFields.browseDate] != null
            ? DateTime.parse(json[MediaFields.browseDate] as String)
            : null,
        searchDate: json[MediaFields.searchDate] != null
            ? DateTime.parse(json[MediaFields.searchDate] as String)
            : null,
        watchStatus: json[MediaFields.watchStatus] as String,
        watchTimes: json[MediaFields.watchTimes] as int,
        isOnShortVideo: json[MediaFields.isOnShortVideo] == 0,
        myRating: json[MediaFields.myRating] as int,
        myReview: json[MediaFields.myReview] as String,
      );

  Map<String, Object?> toJson() => {
        MediaFields.id: id,
        MediaFields.tmdbId: tmdbId,
        MediaFields.mediaType: mediaType,
        MediaFields.wantToWatchDate: wantToWatchDate?.toIso8601String(),
        MediaFields.watchedDate: watchedDate?.toIso8601String(),
        MediaFields.browseDate: browseDate?.toIso8601String(),
        MediaFields.searchDate: searchDate?.toIso8601String(),
        MediaFields.watchStatus: watchStatus,
        MediaFields.watchTimes: watchTimes,
        MediaFields.isOnShortVideo: isOnShortVideo ? 1 : 0,
        MediaFields.myRating: myRating,
        MediaFields.myReview: myReview,
      };
}
