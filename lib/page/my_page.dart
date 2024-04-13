import 'package:flutter/material.dart';
import 'package:tracker/utils/data_structure.dart';
import '/utils/database.dart';

var date =DateTime(2024,1,1);
MyMedia test_Media = MyMedia(
    tmdbId: '-1',
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

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
              onPressed:()=> print('hello'),
              child: Text('测试按钮'),
          ),
          ElevatedButton(
              onPressed: (){
                var db = MediaDatabase.instance;
                db.create(test_Media);
              },
              child: Text('进行插入操作'))
        ],
      ),
    );
  }
}
