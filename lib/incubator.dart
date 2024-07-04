import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project_ty/details.dart';
import 'package:mini_project_ty/snippets/navigator.dart';

class incubator extends StatefulWidget {
  const incubator({Key? key}) : super(key: key);

  @override
  State<incubator> createState() => _incubatorState();
}

class _incubatorState extends State<incubator> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _incubators = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchIncubators();
  }

  Future<void> _fetchIncubators() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('incubator').get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _incubators = snapshot.docs
              .map((doc) => doc.data())
              .toList()
              .cast<Map<String, dynamic>>();
        });
      } else {
        print('No incubators found');
      }
    } catch (error) {
      print('Error fetching incubators: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchIncubators(String query) {
    setState(() {
      if (query.isNotEmpty) {
        _incubators = _incubators.where((incubator) {
          final name = incubator['name']?.toLowerCase() ?? '';
          final description = incubator['description']?.toLowerCase() ?? '';
          final lowerCaseQuery = query.toLowerCase();
          return name.contains(lowerCaseQuery) ||
              description.contains(lowerCaseQuery);
        }).toList();
      } else {
        _incubators = _incubators.toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Incubator List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search incubators...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _searchIncubators,
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("incubator")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 40),
                      ),
                    ),
                  );
                } else {
                  List<DocumentSnapshot<Map<String, dynamic>>> incubators =
                      snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: _incubators.length,
                    itemBuilder: (context, index) {
                      final incubator = _incubators[index];
                      return ListTile(
                        onTap: () {
                          navi(context, incubatorDetails(incubator));
                        },
                        leading: CircleAvatar(
                          child: Image.network(
                            incubator['img'],
                          ),
                        ),
                        title: Text(incubator['name']),
                        //subtitle: Text(incubator['description']),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
