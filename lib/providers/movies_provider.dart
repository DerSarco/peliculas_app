import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseurl = 'api.themoviedb.org';
  final String _apikey = '9932f094813e0911919be3ab35a8cba5';
  final String _language = 'es-MX';
  List<Movie> onDisplayMovies = [];
  List<Movie> onPopularMovies = [];
  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  MoviesProvider() {
    print('Movies Provider initialized');
    getOnDisplayMovies();
    getOnPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int? page = 1]) async {
    print('getOnDisplayMovies');
    var url = Uri.https(_baseurl, endpoint,
        {'api_key': _apikey, 'language': _language, 'page': '$page'});
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('/3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getOnPopularMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData('/3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
    onPopularMovies = [...onPopularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    //ToDO revisar el mapa
    print("pidiendo info al servidor - cast");

    if (moviesCast[movieId] != null) {

      print("data en persistencia");
      return moviesCast[movieId]!;
    }

    final jsonData =
        await _getJsonData('/3/movie/${movieId}/credits', _popularPage);
    final creditsResponse = MovieCreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }
}
