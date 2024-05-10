import 'package:flutter/material.dart';
import 'package:tracker/utils/data_structure.dart';
import '../utils/database.dart';
import 'package:tracker/widgets/stats_MovieList.dart';
import 'package:tracker/widgets/movie_page.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<dynamic> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = ProjectDatabase().gethistory(); // 初始加载
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _historyFuture = ProjectDatabase().gethistory(); // 每次依赖变化时重新加载
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _historyFuture, // 使用一个可更新的 Future 变量
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return const Icon(Icons.error, size: 80);
            }
            if (snapshot.hasData) {
              return buildContent(snapshot.data, context); // 提取构建内容的方法
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget buildContent(dynamic data, BuildContext context) {
    List<Widget> listItems = [];
    String lastDate = '';
    for (final movie in data) {
      
      String currentMonthYear = "${movie.releaseDate.split('-')[0]}-${movie.releaseDate.split('-')[1]}";
      if (currentMonthYear != lastDate) {
        lastDate = currentMonthYear;
        listItems.add(
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              currentMonthYear,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black),
            ),
          ),
        );
      }
      listItems.add(
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: GestureDetector(
            onTap: () async {
              Get.to(MoviePage(movie: movie), transition: Transition.fadeIn);
            },
            child: MovieListItem(
              imageUrl: "https://image.tmdb.org/t/p/w500/${movie.posterPath}",
              name: movie.title,
              information: '${movie.releaseDate} | ${movie.voteAverage}',
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 150),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.headlineSmall,
              children: [
                TextSpan(
                  text: '你的观影记录：',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Column(children: listItems),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:tracker/utils/data_structure.dart';
// import '../utils/database.dart';
// import 'package:tracker/widgets/stats_MovieList.dart';
// import 'package:tracker/widgets/movie_page.dart';
// import 'package:get/get.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//   @override
//   //之后会有几个功能的分区，我先来负责一下
//   //我先嫖了一个其中一个的功能模板，
//   Widget build(BuildContext context) {
//     //List<SingleMovie> movies = getmovies();

//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 100,
//         backgroundColor: Colors.transparent,
//         elevation: 0.0,
//       ),
//       extendBodyBehindAppBar: true,
//       body: SingleChildScrollView(
//         child: FutureBuilder(
//           future: ProjectDatabase().gethistory() , 
//           builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
//             if(snapshot.hasError){
//               return const Icon(Icons.error, size:80);
//             }
//             if(snapshot.hasData){
//               return Container(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 150),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       RichText(
//                         text: TextSpan(
//                           style: Theme.of(context).textTheme.headlineSmall,
//                           children: [
//                             TextSpan(
//                               text: '你的观影记录：',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .titleLarge!
//                                   .copyWith(fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       // for (final movie in snapshot.data) 
//                       //   Padding(//左边空白加入日期
//                       //     padding: const EdgeInsets.only(left: 80.0),
//                       //     child: GestureDetector(
//                       //       // 点击就导航到MoviePage
//                       //       onTap: () async{
//                       //         Get.to(MoviePage(movie: movie), transition: Transition.fadeIn);
//                       //       },
                          
//                       //       child: MovieListItem(
//                       //         imageUrl: "https://image.tmdb.org/t/p/w500/${movie.posterPath}",
//                       //         name: movie.title,
//                       //         information: '${movie.releaseDate} | ${movie.voteAverage}',
//                       //       ),
//                       //     ),
//                       //   ),
                      
//                       Builder(
//                         builder: (BuildContext context) {
//                           String lastDate = '';
//                           List<Widget> listItems = [];
//                           for (final movie in snapshot.data) {
//                             // 处理日期格式
                            
                            


//                             String currentMonthYear = "${movie.releaseDate.split('-')[0]}-${movie.releaseDate.split('-')[1]}";
//                             // 如果当前电影的年月与上一个不同
//                             if (currentMonthYear != lastDate) {
//                               lastDate = currentMonthYear;
//                               // 添加年月标注，无左边距
//                               listItems.add(
//                                 Container(
//                                   alignment: Alignment.centerLeft,
//                                   padding: const EdgeInsets.only(top: 20, bottom: 10),
//                                   child: Text(
//                                     currentMonthYear,
//                                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black),
//                                   ),
//                                 ),
//                               );
//                             }
//                             listItems.add(
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 50),
//                                 child: GestureDetector(
//                                   onTap: () async {
//                                     Get.to(MoviePage(movie: movie), transition: Transition.fadeIn);
//                                   },
//                                   child: MovieListItem(
//                                     imageUrl: "https://image.tmdb.org/t/p/w500/${movie.posterPath}",
//                                     name: movie.title,
//                                     information: '${movie.runtime}分钟 | ${movie.voteAverage}',
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }
//                           return Column(children: listItems);
//                         },
//                       ),

//                     ],
//                   ),
//                 ),
//               );
//             }
//           return const CircularProgressIndicator();
//           }
//         ),
//       )  
//     );
//   }
// }


// class _CustomClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     double height = size.height;
//     double width = size.width;

//     var path = Path();

//     path.lineTo(0, height - 30);
//     path.quadraticBezierTo(width / 2, height*1.1, width, height - 30);
//     path.lineTo(width, 0);
//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return true;
//   }
// }


