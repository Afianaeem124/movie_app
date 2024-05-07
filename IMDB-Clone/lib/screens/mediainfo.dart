import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imdb_clone/screens/secrets.dart';


class MediaInfo extends StatelessWidget {
  const MediaInfo({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> getMovieDetails(String name) async {
    String uri = "http://www.omdbapi.com/?t=${name}&&apikey=${API_KEY}";
    final response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print(result);
      print(result['Genre'].runtimeType);
      List<String> genreList = generateGenreList(result['Genre']);
      result['Genre'] = genreList;
      print(result['Genre']);
      print(result['Genre'].runtimeType);
      return result;
    }
    return {};
  }

  List<String> generateGenreList(String genreString) {
    return genreString.split(', ');
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print(args);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text(args["name"]),
      ),
      body: FutureBuilder(
        future: getMovieDetails(args["name"]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return DisplayMediaInfo(
                data: snapshot.data as Map<String, dynamic>);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class DisplayMediaInfo extends StatelessWidget {
  final Map<String, dynamic> data;
  const DisplayMediaInfo({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Name section
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10, left: 18),
            child: Text(
              (data["Title"] == null) ? "Bad" : data["Title"],
              style: const TextStyle(color: Colors.white, fontSize: 40),
              textAlign: TextAlign.start,
            ),
          ),
          // Rating, year and run time
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  (data["Year"] == null) ? "Bad" : data["Year"],
                  style: const TextStyle(color: Colors.grey, fontSize: 17),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 13),
                child: Text(
                  (data["Rated"] == null) ? "Bad" : data["Rated"],
                  style: const TextStyle(color: Colors.grey, fontSize: 17),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 13),
                child: Text(
                  (data["Runtime"] == null) ? "Bad" : data["Runtime"],
                  style: const TextStyle(color: Colors.grey, fontSize: 17),
                ),
              ),
            ],
          ),
          // Poster, Genres and Description
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: Image(
                    image: NetworkImage(
                        (data["Poster"] == null) ? "" : data["Poster"]),
                    width: 110),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (int i = 0;
                                    i <
                                        ((data['Genre'] == null)
                                            ? 0
                                            : data['Genre'].length);
                                    i++)
                                  Container(
                                      width: 75,
                                      height: 30,
                                      margin: const EdgeInsets.only(
                                          left: 4, bottom: 20, right: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                          child: Text(
                                        data['Genre'][i],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )))
                              ],
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              (data["Plot"] == null) ? "" : data["Plot"],
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
          //  Container(
          //      width: 356,
          //      height: 50,
          //      margin: const EdgeInsets.only(top: 19),
          //      decoration: const BoxDecoration(
          //          color: Colors.yellow,
          //          borderRadius: BorderRadius.all(Radius.circular(5))
          //      ),
          //      padding: const EdgeInsets.only(left: 5, top: 5),
          //      child: Row(
          //        children: [
          //          const Icon(Icons.play_circle_outline_outlined, size: 26, color: Colors.black,),
          //          Container(
          //              margin: const EdgeInsets.only(left: 10),
          //              child: const Text("Watch now", style: TextStyle(color: Colors.black, fontSize: 18),)
          //          )
          //        ],
          //      )
          //  ),
          // Container(
          //     width: 356,
          //     height: 50,
          //     margin: const EdgeInsets.only(top: 10),
          //     decoration: const BoxDecoration(
          //         color: Colors.white24,
          //         borderRadius: BorderRadius.all(Radius.circular(5))),
          //     padding: const EdgeInsets.only(left: 5, top: 5),
          //     child: Row(
          //       children: [
          //         const Icon(
          //           Icons.add,
          //           size: 26,
          //           color: Colors.white,
          //         ),
          //         Container(
          //             margin: const EdgeInsets.only(left: 10),
          //             child: const Text(
          //               "Add to Watchlist",
          //               style: TextStyle(color: Colors.white, fontSize: 18),
          //             ))
          //       ],
          //     )),
          const SizedBox(
            height: 40,
            child: Divider(color: Colors.white60),
          ),
          SizedBox(
            width: 300,
            height: 150,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    const Icon(Icons.star, color: Colors.yellow, size: 25),
                    Row(
                      children: [
                        Text(
                            "${(data['imdbRating'] == null) ? 0 : data['imdbRating']}",
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const Text("/10",
                            style: TextStyle(fontSize: 23, color: Colors.white))
                      ],
                    ),
                    Text(
                      "${(int.parse(((data['imdbVotes'] == null) ? 0 : data['imdbVotes']).replaceAll(",", "")) / 1000000).toStringAsFixed(1)}M",
                      style: TextStyle(color: Colors.white),
                    )
                  ]),
                  Column(children: [
                    const Icon(
                      Icons.star,
                      color: Colors.blue,
                      size: 25,
                    ),
                    Row(
                      children: const [
                        Text("9",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text("/10",
                            style: TextStyle(fontSize: 23, color: Colors.white))
                      ],
                    ),
                    const Text(
                      "Your rating",
                      style: TextStyle(color: Colors.white),
                    )
                  ]),
                  Column(children: [
                    Container(
                        width: 29,
                        height: 26,
                        margin: const EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(color: Colors.green),
                        child: Text(
                            "${(data["Metascore"] == null) ? 0 : data["Metascore"]}",
                            style: const TextStyle(
                                fontSize: 25, color: Colors.white))),
                    const Text("Metascore",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    const Text("36 critics",
                        style: TextStyle(color: Colors.white))
                  ]),
                ]),
          ),
          CastSection(
              cast: (data["Actors"] == null) ? "" : data["Actors"],
              directors: (data["Director"] == null) ? "" : data["Director"],
              writers: (data["Writer"] == null) ? "" : data["Writer"])
        ],
      ),
    );
  }
}

class CastSection extends StatelessWidget {
  final dynamic cast;
  final dynamic directors;
  final dynamic writers;

  const CastSection(
      {required this.cast,
      required this.directors,
      required this.writers,
      super.key});

  Widget createTitle(name) {
    return Container(
        margin: const EdgeInsets.only(left: 10, bottom: 5),
        width: double.infinity,
        child: Text(
          name,
          style: const TextStyle(fontSize: 15, color: Colors.white),
          textAlign: TextAlign.start,
        ));
  }

  Widget createPeople(names) {
    return Container(
        margin: const EdgeInsets.only(left: 10, bottom: 10),
        width: double.infinity,
        child: Text(names,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.start));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white12,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.amberAccent,
                          ),
                          width: 5.0,
                          height: 20.0,
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 13.0,
                          ),
                          child: const Text(
                            "Cast",
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.only(right: 10.0),
                  //   child: const Text(
                  //     "SEE ALL",
                  //     style: TextStyle(
                  //         fontSize: 15.0,
                  //         color: Colors.blue,
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  // )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 16.0, left: 10.0),
              child: const Text(
                "TOP BILLED CAST",
                style: TextStyle(fontSize: 15.0, color: Colors.yellow),
                textAlign: TextAlign.start,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 15),
                    child: Column(
                      children: [createTitle("Actors"), createPeople(cast)],
                    )),
                Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        createTitle("Directors"),
                        createPeople(directors)
                      ],
                    )),
                Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [createTitle("Writers"), createPeople(writers)],
                    )),
              ],
            )
          ],
        ));
  }
}
