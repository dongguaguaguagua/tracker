import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart' show join;
import 'package:tracker/data_structure.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const String mediaTable = 'medias';

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

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE $mediaTable ( 
  ${MediaFields.id} 'INTEGER PRIMARY KEY AUTOINCREMENT', 
  ${MediaFields.mediaType} 'TEXT',
  ${MediaFields.tmdbId} 'TEXT',
  ${MediaFields.watchTimes} 'INTEGER',
  ${MediaFields.isOnShortVideo} 'BOOLEAN',
  ${MediaFields.watchedDate} 'TEXT',
  ${MediaFields.wantToWatchDate} 'TEXT',
  ${MediaFields.browseDate} 'TEXT',
  ${MediaFields.searchDate} 'TEXT',
  ${MediaFields.watchStatus} 'TEXT',
  ${MediaFields.myReview} 'TEXT',
  ${MediaFields.myRating} 'INTEGER'
  )
''');
  }
  // ${MediaFields.myRating} $integerType,

  Future<MyMedia> create(MyMedia media) async {
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

  Future<int> update(MyMedia media) async {
    final db = await instance.database;

    return db.update(
      mediaTable,
      media.toJson(),
      where: '${MediaFields.id} = ?',
      whereArgs: [media.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      mediaTable,
      where: '${MediaFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
