import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project_ty/home.dart';
import 'package:mini_project_ty/investorRegister.dart';
import 'package:mini_project_ty/snippets/navigator.dart';
import 'package:mini_project_ty/startupRegister.dart';

class registration extends StatefulWidget {
  @override
  State<registration> createState() => _registrationState();
}

class _registrationState extends State<registration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Text(
              "Register As ?",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                splashColor: Colors.blue,
                onTap: () {
                  String email =
                      FirebaseAuth.instance.currentUser!.email.toString();
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(email)
                      .set({'email': email, 'role': 'startup'}).then((value) {
                    navi(context, startupRegistration());
                  });
                },
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: ListTile(
                    title: Text("StartUp"),
                    titleTextStyle: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    subtitle: Text("StartUp can Access All the Features"),
                    subtitleTextStyle: GoogleFonts.brawler(
                        textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    trailing: Icon(
                      Icons.arrow_forward,
                      size: 35,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                splashColor: Colors.blue,
                onTap: () {
                  navi(context, InvestorRegistrationForm());
                },
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: ListTile(
                    title: Text("Invester"),
                    titleTextStyle: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    subtitle:
                        Text("Get Oppurtunities to Invest in Various Startups"),
                    subtitleTextStyle: GoogleFonts.brawler(
                        textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    trailing: Icon(
                      Icons.arrow_forward,
                      size: 35,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                splashColor: Colors.blue,
                onTap: () {
                  navi(context, homePage());
                },
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: ListTile(
                    title: Text("Accelerator"),
                    titleTextStyle: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    subtitle: Text("Accelerate the Startups"),
                    subtitleTextStyle: GoogleFonts.brawler(
                        textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    trailing: Icon(
                      Icons.arrow_forward,
                      size: 35,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                splashColor: Colors.blue,
                onTap: () {
                  navi(context, homePage());
                },
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: ListTile(
                    title: Text("Incubator"),
                    titleTextStyle: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    subtitle: Text("Incubate the Startups"),
                    subtitleTextStyle: GoogleFonts.brawler(
                        textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    trailing: Icon(
                      Icons.arrow_forward,
                      size: 35,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                splashColor: Colors.blue,
                onTap: () {
                  navi(context, homePage());
                },
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: ListTile(
                    title: Text("Public User"),
                    titleTextStyle: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    subtitle: Text("Explore Startups"),
                    subtitleTextStyle: GoogleFonts.brawler(
                        textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    trailing: Icon(
                      Icons.arrow_forward,
                      size: 35,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
