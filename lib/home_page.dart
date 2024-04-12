import 'package:flutter/material.dart';
import 'package:tracker/data_structure.dart';
import 'package:tracker/movie_page.dart';
import 'database.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<MyMedia> medias;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshMedias();
  }

  @override
  void dispose() {
    // MediaDatabase.instance.close();
    super.dispose();
  }

  Future refreshMedias() async {
    setState(() => isLoading = true);
    medias = await MediaDatabase.instance.readAllMedias();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : medias.isEmpty
                ? const Text(
                    'No Medias',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  )
                : ListView.builder(
                    itemCount: medias.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("tmdb ID:${medias[index].tmdbId}"),
                        subtitle: Text(medias[index].watchedDate.toString()),
                      );
                    },
                  ),
      ),
    );
  }
}
