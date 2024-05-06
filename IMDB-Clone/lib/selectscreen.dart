import 'package:flutter/material.dart';
import 'package:imdb_clone/screens/home.dart';
import 'package:imdb_clone/screens/profile.dart';
import 'package:imdb_clone/screens/search.dart';
import 'package:imdb_clone/utils/colors.dart';

class ScreenSelect extends StatefulWidget {
  const ScreenSelect({Key? key}) : super(key: key);

  @override
  State<ScreenSelect> createState() => _ScreenSelectState();
}

class _ScreenSelectState extends State<ScreenSelect> {
  int _currentIndex = 0;
  Map<String, dynamic> data = {};
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      const HomeScreen(),
      const SearchScreen(),
      ProfilePage(data: data),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Accessing the args
    final Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    setState(() {
      data = args;
      // updating profile screen
      screens = [
        const HomeScreen(),
        const SearchScreen(),
        ProfilePage(data: data),
      ];
    });
  }

  void onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(data);

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColor.darkorange,
        currentIndex: _currentIndex,
        onTap: (index) => onItemTapped(index),
        backgroundColor: AppColor.lightBlack,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(color: Colors.grey),
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.white10,
            icon: Icon(
              Icons.home,
              semanticLabel: "home",
            ),
            label: "home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              semanticLabel: "search",
            ),
            label: "search",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_rounded,
            ),
            label: "profile",
          )
        ],
      ),
    );
  }
}
