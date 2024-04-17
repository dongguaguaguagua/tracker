import '../utils/data_structure.dart';
import '../utils/fetch_data.dart';

class cache_data {
  cache_data._init();
  static final instance = cache_data._init();
  late List<SingleMovie> MovieData;

  Future<void> init_movie_data() async {
    MovieData = await fetchDiscoverData(1);
  }
}
