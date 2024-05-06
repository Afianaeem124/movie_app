import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imdb_clone/screens/home.dart';
import 'package:imdb_clone/secrets.dart';

class MovieItem extends StatefulWidget {
  const MovieItem({required this.name,
    required this.link,
    required this.rating,
    required this.year,
    required this.age,
    required this.time,
    super.key});

  final String name;
  final String link;
  final String rating;
  final String year;
  final String age;
  final String time;

  @override
  State<MovieItem> createState() => _MovieItemState();
}

class _MovieItemState extends State<MovieItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Clicked");
        setState(() {
          Navigator.pushNamed(context, '/mediainfo', arguments: {"name": widget.name});
        });
      },
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 5.0)],
          ),
          width: 150,
          height: 350,
          margin: const EdgeInsets.only(
            left: 12.0,
          ),
          // padding: const EdgeInsets.only(left: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(
                  image: ResizeImage(
                    NetworkImage(widget.link),
                    width: 150,
                    height: 190,
                  )),
              SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 4),
                        margin: const EdgeInsets.only(top: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.yellow, size: 14.0),
                            Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: Text(
                                  widget.rating,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                  ),
                                )
                            )
                          ],
                          ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 12, left: 8),
                        child: Text(
                          widget.name,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15, left: 8),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.year,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                widget.age,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: Text(
                                widget.time,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.only(top: 8.0,  bottom: 8.0),
                          margin: const EdgeInsets.only(top: 12.0, left: 5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blueGrey,
                              )),
                          child: const Text(
                            "Watch options",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          )),
    );
  }
}

class MovieList extends StatefulWidget {
  final List<String> names;
  const MovieList({super.key, required this.names});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  var _movies = [];

  // Array where ids of the individual movie would be stored
  List<String> ids = [

  ];  
  
  @override
  void initState() {
    // similar to useEffect. Using this to run callApi
    super.initState();
    callApi();
  }

  Future<void> callApi() async {
    // Names of Critically Acclaimed Movies. Will remove this later.
    List<String> names = widget.names;

    // Store all the ids of the movies
    for (int i = 0; i < names.length; i++) {
        String url = "http://www.omdbapi.com/?s=${names[i]}&&apikey=${API_KEY}";
        try {
          final response = await http.get(Uri.parse((url)));
          final result = jsonDecode(response.body);
          setState(() {
              ids.add(result["Search"][0]["imdbID"]);
          });
        } catch(e) {
          print(e);
        }
    }

    // Using those ids for detailed info on the movies
    for (int i = 0; i < ids.length; i++) {
      String url = "http://www.omdbapi.com/?i=${ids[i]}&&apikey=${API_KEY}";

      try {
        final response = await http.get(Uri.parse(url));
        final result = jsonDecode(response.body);
        setState(() {
          _movies.add(result);
        });
      } catch (e) {
        print(e);
      }
    }

    if (_movies.isEmpty) {
        print("Empty");
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < _movies.length; i++)
            MovieItem(
                name: _movies[i]["Title"],
                link: _movies[i]["Poster"],
                rating: _movies[i]["imdbRating"],
                year: _movies[i]["Year"].toString(),
                age: _movies[i]["Rated"],
                time: _movies[i]["Runtime"]
            )
        ],
      ),
    );
  }
}

class Watchlist extends StatefulWidget {
  const Watchlist({Key? key}) : super(key: key);

  @override
  State<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  var _movies;

  // Get collection movies/watchlist
  CollectionReference movies = FirebaseFirestore.instance.collection("movies");

  Query<Object?> getMovies() {
    return movies.where('user', isEqualTo: "Abhinav"); // retrieve user movies
  }

  @override
  void initState() {
   super.initState();
    // gets the movies from the call and sets it in the state variable _movies
   setState(() {
     _movies = getMovies();
   });
    print(_movies);
 }

 @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
        children: [
        for (int i = 0; i < 10; i++)
    MovieItem(
        name: _movies[i]["title"],
        link: _movies[i]["image"],
        rating: _movies[i]["rating"],
        year: _movies[i]["year"].toString(),
        age: "PG-13",
        time: "2hrs"),
    ],
    ),
    );
  }
}
