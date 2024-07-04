import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mini_project_ty/registration.dart';
import 'package:mini_project_ty/home.dart'; // Import the homepage

class login extends StatelessWidget {
  login({Key? key}) : super(key: key);

  Duration get loginTime => const Duration(milliseconds: 2250);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        '385740018339-olboon0ala5ursffcaq8ff080vss610j.apps.googleusercontent.com',
  );

  Future<String?> _signupUser(SignupData data) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: data.name.toString(),
        password: data.password.toString(),
      );

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> _loginUser(LoginData data) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        return user;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> _handleGoogleSignIn() async {
    final User? user = await _signInWithGoogle();
    if (user != null) {
      // Successfully signed in with Google
      return null;
    } else {
      // Handle sign-in failure
      print(user);
      return 'Failed to SignIn through Google';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'StartUp Portal',
      onSignup: (data) async {
        await _signupUser(data); // Call the signup function
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => registration()),
        );
        return null;
      },
      onLogin: (data) async {
        await _loginUser(data); // Call the login function
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => homePage()),
        );
        return null;
      },
      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: _handleGoogleSignIn,
        ),
      ],
      onSubmitAnimationCompleted: () async {
        // Navigate to the homepage after successful login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => homePage()),
        );
      },
      onRecoverPassword: (String) {
        // Implement password recovery logic here
      },
    );
  }
}
