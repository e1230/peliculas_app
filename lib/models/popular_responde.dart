// To parse this JSON data, do
//
//     final popularResponde = popularRespondeFromMap(jsonString);

import 'dart:convert';

import 'now_playing_response.dart';

class PopularResponde {
  PopularResponde({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

  factory PopularResponde.fromJson(String str) =>
      PopularResponde.fromMap(json.decode(str));

  factory PopularResponde.fromMap(Map<String, dynamic> json) => PopularResponde(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}
