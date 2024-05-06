import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imdb_clone/secrets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = ''; // Input that the user types
  List<String> results = []; // List of thing that returns when the user types

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white10,
          actions: [
            Center(
              child: GestureDetector(
                onTap: () {
                  showSearch(context: context, delegate: TopicSearch());
                },
                child: Container(
                  width: 350,
                  height: 40,
                  margin: const EdgeInsets.only(right: 3.5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Center(
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.only(top: 0, left: 10),
                            child: const Icon(Icons.search_rounded,
                                color: Colors.black, size: 22)),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 0, left: 10),
                          child: Text(
                            "Search IMDb",
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[900]),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Search Container
              Container(
                color: Colors.white10,
                child: const DisplayMovieInfo(),
              )
            ],
          ),
        ));
  }
}

class TopicSearch extends SearchDelegate<String> {
  // Array of recent media
  final recentMedia = ['Violet Evergarden', 'To LOVE-Ru', 'Chainsaw Man'];
  // Array of all media
  final media = ['Sound! Euphonium', 'Clannad: After Story', 'Ergo Proxy'];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      GestureDetector(
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            child: const Text("CANCEL",
                style: TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold))),
        onTap: () {
          close(context, "");
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(onPressed: () {}, icon: const Icon(Icons.search));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    if (query.isEmpty) {
      return Container(
        color: Colors.black,
      );
    } else {
      return Container(
          color: Colors.black,
          child: FutureBuilder(
              future: fetchSearchResults(query),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  final searchResults = snapshot.data as List<dynamic>;
                  return buildSuggestionsSuccess(searchResults);
                }
              }));
    }
  }

  Future<List<dynamic>> fetchSearchResults(String query) async {
    final response = await http.get(
        Uri.parse("http://www.omdbapi.com/?s=${query}&&apikey=${API_KEY}"));
    if (response.statusCode == 200) {
      final resultsJson = await jsonDecode(response.body)['Search'];
      final titles = [];
      print(resultsJson.runtimeType);
      try {
        for (int i = 0; i < resultsJson.length; i++) {
          titles.add(resultsJson[i]["Title"]);
        }
        return titles;
      } catch (e) {
        throw Exception("Couldn't find anything :(");
      }
    } else {
      throw Exception("Failed to fetch data");
    }
  }

  Future<List> fetchTypeOfSearch(suggestion) async {
    final response = await http.get(Uri.parse(
        "http://www.omdbapi.com/?t=${suggestion}&&apikey=${API_KEY}"));
    if (response.statusCode == 200) {
      final resultsJson = await jsonDecode(response.body);
      print(resultsJson.runtimeType);
      final type = [];
      type.add(
          "${resultsJson["Type"]}" " " "${resultsJson["Year"].toString()}");
      type.add(resultsJson["Poster"]);
      return type;
    } else {
      print("dead");
      return [];
    }
  }

  Widget buildSuggestionsSuccess(List<dynamic> suggestions) {
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return Container(
            color: Colors.black,
            child: FutureBuilder(
              future: fetchTypeOfSearch(suggestion),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final type = snapshot.data;
                  return SizedBox(
                    height: 100,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/mediainfo',
                              arguments: {"name": suggestion});
                        },
                        child: ListTile(
                            leading: Image.network(type![1]),
                            title: Text(suggestion,
                                style: const TextStyle(color: Colors.white)),
                            subtitle: Text(type[0],
                                style: const TextStyle(color: Colors.grey)))),
                  );
                } else {
                  return ListTile(
                    leading: const Icon(Icons.local_movies),
                    title: Text(suggestion),
                  );
                }
              },
            ));
      },
    );
  }
}

class DisplayMovieInfo extends StatelessWidget {
  const DisplayMovieInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          padding: const EdgeInsets.only(top: 20.0),
          decoration: const BoxDecoration(color: Colors.black),
          child: Column(
            children: const [
              // Movies Heading
              Heading(text: "Movies", icon: Icons.local_movies_sharp),
              // Movie List
              DisplayMovieRow(
                  title1: "Popular movie Trailers", title2: "Recent Movies"),
              DisplayMovieRow(
                  title1: "Movie showtimes", title2: "Top box office"),
              DisplayMovieRow(
                  title1: "Top 250 movies", title2: "Most popular movies"),
              DisplayMovieRow(
                  title1: "Comming soon in theaters",
                  title2: "Most popular by genre"),
            ],
          )),
      Container(
          decoration: const BoxDecoration(color: Colors.black),
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: const [
              // Streaming and tv
              Heading(text: "Streaming and TV", icon: Icons.tv),
              // Movie List
              DisplayMovieRow(
                  title1: "Popular TV trailers", title2: "Recent TV trailers"),
              DisplayMovieRow(
                  title1: "Top 250 TV shows", title2: "Most popular TV shows"),
              DisplayMovieRow(
                  title1: "Most popular by genre",
                  title2: "Watch soon at home"),
            ],
          ))
    ]);
  }
}

class Heading extends StatelessWidget {
  final String text;
  final IconData icon;
  const Heading({required this.text, required this.icon, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10, left: 20),
        child: Row(
          children: [
            Icon(icon, color: Colors.yellowAccent, size: 25.0),
            Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  text,
                  style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ))
          ],
        ));
  }
}

class DisplayMovieRow extends StatelessWidget {
  final String title1;
  final String title2;

  const DisplayMovieRow({required this.title1, required this.title2, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 0, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [TopicItem(title: title1), TopicItem(title: title2)],
        ));
  }
}

class TopicItem extends StatelessWidget {
  const TopicItem({
    required this.title,
    super.key,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 170,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      margin: const EdgeInsets.only(top: 30.0),
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0),
      child: Column(
        children: [
          Container(
            width: 150,
            height: 100,
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            /* child: Center(
                  child: Text(title, style: const TextStyle(color: Colors.blue, fontSize: 17.0)),
              ), */
            child: const ImagesView(images: [
              // Batman
              "https://m.media-amazon.com/images/M/MV5BMDdmMTBiNTYtMDIzNi00NGVlLWIzMDYtZTk3MTQ3NGQxZGEwXkEyXkFqcGdeQXVyMzMwOTU5MDk@._V1_SX300.jpg",
              // Steins Gate
              "https://m.media-amazon.com/images/M/MV5BMjUxMzE4ZDctODNjMS00MzIwLThjNDktODkwYjc5YWU0MDc0XkEyXkFqcGdeQXVyNjc3OTE4Nzk@._V1_SX300.jpg",
              // Silicon Valley
              "https://m.media-amazon.com/images/M/MV5BM2Q5YjNjZWMtYThmYy00N2ZjLWE2NDctNmZjMmZjYWE2NjEwXkEyXkFqcGdeQXVyMTAzMDM4MjM0._V1_SX300.jpg"
            ]),
          ),
          Column(children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 9.0,
                top: 10.0,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class ImagesView extends StatelessWidget {
  final List<String> images;
  const ImagesView({required this.images, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.darken),
          child: Container(
            margin: const EdgeInsets.only(left: 75),
            child:
                Image(width: 200, height: 150, image: NetworkImage(images[0])),
          ),
        ),
        ColorFiltered(
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
          child: Container(
            margin: const EdgeInsets.all(0),
            child:
                Image(width: 200, height: 150, image: NetworkImage(images[1])),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 70),
          child: Image(width: 200, height: 150, image: NetworkImage(images[2])),
        )
      ],
    );
  }
}
