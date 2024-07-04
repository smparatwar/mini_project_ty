import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_project_ty/home.dart';
import 'package:mini_project_ty/snippets/navigator.dart';

class startupRegistration extends StatefulWidget {
  const startupRegistration({Key? key}) : super(key: key);

  @override
  State<startupRegistration> createState() => _startupRegistrationState();
}

class _startupRegistrationState extends State<startupRegistration> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _longdescriptionController = TextEditingController();
  TextEditingController _imgLink = TextEditingController();
  String? _identityDocumentPath;
  String? _startupDocumentPath;

  Future<void> _pickIdentityDocument() async {
    String? filePath = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx'
      ], // Add more extensions if needed
    ).then((value) => value?.files.single.path);

    if (filePath != null) {
      setState(() {
        _identityDocumentPath = filePath;
      });
    }
  }

  Future<void> _pickStartupDocument() async {
    String? filePath = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx'
      ], // Add more extensions if needed
    ).then((value) => value?.files.single.path);

    if (filePath != null) {
      setState(() {
        _startupDocumentPath = filePath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Startup Name *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _longdescriptionController,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: 'Long Description *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _imgLink,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Image Link *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickIdentityDocument,
                child: Text('Pick Proof of Identity Document'),
              ),
              SizedBox(height: 8.0),
              if (_identityDocumentPath != null)
                Text('Selected Identity Document: $_identityDocumentPath'),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickStartupDocument,
                child: Text('Pick Proof of Startup Document'),
              ),
              SizedBox(height: 8.0),
              if (_startupDocumentPath != null)
                Text('Selected Startup Document: $_startupDocumentPath'),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_nameController.text.isEmpty ||
                      _descriptionController.text.isEmpty ||
                      _longdescriptionController.text.isEmpty ||
                      _imgLink.text.isEmpty ||
                      _identityDocumentPath == null ||
                      _startupDocumentPath == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please fill in all the mandatory fields.'),
                    ));
                  } else {
                    await FirebaseFirestore.instance
                        .collection('startup')
                        .doc()
                        .set({
                      'Name': _nameController.text,
                      'description': _descriptionController.text,
                      'longDescription': _longdescriptionController.text,
                      'img': _imgLink.text,
                    }).then((value) {
                      naviRep(context, homePage());
                    }).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("StartUp Registered Successfully")));
                    });
                  }
                },
                child: Text('Register Startup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
