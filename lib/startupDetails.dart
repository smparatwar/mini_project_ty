import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package

class startupDetails extends StatefulWidget {
  final Map startup;

  startupDetails(this.startup);

  @override
  _startupDetailsState createState() => _startupDetailsState();
}

class _startupDetailsState extends State<startupDetails> {
  String userRole = '';

  @override
  void initState() {
    super.initState();
    // Retrieve user role from Firebase when the widget is initialized
    getUserRole();
  }

  Future<void> getUserRole() async {
    try {
      // Retrieve user document from Firestore
      String userId = FirebaseAuth.instance.currentUser!.email.toString();
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Get the user's role from the document
      if (userSnapshot.exists) {
        setState(() {
          userRole = userSnapshot['role'];
        });
      }
    } catch (e) {
      print('Error retrieving user role: $e');
    }
  }

  // Method to open WhatsApp with pre-filled message
  void _launchWhatsApp() async {
    // Assuming the number is fetched from Firebase or hardcoded
    String phoneNumber = "7588678651"; // Replace with your phone number

    // URL format for sending message on WhatsApp
    String url = "https://wa.me/$phoneNumber?text=Hello%20Startup!";

    // Launch URL using url_launcher package
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.startup['Name'].toString()),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Center(
              child: SizedBox(
                child: Image.network(
                  widget.startup['img'].toString(),
                  errorBuilder: (context, error, stackTrace) {
                    // If image loading fails, display a placeholder or error message
                    return Container(
                      color: Colors.blue, // Placeholder color
                      child: Icon(
                        Icons.image,
                        color: Colors.white, // Icon color
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.startup['description'].toString(),
                style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "About Company",
                  style: GoogleFonts.poppins(
                    textStyle:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text(widget.startup['longDescription'].toString()),
              ),
            ),
            // Conditionally display options based on user role
            if (userRole == 'investor')
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle invest button click
                    },
                    child: Text('Invest'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle chat with startup button click
                      _launchWhatsApp(); // Call method to open WhatsApp
                    },
                    child: Text('Chat with Startup'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
