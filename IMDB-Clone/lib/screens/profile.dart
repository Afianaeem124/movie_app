import "package:flutter/material.dart";
import "package:imdb_clone/screens/home.dart";
import "package:imdb_clone/utils/colors.dart";

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic>? data;
  const ProfilePage({this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.maroonred,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            UserInfo(data: data),
            const ListsAndReviews(),
            Container(
              // margin: const EdgeInsets.only(top: 20.0),
              color: Colors.white10,
              padding: const EdgeInsets.only(),
              child: Column(
                children: const [
                  MovieTile(
                    title: "Your Watchlist",
                    description: "",
                    names: [
                      "The God Father",
                      "Casablanca",
                      "The Dark Knight",
                      "Citizen Kane",
                      "Schindler's List",
                      "Pulp Fiction",
                      "Titanic",
                      "Goodfellas"
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              color: Colors.white10,
              padding: const EdgeInsets.only(),
              child: Column(
                children: const [
                  MovieTile(
                    title: "Recently Viewed",
                    description: "",
                    names: [
                      "The Godfather",
                      "Casablanca",
                      "The Dark Knight",
                      "Citizen Kane",
                      "Schindler's List",
                      "Pulp Fiction",
                      "Titanic",
                      "Goodfellas"
                    ],
                  )
                ],
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.only(top: 20.0),
            //   child: const UselessInfo(
            //       info: "Favourites Threads", doShowNumber: true),
            // ),
            // const UselessInfo(info: "Check-Ins", doShowNumber: true),
            // const UselessInfo(info: "Notification", doShowNumber: true),
          ],
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  final Map<String, dynamic>? data;
  const UserInfo({this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 40.0, left: 20.0),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
              ),
            ),
            Container(
                padding: const EdgeInsets.only(top: 40.0, left: 20.0),
                child: Text(
                  (data!['user'] == null) ? "null" : data!['user'],
                  style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ))
          ],
        ),
        // Container(
        //   padding: const EdgeInsets.only(top: 60.0, right: 20.0),
        //   child: const Icon(
        //     Icons.settings,
        //     color: Colors.white,
        //   ),
        // ),
      ],
    );
  }
}

class ListAndReviewItem extends StatelessWidget {
  const ListAndReviewItem({
    required this.title,
    super.key,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      margin: const EdgeInsets.only(left: 20.0, top: 30.0),
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0),
      child: Column(
        children: [
          Container(
              width: 180,
              height: 120,
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: Center(
                  child: Text("Create a $title",
                      style: const TextStyle(
                          color: Colors.blue, fontSize: 17.0)))),
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
            Container(
              padding: const EdgeInsets.only(
                left: 9.0,
                top: 5.0,
              ),
              width: double.infinity,
              child: const Text(
                "0",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class ListsAndReviews extends StatelessWidget {
  const ListsAndReviews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          ListAndReviewItem(title: "Rating"),
          ListAndReviewItem(title: "Lists"),
          ListAndReviewItem(title: "Review"),
        ],
      ),
    );
  }
}

// class UselessInfo extends StatelessWidget {
//   const UselessInfo({
//     required this.info,
//     required this.doShowNumber,
//     super.key,
//   });

//   final String info;
//   final bool doShowNumber;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         margin: const EdgeInsets.only(top: 2.0),
//         padding: const EdgeInsets.only(
//             top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
//         height: 56.0,
//         width: double.infinity,
//         color: Colors.grey[900],
//         child: Row(
//           children: [
//             Text(
//               info,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16.0,
//               ),
//             ),
//             const Spacer(),
//             const Text("0",
//                 style: TextStyle(
//                   color: Colors.grey,
//                 ))
//           ],
//         ));
//   }
// }
