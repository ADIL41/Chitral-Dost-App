import 'dart:async';

import 'package:chitral_dost_app/models/worker_model.dart';
import 'package:chitral_dost_app/utils/location_helper.dart';
import 'package:chitral_dost_app/utils/search_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';

class WorkerProvider with ChangeNotifier {
  // --- State Variables ---
  List<WorkerModel> _nearbyWorkers = []; // Workers fetched by the GeoQuery

  Position? _userLocation;
  double _radius = 10.0;
  String _searchText = '';
  String _currentServiceLabel = ''; // Used to filter the GeoQuery

  bool _isLoading = false;
  String _errorMessage = '';

  // --- Internal Stuff ---
  final GeoCollectionReference<Map<String, dynamic>> _geoCollection =
      GeoCollectionReference(FirebaseFirestore.instance.collection('workers'));

  StreamSubscription? _geoSubscription;

  // --- Getters ---
  Position? get userLocation => _userLocation;
  double get radius => _radius;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get searchText => _searchText;

  // Getter that returns the final list (Geo-filtered AND Text-searched)
  List<WorkerModel> get filteredWorkers {
    // 1. If no search text, return the list directly from GeoFire
    if (_searchText.isEmpty) {
      // Sort by distance (closest first) for the UI
      _nearbyWorkers.sort((a, b) {
        if (a.distanceInKm == null && b.distanceInKm == null) return 0;
        if (a.distanceInKm == null) return 1;
        if (b.distanceInKm == null) return -1;
        return a.distanceInKm!.compareTo(b.distanceInKm!);
      });
      return _nearbyWorkers;
    }

    // 2. Perform text search on the already geo-filtered list
    return _nearbyWorkers.where((worker) {
      // Create a temporary map for your existing search utility
      final searchData = {
        'name': worker.name,
        'description': worker.description,
        'place': worker.place,
        // Include service label in search
        'service': worker.service.label,
      };
      return WorkerSearch.matchesQuery(searchData, _searchText);
    }).toList();
  }

  // --- Initialization & Data Loading Actions ---

  // 1. Used by WorkerListScreen (requires a service filter)
  Future<void> initLocationAndWorkers(String serviceLabel) async {
    _currentServiceLabel = serviceLabel;
    await _loadAndSetupWorkers();
  }

  // 2. Used by BookingDetail (All Workers, no service filter)
  Future<void> loadAllWorkers() async {
    _currentServiceLabel = ''; // Clear service filter
    await _loadAndSetupWorkers();
  }

  // 3. Core logic to get location and start the stream
  Future<void> _loadAndSetupWorkers() async {
    _errorMessage = '';

    // Only fetch location if we don't have it
    if (_userLocation == null) {
      _isLoading = true;
      notifyListeners();

      try {
        _userLocation = await LocationHelper.getCurrentLocation();
      } catch (e) {
        _errorMessage = 'Failed to get location: ${e.toString()}';
        _isLoading = false;
        notifyListeners();
        return;
      }
    }

    // Start or restart the GeoFire listener
    _setupGeoListener();
  }

  // 4. Setup the GeoFire Stream Listener (The Core Logic)
  void _setupGeoListener() {
    if (_userLocation == null) {
      // Cannot listen without location, error message should already be set.
      return;
    }

    _isLoading = true;
    notifyListeners();

    // Cancel existing subscription if any to prevent memory leaks and duplicate fetching
    _geoSubscription?.cancel();

    final centerGeoPoint = GeoPoint(
      _userLocation!.latitude,
      _userLocation!.longitude,
    );

    // Function to apply service filter dynamically
    Query<Map<String, dynamic>> queryBuilderLogic(
      Query<Map<String, dynamic>> query,
    ) {
      if (_currentServiceLabel.isNotEmpty) {
        // Apply service filter for WorkerListScreen
        return query.where('service', isEqualTo: _currentServiceLabel);
      }
      // No filter needed for BookingDetail (All Workers)
      return query;
    }

    final stream = _geoCollection.subscribeWithin(
      center: GeoFirePoint(centerGeoPoint),
      radiusInKm: _radius,
      field: 'geo',
      geopointFrom: (data) =>
          (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint,
      queryBuilder: queryBuilderLogic, // <-- Should now be error-free
      strictMode: false,
    );

    // Listen to the stream inside the provider
    _geoSubscription = stream.listen(
      (snapshots) {
        // Map DocumentSnapshots to WorkerModel, calculating distance on the fly
        _nearbyWorkers = snapshots.map((doc) {
          final data = doc.data()!;
          double? dist;
          final lat = data['latitude'] as double?;
          final lng = data['longitude'] as double?;

          if (lat != null && lng != null) {
            // Use LocationHelper to calculate distance (Haversine logic)
            dist = LocationHelper.calculateDistance(
              _userLocation!.latitude,
              _userLocation!.longitude,
              lat,
              lng,
            );
          }
          // Pass the calculated distance to the factory constructor
          return WorkerModel.fromSnapshot(doc, calculatedDistance: dist);
        }).toList();

        _isLoading = false;
        notifyListeners(); // Update the UI
      },
      onError: (e) {
        _errorMessage = 'Error loading workers: ${e.toString()}';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // --- Action Methods ---

  // 5. Update Radius
  void setRadius(double newRadius) {
    if (_radius != newRadius) {
      _radius = newRadius;
      notifyListeners(); // Update slider UI immediately
      _setupGeoListener(); // Restart GeoFire query with new radius
    }
  }

  // 6. Update Search Text
  void setSearchText(String text) {
    _searchText = text.trim();
    notifyListeners(); // Triggers filteredWorkers getter re-calculation
  }

  // 7. Refresh Location manually
  Future<void> refreshLocation() async {
    _userLocation = null;
    // Reloads all workers based on the current service filter (or lack thereof)
    await _loadAndSetupWorkers();
  }

  // 8. Clean up
  @override
  void dispose() {
    _geoSubscription
        ?.cancel(); // MUST stop the stream when the provider is destroyed
    super.dispose();
  }
}
