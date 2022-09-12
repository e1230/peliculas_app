import 'package:flutter/material.dart';
import 'package:peliculas_app/providers/movies_providers.dart';
import 'package:peliculas_app/search/search_delegate.dart';
import 'package:peliculas_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Peliculas en cines"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () =>
                showSearch(context: context, delegate: MovieSearchDelegate()),
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //tarjetas principales
            CardSwiper(
              movies: moviesProvider.onDisplaymovies,
            ),
            // slider peliculas
            MovieSlider(
              movies: moviesProvider.popularMovies,
              titulo: "Populares!",
              onNextPage: () => moviesProvider.getPopularMovies(), //opcional
            ),
          ],
        ),
      ),
    );
  }
}
