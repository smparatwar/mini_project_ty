import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project_ty/accelerator.dart';
import 'package:mini_project_ty/incubator.dart';
import 'package:mini_project_ty/investors.dart';
import 'package:mini_project_ty/login.dart';
import 'package:mini_project_ty/profile.dart';
import 'package:mini_project_ty/snippets/navigator.dart';
import 'package:mini_project_ty/snippets/widgets.dart';
import 'package:mini_project_ty/startupDetails.dart';
import 'package:mini_project_ty/startupList.dart';
import 'package:url_launcher/url_launcher.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  late String userRole = ''; // Define a variable to store the user's role

  @override
  void initState() {
    super.initState();
    fetchUserRole(); // Call the function to fetch the user's role when the widget initializes
  }

  Future<void> fetchUserRole() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String email = user.email!;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .get();
        if (userDoc.exists) {
          setState(() {
            userRole = userDoc['role'];
          });
        } else {
          setState(() {
            userRole = 'No Role';
          });
        }
      }
    } catch (e) {
      setState(() {
        userRole = 'Error fetching role';
      });
      print('Error fetching user role: $e');
    }
  }

  List ImgLinks = [
    "assets/casroul/0.jpg",
    "assets/casroul/1.png",
    "assets/casroul/2.jpg",
    "assets/casroul/4.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: UserAccountsDrawerHeader(
                accountName: FirebaseAuth.instance.currentUser != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            FirebaseAuth.instance.currentUser!.email.toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            userRole, // Display the user's role
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )
                    : InkWell(
                        onTap: () {
                          navi(context, login());
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 25),
                        )),
                accountEmail: Text(""),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              onTap: () {},
              title: Text("Home",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))),
            ),
            ListTile(
              onTap: () {
                navi(context, profile());
              },
              leading: Icon(Icons.person),
              title: Text("Profile",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))),
            ),
            ListTile(
              onTap: () {
                _launchUrl();
              },
              leading: Icon(Icons.info),
              title: Text("Resources",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))),
            ),
            ListTile(
              onTap: () async {
                // Check if the user is currently logged in
                if (FirebaseAuth.instance.currentUser != null) {
                  // If the user is logged in, sign them out
                  await FirebaseAuth.instance.signOut().then((value) {
                    // Navigate to the login screen after signing out
                    naviRep(context, login());
                  });
                }
              },
              leading: Icon(Icons.logout),
              title: Text("Logout",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {}); // Trigger a rebuild to refresh the data
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                    height: 200.0,
                    autoPlay: true,
                    autoPlayAnimationDuration: Duration(seconds: 5)),
                items: ImgLinks.map((relativePath) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: 350,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Image.asset(
                          relativePath, // Constructing the asset path using the relative path from the list
                          fit: BoxFit
                              .fitWidth, // Adjust this according to your needs
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      circle(context, "assets/startup.png", startupList()),
                      circle(context, "assets/investor.jpg", investor()),
                      circle(context, "assets/accelator.png", accelerator()),
                      circle(context, "assets/Incubator.jpg", incubator()),
                      // circle("assets/Government Agencies.jpg"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "StartUps",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Investors",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "Accelerators",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Text(
                        "Incubators",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Explore",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 950,
                  width: double.infinity,
                  
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('startup')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text('No data available'),
                        );
                      }
                      // Shuffle the list of documents to get random startups
                      final List<DocumentSnapshot> documents =
                          snapshot.data!.docs;
                      documents.shuffle();
                      // Take first two documents
                      final List<Widget> startupWidgets = documents
                          .sublist(0, min(3, documents.length))
                          .map((doc) => _buildStartupWidget(doc))
                          .toList();
                      return Column(
                        children: startupWidgets,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.orange,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "7+",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                      Text("Registrered StartUps to Our Portal",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartupWidget(DocumentSnapshot document) {
    final name = document['Name'];
    final description = document['description'];
    final imageUrl =
        document['img']; // Assuming the field name for image URL is 'imageUrl'

    return InkWell(
      onTap: () {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        print(data);
        navi(context, startupDetails(data));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl != null && Uri.parse(imageUrl).isAbsolute
                ? Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'No Image',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
            SizedBox(height: 8.0),
            Text(
              'Name: $name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.0),
            Text(
              'Description: $description',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/startup-54c87.appspot.com/o/SUIKIT.pdf?alt=media&token=87c1cbd3-570b-4bd2-9282-afe0dbc9c8c0"))) {
      throw Exception('Could not launch ');
    }
  }
}
