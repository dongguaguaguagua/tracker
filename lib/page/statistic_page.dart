import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tracker/utils/data_structure.dart';
import 'package:tracker/utils/database.dart';


class StatisticPage extends StatelessWidget {
  const StatisticPage({super.key});
  

  @override
  //之后会有几个功能的分区，我先来负责一下
  //我先嫖了一个其中一个的功能模板，
  Widget build(BuildContext context) {
    //List<SingleMovie> movies = getmovies();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 1000,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: _CustomClipper(),
          child: Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(255, 12, 77, 151),
            child: Center(
              child: Text(
                '日本🇯🇵',
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
                      text: '收藏的电影🎬',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: FutureBuilder(
                  future: Future.value(MediaDatabase.instance.readAllLocal()), 
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
                      if(snapshot.hasError){
                        return const Icon(Icons.error, size:80);
                      }
                      if(snapshot.hasData){
                        return Text('改成了futurebuilder');
                      }
                      return const CircularProgressIndicator();
                    } 
                  ),
              )


              // for (final movie in movies) MovieListItem(

              // )



            ],
          ),
        ),
      ),
    );
  }
}

class _CustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;

    var path = Path();

    path.lineTo(0, height - 50);
    path.quadraticBezierTo(width / 2, height, width, height - 50);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}






// Future<List<SingleMovie>> localmovies = MediaDatabase.instance.readAllLocal();



// ListView.builder(
//   itemCount: medias.length,
//   itemBuilder: (context, index) {
//     return ListTile(
//       title: Text("tmdb ID:${medias[index].tmdbId}"),
//       subtitle: Text(medias[index].watchedDate.toString()),
//     );
//   },
// ),