import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project_ty/snippets/navigator.dart';
import 'package:mini_project_ty/startupDetails.dart';

class startupList extends StatefulWidget {
  const startupList({Key? key}) : super(key: key);

  @override
  State<startupList> createState() => _startupListState();
}

class _startupListState extends State<startupList> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _startups = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchStartups();
  }

  Future<void> _fetchStartups() async {
    try {
      // setState(() {
      //   _isLoading = true;
      // });
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('startup').get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _startups = snapshot.docs
              .map((doc) => doc.data())
              .toList()
              .cast<Map<String, dynamic>>();
        });
      } else {
        print('No startups found');
      }
    } catch (error) {
      // Handle error when fetching startups
      print('Error fetching startups: $error');
      // Display error message to the user, retry fetching startups, etc.
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchStartups(String query) {
    setState(() {
      if (query.isNotEmpty) {
        _startups = _startups.where((startup) {
          final name = startup['Name']?.toLowerCase() ?? '';
          final description = startup['description']?.toLowerCase() ?? '';
          final lowerCaseQuery = query.toLowerCase();
          return name.contains(lowerCaseQuery) ||
              description.contains(lowerCaseQuery);
        }).toList();
      } else {
        // Reset the list if the query is empty
        _startups = _startups.toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search startups...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _searchStartups,
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("startup")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontSize: 40)),
                      ),
                    );
                  } else {
                    List<DocumentSnapshot<Map<String, dynamic>>> startups =
                        snapshot.data!.docs;
                    return ListView.builder(
                        itemCount: _startups.length,
                        itemBuilder: (context, index) {
                          final startup = _startups[index];
                          return InkWell(
                            onTap: () {
                              navi(context, startupDetails(startup));
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: startup['img'] == null ||
                                        startup['img'].isEmpty ||
                                        !Uri.parse(startup['img'])
                                            .isAbsolute // Check if the URI is absolute
                                    ? Colors.blue
                                    : null,
                                child: startup['img'] != null &&
                                        startup['img'].isNotEmpty
                                    ? Image.network(
                                        startup['img'],
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          // If image loading fails, set background color to blue
                                          return Container(
                                            color: Colors.blue,
                                            child: Icon(
                                              Icons.image,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                      )
                                    : Icon(
                                        Icons.image,
                                        color: Colors.white,
                                      ),
                              ),

                              title: Text(
                                startup['Name'],
                              ),
                              subtitle: Text(startup['description']),
                              // Add more details if needed
                            ),
                          );
                        });
                  }
                }),
          )
        ],
      ),
    );
  }
}
