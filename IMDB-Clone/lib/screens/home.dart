import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:imdb_clone/utils/colors.dart';
import '../reuseableWidgets/movieList.dart';

class HomeScreen extends StatelessWidget {
  final String? data;
  const HomeScreen({this.data, Key? key}) : super(key: key);

  // Fetching names asynchronously
  Future<List<String>> _fetchNames(String type) async {
    if (type == 'genfavourites') {
      // get movie collection
      CollectionReference movies =
          FirebaseFirestore.instance.collection('movies');
      List<Map<String, dynamic>> data = [];
      List<String> names = [];
      Query<Object?> movieQuery = movies;
      QuerySnapshot<Object?> response = await movieQuery.get();
      if (response.docs.isNotEmpty) {
        // get data
        for (int i = 0; i < response.docs.length; i++) {
          QueryDocumentSnapshot doc = response.docs[i];
          data.add(doc.data() as Map<String, dynamic>);
        }
        // Add title from data to names
        for (int i = 0; i < data.length; i++) {
          names.add(data[i]["title"]);
        }
        print(names);
        return names;
      } else {
        print("Shit is empty");
        return [];
      }
    } else {
      // get movie collection
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      DocumentReference<Object?> moviesRef = users.doc('b9MxNH1qiyrmbeNzn0C4');
      // Getting to the required type list
      CollectionReference movies = moviesRef.collection(type);
      List<Map<String, dynamic>> data = [];
      List<String> names = [];
      Query<Object?> movieQuery = movies;
      QuerySnapshot<Object?> response = await movieQuery.get();
      if (response.docs.isNotEmpty) {
        // get data
        for (int i = 0; i < response.docs.length; i++) {
          QueryDocumentSnapshot doc = response.docs[i];
          data.add(doc.data() as Map<String, dynamic>);
        }
        // Add title from data to names
        for (int i = 0; i < data.length; i++) {
          names.add(data[i]["title"]);
        }
        print(names);
        return names;
      } else {
        print("Shit is empty");
        return [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.maroonred,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 20,
              child: Container(
                color: Colors.black,
              ),
            ),
            Container(
              color: Colors.white10,
              padding: const EdgeInsets.only(
                //top: 30.0,
                bottom: 30.0,
              ),
              child: Column(
                children: [
                  Column(
                    // Featured Today Section
                    children: const [
                      Heading(title: "Featured today"),
                      FeaturedToday()
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white10,
              padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
              child: Column(
                children: [
                  const Heading(title: "What to watch"),
                  FutureBuilder<List<String>>(
                    future: _fetchNames('watchlist'),
                    builder: (context, snapshot) {
                      print(snapshot);
                      if (snapshot.hasData) {
                        return MovieTile(
                          title: "From your Watchlist",
                          description:
                              "Shows and movies available to watch from your watch list",
                          names: snapshot.data!,
                        );
                      } else {
                        return const Text("Nothing is here");
                      }
                    },
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white10,
              margin: const EdgeInsets.only(top: 15.0),
              padding: const EdgeInsets.only(bottom: 30.0),
              child: const MovieTile(
                title: "Top picks for you",
                description: "TV shows and movies just for you",
                names: [
                  "The God Father",
                  "Casablanca",
                  "The Batman",
                  "The Dark Knight",
                  "Citizen Kane",
                  "Schindler's List",
                  "Pulp Fiction",
                  "Titanic",
                  "Goodfellas"
                ],
              ),
            ),
            Container(
                color: Colors.white10,
                margin: const EdgeInsets.only(top: 10.0),
                padding: const EdgeInsets.only(bottom: 30.0),
                child: FutureBuilder<List<String>>(
                  future: _fetchNames('genfavourites'),
                  builder: (context, snapshot) {
                    print(snapshot);
                    if (snapshot.hasData) {
                      return MovieTile(
                        title: "Fan favourites",
                        description: "This week's top TV shows and movies",
                        names: snapshot.data!,
                      );
                    } else {
                      return const Text("Nothing is here");
                    }
                  },
                ))
          ],
        ),
      ),
    );
  }
}

class MovieTile extends StatelessWidget {
  final String title;
  final String description;
  final List<String> names;

  const MovieTile(
      {required this.title,
      required this.description,
      required this.names,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                        color: AppColor.darkorange,
                      ),
                      width: 5.0,
                      height: 20.0,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 13.0,
                      ),
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontSize: 20.0, color: Colors.white),
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
          margin: const EdgeInsets.only(top: 13.0, left: 8.0),
          width: double.infinity,
          child: Text(
            description,
            style: const TextStyle(fontSize: 15.0, color: Colors.grey),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: Row(
        //     children: const [
        //       SmallInfo(info1: "Movie", info2: "TV Series"),
        //       SmallInfo(
        //           info1: "Prime Video(Rent/Buy)", info2: "Other Providers"),
        //       SmallInfo(info1: "Drama", info2: "Adventure")
        //     ],
        //   ),
        // ),
        MovieList(
          names: names,
        ),
      ],
    );
  }
}

class SmallInfo extends StatelessWidget {
  const SmallInfo({required this.info1, required this.info2, super.key});

  final String info1;
  final String info2;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Row(
      children: [
        Container(
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20.0)),
          child: Row(
            children: [
              Text(
                info1,
                style: const TextStyle(color: Colors.grey),
              ),
              const VerticalDivider(
                color: Colors.grey,
                width: 21,
              ),
              Text(
                info2,
                style: const TextStyle(color: Colors.grey),
              )
            ],
          ),
        )
      ],
    ));
  }
}

class Heading extends StatelessWidget {
  const Heading({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: 500.0,
      height: 70.0,
      padding: const EdgeInsets.only(left: 10.0, top: 15.0, bottom: 20.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 27.0,
            color: AppColor.darkorange,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

class FeaturedToday extends StatelessWidget {
  const FeaturedToday({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const <Widget>[
          Inside(
            title: "The Best Movies and Series in January",
            image: "images/lostvshow.jpg",
          ),
          Inside(
            title: "Most anticipated shows in the summer",
            image: "images/lostvshow.jpg",
          ),
          Inside(
            title: "This year's oscar winners",
            image: "images/lostvshow.jpg",
          )
        ],
      ),
    );
  }
}

class Inside extends StatelessWidget {
  const Inside({required this.title, required this.image, super.key});

  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360.0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Image(
              image: ResizeImage(AssetImage(image), width: 400, height: 220),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
