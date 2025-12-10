import 'package:chitral_dost_app/Utils/search_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetail extends StatefulWidget {
  const BookingDetail({super.key});

  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  String _searchText = '';

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal[800],
        title: Text(
          'All Service Providers',
          style: GoogleFonts.poppins(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: 20,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Simple Search Bar at the top
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search workers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value.toLowerCase();
                });
              },
            ),
          ),

          // Your EXACT original StreamBuilder with minimal changes
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('workers')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No service providers found.'),
                  );
                }

                final allDocs = snapshot.data!.docs;

                // Filter workers based on search
                final filteredDocs = _searchText.isEmpty
                    ? allDocs
                    : allDocs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return WorkerSearch.matchesQuery(data, _searchText);
                      }).toList();

                if (filteredDocs.isEmpty && _searchText.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        Text(
                          'No workers found for "$_searchText"',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final data =
                        filteredDocs[index].data() as Map<String, dynamic>;

                    final name = data['name'] ?? '';
                    final service = data['service'] ?? '';
                    final phone = data['phone'] ?? '';
                    final place = data['place'] ?? '';
                    final description = data['description'] ?? '';

                    // Your EXACT original card design
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [Color(0xff84fab0), Color(0xff8fd3f4)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                service,
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(place, style: const TextStyle(fontSize: 14)),
                              Text(phone, style: const TextStyle(fontSize: 14)),
                              const SizedBox(height: 8),
                              Text(
                                description,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () => _makePhoneCall(phone),
                                child: const Text('Call Now'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
