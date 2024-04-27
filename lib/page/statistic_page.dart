import 'package:flutter/material.dart';
import 'package:tracker/utils/database.dart';
import 'package:tracker/widgets/stats_MovieList.dart';


class StatisticPage extends StatelessWidget {
  const StatisticPage({super.key});
  

  @override
  //之后会有几个功能的分区，我先来负责一下
  //我先嫖了一个其中一个的功能模板，
  Widget build(BuildContext context) {
    //List<SingleMovie> movies = getmovies();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: _CustomClipper(),
          child: Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            color: const Color.fromARGB(255, 6, 9, 103),
            child: Center(
              child: Text(
                '美国🇺🇸',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: Future.value(ProjectDatabase().readAllLocal()),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
            if(snapshot.hasError){
              return const Icon(Icons.error, size:80);
            }
            if(snapshot.hasData){
              return Container(
                child: Padding(
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      for (final movie in snapshot.data) 
                        InkWell(
                          onTap: () {
                            print('a');
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => MovieScreen(movie: movie),
                            //   ),
                            // );
                          },
                          child: MovieListItem(
                            imageUrl: "https://image.tmdb.org/t/p/w500/${movie.posterPath}",
                            name: movie.title,
                            information: '${movie.releaseDate} | ${movie.voteAverage}',
                          ),
                        ),
                      
                    ],
                  ),
                ),
              );
            }
          return const CircularProgressIndicator();
          }
        ),
      )  
    );
  }
}

class _CustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;

    var path = Path();

    path.lineTo(0, height - 30);
    path.quadraticBezierTo(width / 2, height*1.1, width, height - 30);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}







//extract a widget
// class BigCard extends StatelessWidget {
//   const BigCard({
//     super.key,
//     required this.pair,
//   });

//   final WordPair pair;

//   @override
//   Widget build(BuildContext context) {
//     return Text(pair.asLowerCase);
//   }
// }


