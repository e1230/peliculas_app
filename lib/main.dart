import 'package:flutter/material.dart';
import 'package:peliculas_app/pages/pages.dart';
import 'package:peliculas_app/providers/movies_providers.dart';
import 'package:provider/provider.dart';

void main() => runApp(AppState());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App peliculas',
      initialRoute: "home",
      routes: {
        "home": (_) => HomePage(),
        "details": (_) => DetailsPage(),
      },
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(color: Colors.deepPurpleAccent),
      ),
    );
  }
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MoviesProvider(),
          lazy: false,
        )
      ],
      child: MyApp(),
    );
  }
}
