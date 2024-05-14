import 'dart:async';
//import 'dart:html';
//import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' show join;
import 'package:tracker/utils/data_structure.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tuple/tuple.dart';
//import 'package:collection/collection.dart';

//表名
const String myTable = 'myTable';
const String infoTable = 'infoTable';
const String genreTable = 'genreTable';

class ProjectDatabase {
  ProjectDatabase._init();

  factory ProjectDatabase() => _instance;
  static final ProjectDatabase _instance = ProjectDatabase._init();

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
    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _createDB,
      ),
    );
  }

  Table genreTable = Table(tableName: 'genreTable');
  Table singleMovieTable = Table(tableName: 'infoTable');
  //Table collectionInsTable = Table(tableName: 'collections', dbHelper: _instance);
  //Table collectionTable = Table(tableName: 'collectionTable', dbHelper: _instance);
  //Table myCollectionInsTable = Table(tableName: 'myCollections', dbHelper: _instance);
  //Table myCollectionTable = Table(tableName: 'myCollectionTable', dbHelper: _instance);
  //Table myMediaTable = Table(tableName: 'myTable', dbHelper: _instance);

  //以上是建立数据库media.db
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const intType = 'INTEGER';
    const doubleType = 'Double';
    const textType = 'TEXT';
    const boolType = 'BOOLEAN';

    //infoTable表
    await db.execute(SingleMovie.createSQL);

    //CollectionTable表
    await db.execute(Collection.createSQL);

    //myCollectionTable表
    await db.execute(MyCollection.createSQL);

    //myTable表
    await db.execute(MyMedia.createSQL);

    //genreTable表
    await db.execute(Genre.createSQL);

    //Collection, infoTable关系表
    await db.execute(CollectionInstances.createSQL);

    //MyCollection, MyTable关系表
    await db.execute(MyCollectionInstance.createSQL);

    //Genre, InfoTable关系表
    await db.execute(GenreInfo.createSQL);
  }

  //为每个表、相对的数据结构类建立相应方法
  //myTable-->MyMedia类 --> MM
  //infoTable-->SingleMovie类 --> SI
  //collectionTable --> Collection类 --> CO
  //myCollectionTable -->MyCollection类 --> MC
  //genreTable-->Genre类 --> GE

  Future<int> MM_add(MyMedia media) async {
    if (media.id == 0) return 0;
    final db = await _instance.database;
    try {
      final id = await db.insert(myTable, media.toJson());
      media.id = id; // 确保更新对象的 id 属性
      return id;
    } catch (e) {
      print('An error occurred while inserting a movie: $e');
      return 0; // 抛出一个自定义的错误
    }
  }

  Future<MyMedia> MM_read_id(int id) async {
    final db = await _instance.database;

    final maps = await db.query(
      myTable,
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

  Future<List<MyMedia>> MM_read_all() async {
    final db = await _instance.database;

    const orderBy = '${MediaFields.watchedDate} ASC';
    final result =
        await db.rawQuery('SELECT * FROM $myTable ORDER BY $orderBy');
    return result.map((json) => MyMedia.fromJson(json)).toList();
  }

  Future<int> updateMedia(MyMedia media) async {
    final db = await _instance.database;

    return db.update(
      myTable,
      media.toJson(),
      where: '${MediaFields.id} = ?',
      whereArgs: [media.id],
    );
  }

  Future<int> deleteMedia(int id) async {
    final db = await _instance.database;
    return await db.delete(
      myTable,
      where: '${MediaFields.id} = ?',
      whereArgs: [id],
    );
  }

//Infotable方法

  Future<SingleMovie> SI_add(SingleMovie movie) async {
    final db = await _instance.database;
    try {
      final id = await db.insert(infoTable, movie.toJson());
      movie.id = id; // 确保更新对象的 id 属性
      return movie;
    } catch (e) {
      print('An error occurred while inserting a movie: $e');
      return movie; // 抛出一个自定义的错误
    }
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

  Future<List<SingleMovie>> SI_read_all() async {
    final db = await _instance.database;
    //const orderBy = '${SingleMovieField.voteAverage} DESC';
    try {
      final result = await db.rawQuery('SELECT * FROM $infoTable');
      final a = result.map((json) => SingleMovie.fromJson(json)).toList();
      return a;
    } catch (e) {
      print('Error reading from the database: $e');
      return [];
    }
  }

  Future<int> SI_update(SingleMovie movie) async {
    final db = await _instance.database;

    return db.update(
      infoTable,
      movie.toJson(),
      where: '${MediaFields.id} = ?',
      whereArgs: [movie.id],
    );
  }

  // Future<int> deeLocal(int id) async {
  //   final db = await instance.database;
  //   return await db.delete(
  //     mediaTable,
  //     where: '${MediaFields.id} = ?',
  //     whereArgs: [id],
  //   );
  // }

  Future<dynamic> sudo(String sql) async {
    final db = await _instance.database;
    db.execute(sql);
  }

  Future sudoInsert(String sql) async {
    final db = await _instance.database;
    dynamic result = db.rawInsert(sql);
    return result;
  }

  Future<dynamic> sudoQuery(String sql) async {
    final db = await _instance.database;
    dynamic result = db.rawQuery(sql);
    return result;
  }

  Future<int> sudoDelete(String sql) async {
    final db = await _instance.database;
    dynamic result = db.rawDelete(sql);
    return result;
  }

  Future<int> sudoUpdate(String sql) async {
    final db = await _instance.database;
    dynamic result = db.rawUpdate(sql);
    return result;
  }

  Future close() async {
    final db = await _instance.database;
    db.close();
  }

  //这里是功能需要的很复杂的sql查询语句
  //1.查询homepage的历史观影记录
  Future<List<Tuple2<SingleMovie, MyMedia>>> gethistory() async {
    final db = await _instance.database;
    //按照看过日期排序否则想看日期排序
    final info = await db.rawQuery(
        'SELECT it.* FROM infoTable it JOIN ( SELECT * FROM myTable WHERE watchStatus=\'watched\' OR watchStatus=\'wanttowatch\' )mt ON it.id = mt.id ORDER BY CASE WHEN watchedDate IS NOT NULL THEN watchedDate ELSE wantToWatchDate END DESC');

    final status = await db.rawQuery(
        'SELECT * FROM myTable WHERE watchStatus=\'watched\' OR watchStatus=\'wanttowatch\' ORDER BY CASE WHEN watchedDate IS NOT NULL THEN watchedDate ELSE wantToWatchDate END DESC');

    final a = info.map((json) => SingleMovie.fromJson(json)).toList();
    final b = status.map((json) => MyMedia.fromJson(json)).toList();

    final result = List.generate(a.length, (i) => Tuple2(a[i], b[i]));

    return result;
  }

  //2.mypage展示合集的数据获取
  Future<List<SingleMovie>> getcollectdata(int i) async {
    final db = await _instance.database;
    String query3 =
        "select info.* from myCollections mc,infoTable info,myTable mt where info.tmdbId=mt.tmdbId and mt.id=mc.myMediaId and mc.myCollectionId='$i' and mt.watchStatus='watched' order by mt.watchedDate DESC";
    final s = await db.rawQuery(query3);

    List<SingleMovie> tmp =
        s.map((json) => SingleMovie.fromJson(json)).toList();
    return tmp;
  }
  //3.mypage展示美国电影
  Future<List<SingleMovie>> getcountrydata() async {
    final db = await _instance.database;
    String queryus = "select info.* from infoTable info,myTable mt where info.tmdbId=mt.tmdbId and info.originalCountry='US' and mt.watchStatus='watched' order by mt.watchedDate DESC";

    final s = await db.rawQuery(queryus);

    List<SingleMovie> tmp =
    s.map((json) => SingleMovie.fromJson(json)).toList();
    return tmp;
  }

  //4.mypage展示评分过的电影（排序）
  Future<List<Map<SingleMovie,double>>> getratingdata() async {
    final db = await _instance.database;
    String queryrating = "select info.* from infoTable info,myTable mt where info.tmdbId=mt.tmdbId and mt.myRating>0 and mt.watchStatus='watched' order by mt.myRating DESC, mt.wantedDate DESC";
    List<Map<SingleMovie,double>> result = [];
    final s = await db.rawQuery(queryrating);
    List<SingleMovie> tmp =
    s.map((json) => SingleMovie.fromJson(json)).toList();

    for (var t in tmp){
      final a = await db.rawQuery("select * from myTable where tmdbId=${t.tmdbId}");
      List<MyMedia> tmpp =
      a.map((json) => MyMedia.fromJson(json)).toList();
      double rating = a[0]['myRating'] as double;
      result.add({t:rating});
    }

    return result;
  }
  //4.mypage展示想看的数据获取
  Future<List<SingleMovie>> getwantwatchdata() async {
    final db = await _instance.database;
    String querywantwatch =
        "select info.* from infoTable info,myTable mt where info.tmdbId=mt.tmdbId and mt.watchStatus='wanttowatch' order by mt.wantToWatchDate DESC";
    final s = await db.rawQuery(querywantwatch);

    List<SingleMovie> tmp =
    s.map((json) => SingleMovie.fromJson(json)).toList();
    return tmp;
  }


}



class Table {
  final String tableName;

  Table({
    required this.tableName,
  });

  Future<List<dynamic>> magic(dynamic ins) async {
    Database db = await ProjectDatabase().database;
    //genreIns中没有的参数
    List<String> outList = ['id'];
    //genreIns中有的参数
    List<Object> inList = [];
    String where = '';
    String whereAll = '';
    List<dynamic> allWhereArgs = [];
    Map originalJson = ins.toJson();
    originalJson.remove('id');
    originalJson.forEach((key, value) {
      whereAll += 'and $key = ? ';
      allWhereArgs.add(value);
      if (value == null) {
        outList.add(key);
      } else {
        inList.add(value);
        where += 'and $key = ? ';
      }
    });
    whereAll = whereAll.substring(4);
    if (inList.isNotEmpty) where = where.substring(4);
    List<dynamic> allIns = [];
    if (inList.isEmpty) {
      var answers = await db.rawQuery('SELECT * FROM $tableName');
      print(answers.length);
      for (var answer in answers) {
        print('1');
        print(answer);
        var insCopy = ins;
        print(insCopy.toJson());
        insCopy.addJson(answer);
        print(insCopy.toJson());
        allIns.add(insCopy);
      }
      return allIns;
    }
    if (outList.length >= 2) {
      var answers = await db.query(
        tableName,
        distinct: false,
        columns: outList,
        where: where,
        whereArgs: inList,
      );
      for (var answer in answers) {
        var insCopy = ins;
        insCopy.addJson(answer);
        allIns.add(insCopy);
      }
      return allIns;
    } else {
      var temp = await db.query(
        tableName,
        columns: ['id'],
        where: whereAll,
        whereArgs: allWhereArgs,
      );
      if (temp.isNotEmpty && ins.id == null) {
        var state = ins;
        state.id = -1;
        allIns.add(state);
        return allIns;
      }
      if (temp.isNotEmpty && ins.id != null) {
        await db.delete(
          tableName,
          where: whereAll,
          whereArgs: allWhereArgs,
        );
        var state = ins;
        state.id = -2;
        allIns.add(state);
        return allIns;
      }
      await db.insert(tableName, originalJson as Map<String, Object?>);
      temp = await db.query(
        tableName,
        columns: ['id'],
        where: whereAll,
        whereArgs: allWhereArgs,
      );
      ins.addJson(temp[0]);
      var state = ins;
      state.id = -3;
      allIns.add(state);
      return allIns;
    }
  }
}
