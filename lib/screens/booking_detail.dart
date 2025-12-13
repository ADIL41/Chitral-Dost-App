import 'package:chitral_dost_app/provider/worker_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetail extends StatefulWidget {
  const BookingDetail({super.key});

  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  // REQUIRED: Flag to ensure data loading runs only once
  bool _isInit = true;

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri.parse('tel:$phoneNumber');
    if (!await launchUrl(launchUri)) {
      throw Exception('Could not launch $launchUri');
    }
  }

  // REQUIRED: Using didChangeDependencies for reliable one-time loading
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final provider = context.read<WorkerProvider>();
      
      // Load data only if the list is empty and we are not already loading
      if (provider.filteredWorkers.isEmpty && !provider.isLoading) {
        provider.loadAllWorkers();
      }
      _isInit = false; // Prevents loading again on subsequent rebuilds
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // --- Watch the Provider ---
    final provider = context.watch<WorkerProvider>();
    final workers = provider.filteredWorkers;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // Using theme color for better consistency
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'All Service Providers',
          style: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 20,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      // The Builder widget is no longer needed since the initialization logic
      // has been moved out of the build method.
      body: Column(
        children: [
          // Search Bar
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
              // Use context.read() to trigger the state change
              onChanged: (value) {
                context.read<WorkerProvider>().setSearchText(value);
              },
            ),
          ),

          // Error Message Check
          if (provider.errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${provider.errorMessage}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),

          // Worker List Content
          Expanded(child: _buildListContent(context, provider, workers)),
        ],
      ),
    );
  }

  Widget _buildListContent(
    BuildContext context,
    WorkerProvider provider,
    List workers,
  ) {
    // 1. Loading State
    if (provider.isLoading && workers.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Colors.teal));
    }

    // 2. Empty/No Match State
    if (workers.isEmpty) {
      if (provider.searchText.isNotEmpty) {
        // A. No match found for search
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 64, color: Colors.grey),
              const SizedBox(height: 8),
              Text(
                'No workers found for "${provider.searchText}"',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const Text('Try searching by a different name or service.'),
            ],
          ),
        );
      } else if (provider.errorMessage.isEmpty) {
        // B. Truly empty list
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.people, size: 64, color: Colors.teal),
                const SizedBox(height: 16),
                const Text(
                  'No Service Providers Found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'We couldn\'t find any service providers near your current location, or none have registered yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      }
    }

    // 3. List View
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: workers.length,
      itemBuilder: (context, index) {
        final worker = workers[index];

        // Extract data from the WorkerModel object
        final name = worker.name;
        final service = worker.service.label;
        final phone = worker.phone;
        final place = worker.place;
        final description = worker.description;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // Retaining the original gradient for visual consistency
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
                  Text(service, style: const TextStyle(fontSize: 14)),
                  Text(place, style: const TextStyle(fontSize: 14)),
                  Text(phone, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(description, style: const TextStyle(fontSize: 14)),
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
  }
}