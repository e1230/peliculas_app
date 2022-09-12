import 'package:flutter/material.dart';
import 'package:peliculas_app/models/now_playing_response.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> movies;
  final String titulo;
  final Function onNextPage;
  const MovieSlider(
      {Key? key,
      required this.movies,
      this.titulo = "",
      required this.onNextPage});

  @override
  _MovieSliderState createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController controller = new ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.pixels >=
          controller.position.maxScrollExtent - 500) {
        widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget tituloPadding() {
    if (this.widget.titulo == "") {
      return Container();
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          "${widget.titulo}",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //si no hay titulo, ocultar este widget
          tituloPadding(),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
                controller: controller,
                scrollDirection: Axis.horizontal,
                itemCount: widget.movies.length,
                itemBuilder: (_, int index) {
                  final movie = widget.movies[index];
                  return _MoviePoster(movie);
                }),
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;

  const _MoviePoster(this.movie);

  @override
  Widget build(BuildContext context) {
    movie.heroId = "slider-${movie.id}";

    return Container(
      width: 130,
      height: 190,
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, "details", arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage("assets/no-image.jpg"),
                  image: NetworkImage(movie.fullPosterImg),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
