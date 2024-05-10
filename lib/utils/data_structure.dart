// 单个电影的数据结构
import 'dart:ffi';

import 'package:flutter/foundation.dart';

class SingleMovieField {
  static final List<String> values = [
    /// Add all fields
    id, tmdbId, adult, backdropPath, originalLanguage,
    originalTitle, overview, popularity, posterPath,
    releaseDate, title, voteAverage, voteCount, 
    
    runtime,originalCountry,
  ];

  static const String id = 'id';
  static const String tmdbId = 'tmdbId';
  static const String adult = 'adult';
  static const String backdropPath = 'backdropPath';
  static const String originalLanguage = 'originalLanguage';
  static const String originalTitle = 'originalTitle';
  static const String overview = 'overview';
  static const String popularity = 'popularity';
  static const String posterPath = 'posterPath';
  static const String releaseDate = 'releaseDate';
  static const String title = 'title';
  static const String voteAverage = 'voteAverage';
  static const String voteCount = 'voteCount';
  
  static const String runtime = 'runtime';
  static const String originalCountry = 'originalCountry';
}

//InfoTable内容
class SingleMovie {
  int? id ;
  int? tmdbId; //TMDBid
  bool? adult;
  String? backdropPath;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  double? voteAverage;
  int? voteCount;
  int? runtime;
  String? originalCountry;

  SingleMovie({
    this.tmdbId,
    this.adult,
    this.backdropPath,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.voteAverage,
    this.voteCount,

    this.runtime,
    this.originalCountry,
  });

  static const String createSQL = """
create table infoTable
(
    tmdbId           INTEGER UNIQUE,
    adult            BOOLEAN,
    backdropPath     TEXT,
    originalLanguage TEXT,
    originalTitle    TEXT,
    overview         TEXT,
    popularity       Double,
    posterPath       TEXT,
    releaseDate      TEXT,
    title            TEXT,
    voteAverage      Double,
    voteCount        INTEGER,

    runtime          INTEGER,
    originalCountry  TEXT,

    id               integer
        constraint localTable_pk
            primary key autoincrement
);
  """;
//从api转和从本地表转列名冲突，因此分开写
  factory SingleMovie.fromJson(Map<String, dynamic> json) {
    return SingleMovie(
      tmdbId: json['tmdbId'],
      adult: json['adult'] == 1,
      backdropPath: json['backdropPath'].toString(),
      originalLanguage: json['originalLanguage'].toString(),
      originalTitle: json['originalTitle'].toString(),
      overview: json['overview'].toString(),
      popularity: json['popularity'].toDouble(),
      posterPath: json['posterPath'].toString(),
      releaseDate: json['releaseDate'].toString(),
      title: json['title'].toString(),
      voteAverage: json['voteAverage'].toDouble(),
      voteCount: json['voteCount'],
      runtime: json['runtime'],
      originalCountry: json['originalCountry'],
    );
  }
  // 为了从api里的json转成List<SingleMovie>
  factory SingleMovie.apiFromJson(Map<String, dynamic> json) {
    return SingleMovie(
      tmdbId: json['id'],
      adult: json['adult'] == 1,
      backdropPath: json['backdrop_path'].toString(),
      originalLanguage: json['original_language'].toString(),
      originalTitle: json['original_title'].toString(),
      overview: json['overview'].toString(),
      popularity: json['popularity'].toDouble(),
      posterPath: json['poster_path'].toString(),
      releaseDate: json['release_date'].toString(),
      title: json['title'].toString(),
      voteAverage: json['vote_average'].toDouble(),
      voteCount: json['vote_count'],
    );
  }
  


  Map<String, Object?> toJson() {
    int? adultCopy;
    if(adult != null) adultCopy = adult!?1:0;
    return {
        SingleMovieField.id: id,
        SingleMovieField.tmdbId: tmdbId,
        SingleMovieField.adult: adultCopy,
        SingleMovieField.backdropPath: backdropPath,
        SingleMovieField.originalLanguage: originalLanguage,
        SingleMovieField.originalTitle: originalTitle,
        SingleMovieField.overview: overview,
        SingleMovieField.popularity: popularity,
        SingleMovieField.posterPath: posterPath,
        SingleMovieField.releaseDate: releaseDate,
        SingleMovieField.title: title,
        SingleMovieField.voteAverage: voteAverage,
        SingleMovieField.voteCount: voteCount,
        SingleMovieField.runtime: runtime,
        SingleMovieField.originalCountry: originalCountry,
      };
  }

  addJson(Map<String, dynamic> json){
    id??=json[SingleMovieField.id];
    tmdbId??=json[SingleMovieField.tmdbId];
    adult??=json[SingleMovieField.adult];
    backdropPath??=json[SingleMovieField.backdropPath];
    originalLanguage??=json[SingleMovieField.originalLanguage];
    originalTitle??=json[SingleMovieField.originalTitle];
    overview??=json[SingleMovieField.overview];
    popularity??=json[SingleMovieField.popularity];
    posterPath??=json[SingleMovieField.posterPath];
    releaseDate??=json[SingleMovieField.releaseDate].toString();
    title??=json[SingleMovieField.title];
    voteAverage??=json[SingleMovieField.voteAverage];
    voteCount??=json[SingleMovieField.voteCount];
    runtime??=json[SingleMovieField.runtime];
    originalCountry??=json[SingleMovieField.originalCountry];
  }


}

class CollectionFields {
  static final List<String> values = [
    /// Add all fields
    name, posterPath, backdropPath, collectionId
  ];

  static const String name = 'name';
  static const String posterPath = 'poster_path';
  static const String backdropPath = 'backdrop_path';
  static const String collectionId = 'id';
}

//collectionTable和myCollectionTable内容
class Collection {
  int? id = 0;
  int? collectionId;
  String? name;
  String? posterPath;
  String? backdropPath;

  Collection({
    this.name,
    this.posterPath,
    this.backdropPath,
    this.collectionId,
  });

  static const String createSQL = """
  create table if not exists collectionTable
(
    id           integer
        constraint collectionTable_pk
            primary key autoincrement,
    name         TEXT,
    backdropPath TEXT,
    posterPath   TEXT,
    collectionId integer
);
  """;

  Collection copy({
    int? collectionId,
    String? name,
    String? posterPath,
    String? backdropPath,
  }) =>
      Collection(
        collectionId: collectionId ?? this.collectionId,
        name: name ?? this.name,
        posterPath: posterPath ?? this.posterPath,
        backdropPath: backdropPath ?? this.backdropPath,
      );

  static Collection fromJson(Map<String, Object?> json) => Collection(
        collectionId: json[CollectionFields.collectionId] as int,
        name: json[CollectionFields.name] as String,
        posterPath: json[CollectionFields.posterPath] as String,
        backdropPath: json[CollectionFields.backdropPath] as String,
      );

  Map<String, Object?> toJson() => {
        CollectionFields.collectionId: collectionId,
        CollectionFields.name: name,
        CollectionFields.posterPath: posterPath,
        CollectionFields.backdropPath: backdropPath,
      };

  addJson(Map<String, dynamic> json){
    id??=json['id'];
    name??=json['name'];
    posterPath??=json['posterPath'];
    backdropPath??=json['backdropPath'];
    collectionId??=json['collectionId'];
  }
}

class MyCollectionFields {
  static final List<String> values = [
    /// Add all fields
    id, name, posterPath, backdropPath,
  ];

  static const String id = 'id';
  static const String name = 'name';
  static const String posterPath = 'posterPath';
  static const String backdropPath = 'backdropPath';
}

class MyCollection {
  int? id = 0;
  String? name;
  String? posterPath;
  String? backdropPath;

  MyCollection({
    this.name,
    this.posterPath,
    this.backdropPath,
  });

  Map<String, dynamic> toJson(){
    return {
      'id':id,
      'name':name,
      'posterPath': posterPath,
      'backgroundPath':backdropPath,
    };
  }

  addJson(Map<String, dynamic> json){
    id??= json['id'];
    name??= json['name'];
    posterPath??= json['posterPath'];
    backdropPath??= json['backdropPath'];
  }

  static const String createSQL = """
  create table if not exists myCollectionTable
(
    id             integer
        constraint myCollectionTable_pk
            primary key autoincrement,
    collectionName TEXT,
    posterPath     TEXT,
    backdropPath   TEXT
);
  """;
}

class MediaFields {
  static final List<String> values = [
    /// Add all fields
    id, mediaType, tmdbId, watchTimes, isOnShortVideo,
    watchedDate, wantToWatchDate, browseDate, searchDate,
    watchStatus, myRating, myReview,
  ];

  static const String id = 'id';
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

//myTable 内容
class MyMedia {
  int? id;
  int? tmdbId;
  String? mediaType; // 分为电影，电视剧和书
  DateTime? wantToWatchDate;
  DateTime? watchedDate;
  DateTime? browseDate;
  DateTime? searchDate;
  String? watchStatus; // 分为想看，看过和在看
  int? watchTimes; // 刷的次数
  bool? isOnShortVideo; // 是否在短视频上看的
  double? myRating; // 我的评价
  String? myReview;

  MyMedia({
    this.id,
    this.tmdbId,
    this.mediaType,
    this.wantToWatchDate,
    this.watchedDate,
    this.browseDate,
    this.searchDate,
    this.watchStatus,
    this.watchTimes,
    this.isOnShortVideo,
    this.myRating,
    this.myReview,
  });

  static const String createSQL = """
  create table if not exists myTable
(
    id              INTEGER
        primary key autoincrement,
    mediaType       TEXT,
    tmdbId          INTEGER UNIQUE
        constraint actTable_infoTable_tmdbId_fk
            references infoTable (tmdbId),
    watchTimes      INTEGER,
    isOnShortVideo  BOOLEAN,
    watchedDate     TEXT,
    wantToWatchDate TEXT,
    browseDate      TEXT,
    searchDate      TEXT,
    watchStatus     TEXT,
    myReview        TEXT,
    myRating        DOUBLE
);
  """;

  static MyMedia fromJson(Map<String, Object?> json) => MyMedia(
        id: json[MediaFields.id] as int?,
        tmdbId: json[MediaFields.tmdbId] as int,
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
        myRating: json[MediaFields.myRating] as double,
        myReview: json[MediaFields.myReview] as String,
      );

  addJson(Map<String, Object?> json){
    id??=json[MediaFields.id] as int?;
    tmdbId??=json[MediaFields.tmdbId] as int?;
    mediaType??=json[MediaFields.mediaType] as String;
    wantToWatchDate??=(json[MediaFields.wantToWatchDate] != null? DateTime.parse(json[MediaFields.wantToWatchDate] as String)
        : null);
    watchedDate??=json[MediaFields.watchedDate] != null
    ? DateTime.parse(json[MediaFields.watchedDate] as String)
        : null;
    browseDate??=json[MediaFields.browseDate] != null
    ? DateTime.parse(json[MediaFields.browseDate] as String)
        : null;
    searchDate??=json[MediaFields.searchDate] != null
    ? DateTime.parse(json[MediaFields.searchDate] as String)
        : null;
    watchStatus??=json[MediaFields.watchStatus] as String;
    watchTimes??= json[MediaFields.watchTimes] as int;
    isOnShortVideo??=json[MediaFields.isOnShortVideo] == 0;
    myRating??=json[MediaFields.myRating] as double;
    myReview??= json[MediaFields.myReview] as String;
  }

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
        MediaFields.isOnShortVideo: (isOnShortVideo ?? false) ? 1 : 0,
        MediaFields.myRating: myRating,
        MediaFields.myReview: myReview,
      };
}

class GenreFields {
  static final List<String> values = [
    /// Add all fields
    id, genre, genreId
  ];

  static const String id = 'id';
  static const String genre = 'genre';
  static const String genreId = 'genreId';
}

class Genre {
  int? id;
  int? genreId;
  String? genre;

  Genre({
    this.id,
    this.genreId,
    this.genre,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json[GenreFields.id] as int?,
      genreId: json[GenreFields.genreId] as int?,
      genre: json[GenreFields.genre] as String?,
    );
  }

  addJson(Map<String, dynamic> json) {
    id ??= json['id'];
    genreId ??= int.parse(json['genreId']);
    genre ??= json['genre'];
  }

  Map<String, dynamic> toJson(){
    return {
      GenreFields.id: id,
      GenreFields.genreId: genreId,
      GenreFields.genre: genre,
    };
  }

  static const String createSQL = """
      create table if not exists genreTable(
        genreId TEXT,
        genre   TEXT,
        id      integer constraint genre_pk primary key
      );
      """;
}

class MyCollectionInstancesFields {
  static final List<String> values = [
    /// Add all fields
    id, tmdbId, collectionId,
  ];

  static const String id = 'id';
  static const String collectionId = 'collectionId';
  static const String tmdbId = 'tmdbId';
}

class MyCollectionInstance {
  int? id;
  int? collectionId;
  int? tmdbId;

  MyCollectionInstance({
    this.id,
    this.collectionId,
    this.tmdbId,
  });

  factory MyCollectionInstance.fromJson(Map<String, dynamic> json) {
    return MyCollectionInstance(
      id: json[MyCollectionInstancesFields.id] as int?,
      collectionId: json[MyCollectionInstancesFields.collectionId] as int?,
      tmdbId: json[MyCollectionInstancesFields.tmdbId] as int?,
    );
  }

  addJson(Map<String, dynamic> json){
    id??=json[MyCollectionInstancesFields.id];
    collectionId??=json[MyCollectionInstancesFields.collectionId];
    tmdbId??=json[MyCollectionInstancesFields.tmdbId];
  }

  Map<String, dynamic> toJson(){
    return {
      'id':id,
      'collectionId':collectionId,
      'tmdbId':tmdbId,
    };
  }

  static const String createSQL = '''
create table collections
(
    id           integer,
    collectionId integer
        constraint collections_collectionTable_collectionId_fk
            references collectionTable (collectionId),
    tmdbId       integer
        constraint collections_infoTable_tmdbId_fk
            references infoTable (tmdbId)
);


  ''';
}

class CollectionInstancesFields {
  static final List<String> values = [
    /// Add all fields
    id, myCollectionId, myMediaId
  ];

  static const String id = 'id';
  static const String myCollectionId = 'myCollectionId';
  static const String myMediaId = 'myMediaId';
}

class CollectionInstances {
  int? id;
  int? myCollectionId;
  int? myMediaId;

  CollectionInstances({
    this.id,
    this.myCollectionId,
    this.myMediaId,
  });

  factory CollectionInstances.fromJson(Map<String, dynamic> json) {
    return CollectionInstances(
      id: json[CollectionInstancesFields.id] as int?,
      myCollectionId: json[CollectionInstancesFields.myCollectionId] as int?,
      myMediaId: json[CollectionInstancesFields.myMediaId] as int?,
    );
  }

  addJson(Map<String, dynamic> json) {
    id ??= int.parse(json[CollectionInstancesFields.id]);
    myCollectionId ??=
        int.parse(json[CollectionInstancesFields.myCollectionId]);
    myMediaId ??= int.parse(json[CollectionInstancesFields.myMediaId]);
  }

  Map<String, dynamic> toJson(){
    return{
      CollectionInstancesFields.id: id,
      CollectionInstancesFields.myCollectionId: myCollectionId,
      CollectionInstancesFields.myMediaId: myMediaId,
    };
  }

  static const String createSQL = '''
 create table myCollections
(
    id             integer,
    myCollectionId integer
        constraint myCollections_myCollectionTable_id_fk
            references myCollectionTable,
    myMediaId      integer
        constraint myCollections_myTable_id_fk
            references myTable
);


  ''';
}

class GenreInfoFields {
  static final List<String> values = [
    /// Add all fields
    id, genreId, tmdbId,
  ];
  static const String id = 'id';
  static const String genreId = 'genreId';
  static const String tmdbId = 'tmdbId';
}

class GenreInfo {
  int? id;
  int? genreId;
  int? tmdbId;

  GenreInfo({
    this.id,
    this.genreId,
    this.tmdbId,
  });

  factory GenreInfo.fromJson(Map<String, dynamic> json) {
    return GenreInfo(
      id: json[GenreInfoFields.id] as int?,
      genreId: json[GenreInfoFields.genreId] as int?,
      tmdbId: json[GenreInfoFields.tmdbId] as int?,
    );
  }

  addJson(Map<String, dynamic> json) {
    id ??= int.parse(json[GenreInfoFields.id]);
    genreId ??= int.parse(json[GenreInfoFields.genreId]);
    tmdbId ??= int.parse(json[GenreInfoFields.tmdbId]);
  }

  Map<String, dynamic> toJson(){
    return{
      GenreInfoFields.id: id,
      GenreInfoFields.genreId: genreId,
      GenreInfoFields.tmdbId: tmdbId,
    };
  }

  static const String createSQL = '''
 create table GenreInfo
(
    genreId integer
        constraint GenreInfo_genreTable_genreId_fk
            references genreTable (genreId),
    id      integer
        constraint GenreInfo_pk
            primary key autoincrement,
    tmdbId  integer
        constraint GenreInfo_infoTable_tmdbId_fk
            references infoTable (tmdbId)
);
  ''';
}
