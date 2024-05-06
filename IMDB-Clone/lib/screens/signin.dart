import 'dart:convert';

import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imdb_clone/screens/profile.dart';
import 'package:imdb_clone/utils/colors.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: const Header(),
        centerTitle: true,
      ),
      body: const Body(),
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Image(
        image: ResizeImage(AssetImage("logos/play.png"), width: 75, height: 55),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // Current State Variables
  final _formKey = GlobalKey<FormState>();

  dynamic _email;
  dynamic _password;

  // get users collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Query<Object?> findUser() {
    // Create a query for email and password login
    return users
        .where('email', isEqualTo: _email)
        .where('password', isEqualTo: _password);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.only(left: 15.0),
              child: const Text(
                "Welcome back",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 27.0),
              ),
            ),

            // SIGN UP SECTION

            // EMAIL ADDRESS SECTION
            Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2)),
                  labelText: "Your email address",
                  labelStyle: TextStyle(color: Colors.grey),
                ),
                onSaved: (value) {
                  _email = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter your email ";
                  }
                  return null;
                },
                style: const TextStyle(color: Colors.black),
              ),
            ),

            // PASSWORD SECTION
            Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2)),
                  labelText: "Enter password",
                  labelStyle: TextStyle(color: Colors.grey),
                ),
                onSaved: (value) {
                  _password = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter a Password";
                  }
                  return null;
                },
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // LOGIN BUTTON SECTION
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() != null) {
                  _formKey.currentState?.save();
                  print(_password);
                  print(_email);
                  // Retrieving the userQuery
                  Query userQuery = findUser();
                  userQuery.get().then((response) {
                    if (response.docs.isNotEmpty) {
                      // Printing the response data
                      List<Map<String, dynamic>> data = [];
                      response.docs.forEach((doc) {
                        data.add(doc.data() as Map<String, dynamic>);
                        print(data);
                      });
                      // If the response is not empty it goes to home page
                      setState(() {
                        Navigator.pushNamed(context, '/screens',
                            arguments: data[
                                0] // Passing the data about user (As data would be different for each user) as an argument
                            );
                      });
                    }
                  });
                }
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColor.bloodred),
              ),
              child: const Text("Login", style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey),
                ),
                child: const Text(
                  "Create a new IMDb account",
                  style: TextStyle(color: Colors.black),
                ))
          ],
        ));
  }
}
