import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tracker/utils/data_structure.dart';
import '/utils/database.dart';
var date =DateTime(2024,1,1);
MyMedia test_Media = MyMedia(
    tmdbId: -1,
    mediaType: 'Movie',
    wantToWatchDate: date,
    watchedDate: date,
    browseDate: date,
    searchDate: date,
    watchStatus: 'watched',
    watchTimes: 1,
    isOnShortVideo: false,
    myRating: 5,
    myReview: 'yks is handsome',
);

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      body: Column(
        children: [
           SizedBox(height: 250,),
          Center(
            
            child: Text('这里以后是测试页面，最终这个page没有，只有剩下4个page')),
          SizedBox(height: 50,),
          ElevatedButton(
              onPressed:()=> print('hello'),
              child: const Text('测试按钮'),
          ),
          ElevatedButton(
              onPressed: () async {
                final db = ProjectDatabase();
                var genreIns = Genre(
                  genre: 'b',
                  genreId: 2,
                );
                var singleMovie = SingleMovie(
                );
                var genres =  await db.singleMovieTable.magic(singleMovie);
                print (genres[0].toJson());
              },
              child: const Text('进行插入操作')),
          ElevatedButton(
              onPressed: () async{
                final db = ProjectDatabase();
                final data = await db.SI_read_all();
                print(data);
              },
              child: const Text('输出从localdata表（本地存储所有用户收藏的电影信息）里的记录')),


          ElevatedButton(
              onPressed: () async{
                final movie = SingleMovie(
                  tmdbId: 23234,
                );

                
                await ProjectDatabase().SI_add(movie);

              },
              child: const Text('test sudo'))
        ],
      ),

    );
  }
}
