import 'dart:ffi' hide Size;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker/utils/database.dart';
import '../utils/data_structure.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MoviePage extends StatefulWidget {
  SingleMovie movie;
  MoviePage({super.key, required this.movie});
  
  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  bool isWatched = false;// 追踪是否已点击
  bool wanttoWatch = false;
  bool inlist =false;
  double currentRating = 1.0;
  
  @override
  void initState() {
    super.initState();
    loadState();
  }
//页面初始化时加载myTable和infoTable

  void loadState() async{
    print('select * from myTable where tmdbId=${widget.movie.tmdbId}');
    //这是去获取最新的myTable表
    final result = await ProjectDatabase().sudoQuery('select * from myTable where tmdbId=${widget.movie.tmdbId}');
    int id = result[0]['id'];
    MyMedia media =  await ProjectDatabase().MM_read_id(id);

    setState(() {
      isWatched = (media.watchedDate != null);
      wanttoWatch = (media.wantToWatchDate != null);
      currentRating = media.myRating ?? 0.0;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 246, 247),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 238, 246, 247),
        toolbarHeight: 80,
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
                      imageUrl: "https://image.tmdb.org/t/p/w500/${widget.movie.posterPath}",
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
                            widget.movie.title!,
                            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              'TMDB评分：${widget.movie.voteAverage} (${widget.movie.voteCount})',
                              style: const TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text(
                              widget.movie.overview!,
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
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                        icon: Icon(
                          wanttoWatch ? Icons.favorite : Icons.favorite_border, // 根据状态切换图标
                          color: Colors.purple, // 图标颜色
                        ),
                        label: const Text('想看'),
                        onPressed: () async{
                          //这是去获取最新的myTable表
                          final result = await ProjectDatabase().sudoQuery('select * from myTable where tmdbId=${widget.movie.tmdbId}');
                          int id = result[0]['id'];
                          MyMedia media =  await ProjectDatabase().MM_read_id(id);
                          setState((){
                            wanttoWatch = !wanttoWatch; // 切换状态
                            alterwantoWatch(wanttoWatch, media); //将myTable里该电影记录观看日期进行修改
                            //movie
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // 按钮颜色
                          foregroundColor: Colors.deepPurple, // 文本颜色
                          shadowColor: Colors.deepPurple, // 阴影颜色
                          minimumSize: Size(140, 50), // 按钮大小
                        ),
                      ),
                  ElevatedButton.icon(
                        icon: Icon(
                          isWatched ? Icons.library_add_check : Icons.library_add_check_outlined, // 根据状态切换图标
                          color: Colors.purple, // 图标颜色
                        ),
                        label: const Text('看过'),
                        onPressed: () async{
                          //这是去获取最新的myTable表
                          final result = await ProjectDatabase().sudoQuery('select * from myTable where tmdbId=${widget.movie.tmdbId}');
                          int id = result[0]['id'];
                          MyMedia media =  await ProjectDatabase().MM_read_id(id);
                          setState((){
                            isWatched = !isWatched; // 切换状态
                            alterWatched(isWatched, media); //将myTable里该电影记录观看日期进行修改
                            //movie
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // 按钮颜色
                          foregroundColor: Colors.deepPurple, // 文本颜色
                          shadowColor: Colors.deepPurple, // 阴影颜色
                          minimumSize: Size(140, 50), // 按钮大小
                        ),
                      ),
                  ElevatedButton.icon(
                        icon: Icon(
                          inlist ? Icons.archive : Icons.archive_outlined, // 根据状态切换图标
                          color: Colors.purple, // 图标颜色
                        ),
                        label: const Text('加入列表'),
                        onPressed: () async{
                          //这是去获取最新的myTable表
                          final result = await ProjectDatabase().sudoQuery('select * from myTable where tmdbId=${widget.movie.tmdbId}');
                          int id = result[0]['id'];
                          MyMedia media =  await ProjectDatabase().MM_read_id(id);
                          setState((){
                            inlist = !inlist;
                            print('这里的豆列还需要进行部署');
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // 按钮颜色
                          foregroundColor: Colors.deepPurple, // 文本颜色
                          shadowColor: Colors.deepPurple, // 阴影颜色
                          minimumSize: Size(140, 50), // 按钮大小
                        ),
                      ),
                ],
              ),
            const SizedBox(height: 40),
            RatingBar.builder(
              initialRating: currentRating,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: false,
              ignoreGestures: false,
              itemCount: 5,
              itemSize: 30,
              unratedColor: Colors.white,
              itemPadding: const EdgeInsets.symmetric(horizontal: 6.0),
              itemBuilder: (context, index) {
                return const Icon(
                  Icons.star,
                  color: Colors.amber,
                );
              },
              onRatingUpdate: (rating) async{
                //这是去获取最新的myTable表
                final result = await ProjectDatabase().sudoQuery('select * from myTable where tmdbId=${widget.movie.tmdbId}');
                int id = result[0]['id'];
                MyMedia media =  await ProjectDatabase().MM_read_id(id);
                setState(() {
                  media.myRating = rating;
                  alterRating(rating, media);
                });
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
              maxLines: 8,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(height: 1.75, color: Colors.blueGrey),
            ),
          ],
        ),

      ),
    );

    
  }


  void alterRating(double rating,MyMedia media) async {
    media.myRating = rating;
    await ProjectDatabase().updateMedia(media);
  }

  void alterwantoWatch(bool wanttoWatch, MyMedia media) async {
    DateTime date = DateTime.now();
    media.wantToWatchDate = wanttoWatch ?date :null;
    await ProjectDatabase().updateMedia(media);
  }

  void alterWatched(bool isWatched, MyMedia media) async {
    DateTime date = DateTime.now();
    //String formatdate = DateFormat('yyyy-MM-dd').format(date);// 定义年月日的格式，这里使用 yyyy-MM-dd
    media.watchedDate= isWatched ?date :null;
    media.watchTimes= 1;
    media.browseDate= isWatched ?date :null;

    await ProjectDatabase().updateMedia(media);
  }
}
