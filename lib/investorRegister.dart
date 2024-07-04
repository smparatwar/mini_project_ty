import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_ty/home.dart';
import 'package:mini_project_ty/snippets/navigator.dart';

class InvestorRegistrationForm extends StatefulWidget {
  const InvestorRegistrationForm({Key? key}) : super(key: key);

  @override
  _InvestorRegistrationFormState createState() =>
      _InvestorRegistrationFormState();
}

class _InvestorRegistrationFormState extends State<InvestorRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _companiesInvestedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Investor Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _companiesInvestedController,
                decoration: InputDecoration(
                  labelText: 'Number of Companies Invested',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of companies invested';
                  }
                  // You can add additional validation logic here if needed
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Submit the form data
                      _submitForm();
                    }
                  },
                  child: Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    // Process the form data here (e.g., send itF to a server or store it locally)
    String name = _nameController.text;
    int companiesInvested = int.parse(_companiesInvestedController.text);
    String email = await FirebaseAuth.instance.currentUser!.email.toString();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .set({'email': email, 'role': 'investor'}).then((value) {
      naviRep(context, homePage());
    });
  }
}
