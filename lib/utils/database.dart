import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart' show join;
import 'package:tracker/utils/data_structure.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

//表名
const String mediaTable = 'myMedia';
const String localTable = 'localData';

class MediaDatabase {

  MediaDatabase._init();
  static final MediaDatabase instance = MediaDatabase._init();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('media.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    sqfliteFfiInit();
    final dbPath = await databaseFactory.getDatabasesPath();
    final path = join(dbPath, filePath);
    print(path);
    return await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _createDB,
        ),
    );
  }

  //以上是建立数据库media.db
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const intType = 'INTEGER';
    const doubleType = 'Double';
    const textType = 'TEXT';
    const boolType = 'BOOLEAN';

  //在这里加入多个表的创建sql语句,并定义相应的const量
  //medias表
    await db.execute('''
CREATE TABLE $mediaTable ( 
  ${MediaFields.id} $idType, 
  ${MediaFields.mediaType} $textType,
  ${MediaFields.tmdbId} $textType,
  ${MediaFields.watchTimes} $intType,
  ${MediaFields.isOnShortVideo} $boolType,
  ${MediaFields.watchedDate} $textType,
  ${MediaFields.wantToWatchDate} $textType,
  ${MediaFields.browseDate} $textType,
  ${MediaFields.searchDate} $textType,
  ${MediaFields.watchStatus} $textType,
  ${MediaFields.myReview} $textType,
  ${MediaFields.myRating} $intType
  )
''');

  //localdata表——————————》Todo:还需要加tmdbid的外键约束重构一下
    await db.execute('''
CREATE TABLE $localTable ( 
  ${SingleMovieField.tmdbid} $intType, 
  ${SingleMovieField.adult} $boolType, 
  ${SingleMovieField.backdropPath} $textType, 
  ${SingleMovieField.originalLanguage} $textType, 
  ${SingleMovieField.originalTitle} $textType, 
  ${SingleMovieField.overview} $textType, 
  ${SingleMovieField.popularity} $doubleType, 
  ${SingleMovieField.posterPath} $textType, 
  ${SingleMovieField.releaseDate} $textType, 
  ${SingleMovieField.title} $textType, 
  ${SingleMovieField.voteAverage} $doubleType, 
  ${SingleMovieField.voteCount} $intType
  )
''');
  }

  //为每个表、相对的数据结构类建立相应方法
  //medias——》MyMedia类
  //localdata——》SingleMovie类

  Future<MyMedia> createMedia(MyMedia media) async {
    final db = await instance.database;
    final id = await db.insert(mediaTable, media.toJson());
    return media.copy(id: id);
  }

  Future<MyMedia> readMedia(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      mediaTable,
      columns: MediaFields.values,
      where: '${MediaFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return MyMedia.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<MyMedia>> readAllMedias() async {
    final db = await instance.database;

    const orderBy = '${MediaFields.watchedDate} ASC';
    final result =
        await db.rawQuery('SELECT * FROM $mediaTable ORDER BY $orderBy');
    return result.map((json) => MyMedia.fromJson(json)).toList();
  }

  Future<int> updateMedia(MyMedia media) async {
    final db = await instance.database;

    return db.update(
      mediaTable,
      media.toJson(),
      where: '${MediaFields.id} = ?',
      whereArgs: [media.id],
    );
  }

  Future<int> deleteMedia(int id) async {
    final db = await instance.database;
    return await db.delete(
      mediaTable,
      where: '${MediaFields.id} = ?',
      whereArgs: [id],
    );
  }

//localdata方法
  Future<SingleMovie> createLocal(SingleMovie movie) async {
    final db = await instance.database;
    final id = await db.insert(localTable, movie.toJson());
    return movie;
  }

  // Future<MyMedia> readLocal(int id) async {
  //   final db = await instance.database;

  //   final maps = await db.query(
  //     mediaTable,
  //     columns: MediaFields.values,
  //     where: '${MediaFields.id} = ?',
  //     whereArgs: [id],
  //   );

  //   if (maps.isNotEmpty) {
  //     return MyMedia.fromJson(maps.first);
  //   } else {
  //     throw Exception('ID $id not found');
  //   }
  // }

  Future<List<SingleMovie>> readAllLocal() async {
    final db = await instance.database;

    const orderBy = '${SingleMovieField.voteAverage} DESC';
    final result =
        await db.rawQuery('SELECT * FROM $localTable ORDER BY $orderBy');
    return result.map((json) => SingleMovie.fromJson(json)).toList();
  }

  // Future<int> updateLocal(MyMedia media) async {
  //   final db = await instance.database;

  //   return db.update(
  //     mediaTable,
  //     media.toJson(),
  //     where: '${MediaFields.id} = ?',
  //     whereArgs: [media.id],
  //   );
  // }

  // Future<int> deleteLocal(int id) async {
  //   final db = await instance.database;
  //   return await db.delete(
  //     mediaTable,
  //     where: '${MediaFields.id} = ?',
  //     whereArgs: [id],
  //   );
  // }






  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
