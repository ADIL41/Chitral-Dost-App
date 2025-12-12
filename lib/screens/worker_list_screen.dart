// ignore_for_file: deprecated_member_use

import 'package:chitral_dost_app/screens/worker_profile.dart';
import 'package:chitral_dost_app/utils/location_helper.dart';
import 'package:chitral_dost_app/utils/search_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkerListScreen extends StatefulWidget {
  final String serviceLabel;
  const WorkerListScreen({super.key, required this.serviceLabel});

  @override
  State<WorkerListScreen> createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> {
  String _searchText = '';
  Position? _userLocation;
  double _radius = 10.0; // Increased default radius for better initial results
  bool _isLoadingLocation = false;
  bool _isLoadingWorkers = false;
  String _errorMessage = '';

  // 1. Correct Collection Reference: Keep this outside of methods
  final GeoCollectionReference<Map<String, dynamic>> geoCollection =
      GeoCollectionReference(FirebaseFirestore.instance.collection('workers'));

  // 2. Correct Stream Definition: Use a clearly defined Stream type
  Stream<List<DocumentSnapshot<Map<String, dynamic>>>>? _geoQueryStream;

  @override
  void initState() {
    super.initState();
    // Start getting location immediately
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    // Only set loading if location is not already set
    if (_userLocation == null) {
      setState(() {
        _isLoadingLocation = true;
        _errorMessage = '';
      });
    }

    try {
      final position = await LocationHelper.getCurrentLocation();
      setState(() {
        _userLocation = position;
        _isLoadingLocation = false;
      });
      // Setup the geo query immediately after getting location
      _setupGeoQuery();
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
        _userLocation = null; // Clear location on failure
        _errorMessage = 'Failed to get location: ${e.toString()}';
      });
      debugPrint('Error getting location: $e');
    }
  }

  void _setupGeoQuery() {
    if (_userLocation == null) {
      setState(() {
        // Clear workers/stream if location is lost/null
        _geoQueryStream = null;
        _isLoadingWorkers = false;
      });
      return;
    }

    setState(() {
      _isLoadingWorkers =
          true; // Set loading state while stream is being fetched
    });

    try {
      // Create a GeoFirePoint from user location
      final centerGeoPoint = GeoPoint(
        _userLocation!.latitude,
        _userLocation!.longitude,
      );

      // Setup the stream using the queryBuilder for service filtering
      _geoQueryStream = geoCollection.subscribeWithin(
        center: GeoFirePoint(centerGeoPoint),
        radiusInKm: _radius,
        field:
            'geo', // The field in your Firestore document where geo data is stored
        // A function to extract the GeoPoint from the document data.
        // Assuming data structure: {'geo': {'geopoint': GeoPoint(...), 'geohash': '...'}}
        geopointFrom: (data) =>
            (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint,
        // ADD THIS FOR FILTERING by serviceLabel
        queryBuilder: (query) =>
            query.where('service', isEqualTo: widget.serviceLabel),
        strictMode: false,
      );

      // Once stream is set up, clear loading state. StreamBuilder will handle stream status.
      setState(() {
        _isLoadingWorkers = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingWorkers = false;
        _errorMessage = 'Error setting up location query: ${e.toString()}';
      });
      debugPrint('Error setting up geo query: $e');
    }
  }

  void _updateRadius(double newRadius) {
    // Only update and re-query if the radius actually changed
    if (_radius != newRadius) {
      setState(() {
        _radius = newRadius;
      });
      if (_userLocation != null) {
        // Re-run the query with the new radius
        _setupGeoQuery();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.serviceLabel} Workers',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal[800],
        centerTitle: true,
        actions: [
          // Location status indicator
          _isLoadingLocation
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    _userLocation != null
                        ? Icons.location_on
                        : Icons.location_off,
                    color: Colors.white,
                  ),
                  onPressed: _getUserLocation,
                  tooltip: _userLocation != null
                      ? 'Location acquired'
                      : 'Get location',
                ),
        ],
      ),
      body: Column(
        children: [
          // Radius Slider Card
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Search Radius: ${_radius.round()} km',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(
                            _userLocation != null
                                ? '📍 Location On'
                                : '📍 Location Off',
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: _userLocation != null
                              ? Colors.teal.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.2),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Slider(
                      value: _radius,
                      min: 1,
                      max: 50,
                      divisions: 49,
                      label: '${_radius.round()} km',
                      onChanged: _updateRadius,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search within ${widget.serviceLabel}...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                // Trigger rebuild to apply text filter
                setState(() {
                  _searchText = value.trim();
                });
              },
            ),
          ),

          // Error Message
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.orange),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () {
                        setState(() => _errorMessage = '');
                      },
                    ),
                  ],
                ),
              ),
            ),

          // Worker List
          Expanded(child: _buildWorkerList()),
        ],
      ),
    );
  }

  Widget _buildWorkerList() {
    // 1. If location is needed and not available
    if (_userLocation == null && !_isLoadingLocation) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Enable location to find nearby workers',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getUserLocation,
              child: const Text('Enable Location'),
            ),
          ],
        ),
      );
    }

    // 2. If workers are currently loading (only set by _setupGeoQuery)
    if (_isLoadingWorkers || _isLoadingLocation) {
      return const Center(child: CircularProgressIndicator(color: Colors.teal));
    }

    // 3. Main stream builder
    return StreamBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
      stream: _geoQueryStream,
      builder: (context, snapshot) {
        // Handle initial waiting state (StreamBuilder's responsibility)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.teal),
          );
        }

        // Handle errors
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Failed to load workers',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          );
        }

        // Get the list of documents
        final geoFilteredWorkers = snapshot.data ?? [];

        // Apply search filter (name/description etc.)
        final filteredWorkers = _searchText.isEmpty
            ? geoFilteredWorkers
            : geoFilteredWorkers.where((doc) {
                // Cast safety: we know the stream is <Map<String, dynamic>>
                final data = doc.data();
                if (data == null) return false;
                return WorkerSearch.matchesQuery(data, _searchText);
              }).toList();

        // Handle empty initial data (no workers nearby)
        if (geoFilteredWorkers.isEmpty && _searchText.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.people_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No ${widget.serviceLabel} workers within ${_radius.round()} km',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Increase radius if it's not already at max
                    if (_radius < 50.0) {
                      _updateRadius(
                        _radius + 10.0 > 50.0 ? 50.0 : _radius + 10.0,
                      );
                    }
                  },
                  child: const Text('Increase Search Radius'),
                ),
              ],
            ),
          );
        }

        // Handle empty search results
        if (_searchText.isNotEmpty && filteredWorkers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No workers found for "$_searchText"',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Try a different search term',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Build the list
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: filteredWorkers.length,
          itemBuilder: (context, index) {
            final workerDoc = filteredWorkers[index];
            final data = workerDoc.data()!; // Data must exist at this point

            // Calculate distance
            String distanceText = '';
            if (_userLocation != null) {
              // Assuming lat/lng fields exist for display/distance calculation
              final lat = data['latitude'] as double?;
              final lng = data['longitude'] as double?;
              if (lat != null && lng != null) {
                final distance = LocationHelper.calculateDistance(
                  _userLocation!.latitude,
                  _userLocation!.longitude,
                  lat,
                  lng,
                );
                distanceText = '${distance.toStringAsFixed(1)} km away';
              }
            }

            return _buildWorkerCard(workerDoc, data, distanceText);
          },
        );
      },
    );
  }

  // The rest of your _buildWorkerCard remains the same as it was well-implemented.
  Widget _buildWorkerCard(
    DocumentSnapshot workerDoc,
    Map<String, dynamic> data,
    String distanceText,
  ) {
    final name = data['name'] as String? ?? 'Unknown';
    final place = data['place'] as String? ?? 'Location not specified';
    final description = data['description'] as String? ?? 'No description';

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Pass the worker document to the profile screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkerProfile(worker: workerDoc),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with distance indicator
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.teal,
                    radius: 24,
                    child: Icon(Icons.person, color: Colors.white, size: 24),
                  ),
                  if (distanceText.isNotEmpty)
                    Positioned(
                      right: -8,
                      bottom: -8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.teal[800],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        constraints: const BoxConstraints(minWidth: 60),
                        child: Text(
                          distanceText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            place,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
