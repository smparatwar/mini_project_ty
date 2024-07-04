import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class incubatorDetails extends StatefulWidget {
  Map data;

  incubatorDetails(this.data);

  @override
  State<incubatorDetails> createState() => _incubatorDetailsState();
}

class _incubatorDetailsState extends State<incubatorDetails> {
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
          if (widget.data['description'] !=
              null) // Check if description is available
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.data['description'].toString()),
            )
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Description not available'),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Amount Invested: ',
                  style: GoogleFonts.poppins(
                      textStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Text(
                  widget.data['amtInvested'] != null
                      ? widget.data['amtInvested'].toString()
                      : 'Not available',
                  style: GoogleFonts.poppins(
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  widget.data['expertMentors'] != null &&
                          widget.data['expertMentors'].isNotEmpty
                      ? "Mentors Available  : " +
                          widget.data['expertMentors'].toString()
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
