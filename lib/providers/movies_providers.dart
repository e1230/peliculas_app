import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_app/helper/debouncer.dart';
import 'package:peliculas_app/models/credits_response.dart';
import 'package:peliculas_app/models/now_playing_response.dart';
import 'package:peliculas_app/models/popular_responde.dart';
import 'package:peliculas_app/models/search_movie_response.dart';

class MoviesProvider extends ChangeNotifier {
  String _apikey = "3a3c7b75b690ebfed1847cae478846ed";
  String _baseUrl = "api.themoviedb.org";
  String _lang = "es-ES";

  List<Movie> onDisplaymovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> moviesCast = {};
  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
  );
  final StreamController<List<Movie>> _suggestion =
      StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream => this._suggestion.stream;
  MoviesProvider() {
    this.getNowPlayMovies();
    this.getPopularMovies();
  }

  Future<String> _getJasonData(String endpoint, [int page = 1]) async {
    var url = Uri.https(
      _baseUrl,
      endpoint,
      {"api_key": _apikey, "language": _lang, "page": "$page"},
    );

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  getNowPlayMovies() async {
    final jsonData = await this._getJasonData('3/movie/now_playing');
    final respuesta = NowPlayingResponse.fromJson(jsonData);

    onDisplaymovies = respuesta.results;

    notifyListeners(); //todos los widgets que escuchan el cambio, hacen el cambio automaticamente
  }

  getPopularMovies() async {
    _popularPage++;
    final jsonData = await this._getJasonData('3/movie/popular', 1);
    final popularRespuesta = PopularResponde.fromJson(jsonData);

    popularMovies = [...popularMovies, ...popularRespuesta.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) {
      return moviesCast[movieId]!;
    }
    ;
    final jsonData = await this._getJasonData("3/movie/$movieId/credits");
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(
      _baseUrl,
      "3/search/movie",
      {"api_key": _apikey, "language": _lang, "query": query},
    );
    final response = await http.get(url);
    final searchResponse = SearchMovieResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionByQuery(String searchTerm) {
    //aqui escucha las teclas que se presionan
    debouncer.value = " ";
    debouncer.onValue = (value) async {
      final results = await this.searchMovies(value);
      this._suggestion.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
