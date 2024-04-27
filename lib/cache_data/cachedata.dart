import '../utils/data_structure.dart';
import '../utils/fetch_data.dart';

class cache_data {
  cache_data._init();
  static final cache_data _instance = cache_data._init();
  static cache_data getInstance(){
    return _instance;
  }
  late List<SingleMovie> MovieData;

  Future<void> initMovieData() async {
    MovieData = await fetchDiscoverData(1);
  }
}
