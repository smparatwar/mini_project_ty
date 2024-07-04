import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project_ty/investorDetails.dart';
import 'package:mini_project_ty/snippets/navigator.dart';

class investor extends StatefulWidget {
  const investor({Key? key}) : super(key: key);

  @override
  State<investor> createState() => _investorState();
}

class _investorState extends State<investor> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _investors = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchInvestors();
  }

  Future<void> _fetchInvestors() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('investor').get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _investors = snapshot.docs
              .map((doc) => doc.data())
              .toList()
              .cast<Map<String, dynamic>>();
        });
      } else {
        print('No investors found');
      }
    } catch (error) {
      print('Error fetching investors: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchInvestors(String query) {
    setState(() {
      if (query.isNotEmpty) {
        _investors = _investors.where((investor) {
          final name = investor['Name']?.toLowerCase() ?? '';
          final description = investor['description']?.toLowerCase() ?? '';
          final lowerCaseQuery = query.toLowerCase();
          return name.contains(lowerCaseQuery) ||
              description.contains(lowerCaseQuery);
        }).toList();
      } else {
        _investors = _investors.toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Investor List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search investors...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _searchInvestors,
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("investor").snapshots(),
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
                  List<DocumentSnapshot<Map<String, dynamic>>> investors =
                      snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: _investors.length,
                    itemBuilder: (context, index) {
                      final investor = _investors[index];
                      return ListTile(
                        onTap: () {
                          navi(
                              context,
                              investorDetails(investor,
                                  FirebaseFirestore.instance.databaseId));
                        },
                        leading: CircleAvatar(
                          child: Image.network(
                            investor['img'],
                          ),
                        ),
                        title: Text(investor['name']),
                        // subtitle: Text(investor['description']),
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
