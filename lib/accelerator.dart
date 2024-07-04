import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project_ty/acceleratorDetails.dart';
import 'package:mini_project_ty/snippets/navigator.dart';

class accelerator extends StatefulWidget {
  const accelerator({Key? key}) : super(key: key);

  @override
  State<accelerator> createState() => _acceleratorState();
}

class _acceleratorState extends State<accelerator> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _accelerators = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAccelerators();
  }

  Future<void> _fetchAccelerators() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('accelerator').get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _accelerators = snapshot.docs
              .map((doc) => doc.data())
              .toList()
              .cast<Map<String, dynamic>>();
        });
      } else {
        print('No accelerators found');
      }
    } catch (error) {
      print('Error fetching accelerators: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchAccelerators(String query) {
    setState(() {
      if (query.isNotEmpty) {
        _accelerators = _accelerators.where((accelerator) {
          final name = accelerator['name']?.toLowerCase() ?? '';
          final description = accelerator['description']?.toLowerCase() ?? '';
          final lowerCaseQuery = query.toLowerCase();
          return name.contains(lowerCaseQuery) ||
              description.contains(lowerCaseQuery);
        }).toList();
      } else {
        _accelerators = _accelerators.toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accelerator List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search accelerators...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _searchAccelerators,
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("accelerator")
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
                  List<DocumentSnapshot<Map<String, dynamic>>> accelerators =
                      snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: _accelerators.length,
                    itemBuilder: (context, index) {
                      final accelerator = _accelerators[index];
                      return ListTile(
                        onTap: () {
                          navi(context, acceleratorDetails(accelerator));
                        },
                        leading: CircleAvatar(
                          child: Image.network(
                            accelerator['img'],
                          ),
                        ),
                        title: Text(accelerator['name']),
                        //subtitle: Text(accelerator['description']),
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
