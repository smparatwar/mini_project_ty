import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class acceleratorDetails extends StatefulWidget {
  Map data;

  acceleratorDetails(this.data);

  @override
  State<acceleratorDetails> createState() => _acceleratorDetailsState();
}

class _acceleratorDetailsState extends State<acceleratorDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data['name'].toString()),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              width: double.infinity,
              child: Image.network(widget.data['img'].toString()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.data['description'].toString()),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  widget.data['mentors'] != null &&
                          widget.data['mentors'].isNotEmpty
                      ? "Mentors Available  : "
                      : '',
                  style: GoogleFonts.poppins(
                      textStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Text(
                  widget.data['mentors'] != null &&
                          widget.data['mentors'].isNotEmpty
                      ? widget.data['mentors'].toString()
                      : '',
                  style: GoogleFonts.poppins(
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
