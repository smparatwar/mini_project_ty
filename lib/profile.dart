import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  late String userEmail = '';
  late String userRole = '';
  late String startupName = ''; // Variable to store startup name

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
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
            userEmail = email;
            userRole = userDoc['role'];
          });
          // Fetch the startup name if available
          if (userDoc['startup'] != null) {
            DocumentSnapshot startupDoc = await FirebaseFirestore.instance
                .collection('startups')
                .doc(userDoc['startup'])
                .get();
            if (startupDoc.exists) {
              setState(() {
                // Set the startup name in the state
                startupName = startupDoc['name'];
              });
            }
          }
        } else {
          setState(() {
            userEmail = email;
            userRole = 'No Role';
          });
        }
      }
    } catch (e) {
      setState(() {
        userEmail = 'Error fetching email';
        userRole = 'Error fetching role';
      });
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
            ),
            Text(
              userEmail,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              userRole,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              startupName.isNotEmpty ? 'Startup: $startupName' : 'No Startup',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
