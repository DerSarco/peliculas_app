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

  MoviesProvider() {
    print('Movies Provider initialized');
    getOnDisplayMovies();
    getOnPopularMovies();
  }


  getOnDisplayMovies() async {
    print('getOnDisplayMovies');
    var url =
    Uri.https(_baseurl, '/3/movie/now_playing', {'api_key': _apikey, 'language': _language, 'page': '1'});
    final response = await http.get(url);
    final nowPlayingResponse = NowPlayingResponse.fromJson(response.body);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getOnPopularMovies() async {
    print('getOnPopularMovies');
    var url =
    Uri.https(_baseurl, '/3/movie/popular', {'api_key': _apikey, 'language': _language, 'page': '1'});
    final response = await http.get(url);
    final popularResponse = PopularResponse.fromJson(response.body);
    onPopularMovies = [...onPopularMovies, ...popularResponse.results];
    print(onPopularMovies);
    notifyListeners();
  }

}