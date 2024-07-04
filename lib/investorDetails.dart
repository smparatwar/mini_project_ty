import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package

class investorDetails extends StatefulWidget {
  final Map data;
  final String role;

  investorDetails(this.data, this.role);

  @override
  State<investorDetails> createState() => _investorDetailsState();
}

class _investorDetailsState extends State<investorDetails> {
  // Method to open WhatsApp with pre-filled message
  void _launchWhatsApp() async {
    // Assuming the number is fetched from Firebase or hardcoded
    String phoneNumber = "+1234567890"; // Replace with your phone number

    // URL format for sending message on WhatsApp
    String url = "https://wa.me/$phoneNumber?text=Hello%20Investor!";

    // Launch URL using url_launcher package
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
          if (widget.data['description'] != null)
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
                  widget.data['amountInvested'] != null
                      ? widget.data['amountInvested'].toString()
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
                  'Companies Invested: ',
                  style: GoogleFonts.poppins(
                      textStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Text(
                  widget.data['investedCompanies'] != null
                      ? widget.data['investedCompanies'].toString()
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
                      ? "Expert Mentors Available: " +
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
          // Conditionally display options based on user role
          if (widget.role == 'startup')
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle chat button click
                    _launchWhatsApp(); // Call method to open WhatsApp
                  },
                  child: Text('Chat'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle invest button click
                  },
                  child: Text('Invest'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
