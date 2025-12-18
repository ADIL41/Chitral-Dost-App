import 'dart:async';

import 'package:chitral_dost_app/models/worker_model.dart';
import 'package:chitral_dost_app/utils/location_helper.dart';
import 'package:chitral_dost_app/utils/search_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';

class WorkerProvider with ChangeNotifier {
  List<WorkerModel> _nearbyWorkers = [];

  Position? _userLocation;
  double _radius = 10.0;
  String _searchText = '';
  String _currentServiceLabel = '';

  bool _isLoading = false;
  String _errorMessage = '';

  final GeoCollectionReference<Map<String, dynamic>> _geoCollection =
      GeoCollectionReference(FirebaseFirestore.instance.collection('workers'));

  StreamSubscription? _geoSubscription;

  Position? get userLocation => _userLocation;
  double get radius => _radius;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get searchText => _searchText;

  List<WorkerModel> get filteredWorkers {
    if (_searchText.isEmpty) {
      _nearbyWorkers.sort((a, b) {
        if (a.distanceInKm == null && b.distanceInKm == null) return 0;
        if (a.distanceInKm == null) return 1;
        if (b.distanceInKm == null) return -1;
        return a.distanceInKm!.compareTo(b.distanceInKm!);
      });
      return _nearbyWorkers;
    }

    return _nearbyWorkers.where((worker) {
      final searchData = {
        'name': worker.name,
        'description': worker.description,
        'place': worker.place,

        'service': worker.service.label,
      };
      return WorkerSearch.matchesQuery(searchData, _searchText);
    }).toList();
  }

  Future<void> initLocationAndWorkers(String serviceLabel) async {
    _currentServiceLabel = serviceLabel;
    await _loadAndSetupWorkers();
  }

  Future<void> loadAllWorkers() async {
    _currentServiceLabel = '';
    await _loadAndSetupWorkers();
  }

  Future<void> _loadAndSetupWorkers() async {
    _errorMessage = '';

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

    _setupGeoListener();
  }

  void _setupGeoListener() {
    if (_userLocation == null) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    _geoSubscription?.cancel();

    final centerGeoPoint = GeoPoint(
      _userLocation!.latitude,
      _userLocation!.longitude,
    );

    Query<Map<String, dynamic>> queryBuilderLogic(
      Query<Map<String, dynamic>> query,
    ) {
      if (_currentServiceLabel.isNotEmpty) {
        return query.where('service', isEqualTo: _currentServiceLabel);
      }

      return query;
    }

    final stream = _geoCollection.subscribeWithin(
      center: GeoFirePoint(centerGeoPoint),
      radiusInKm: _radius,
      field: 'geo',
      geopointFrom: (data) =>
          (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint,
      queryBuilder: queryBuilderLogic,
      strictMode: false,
    );

    _geoSubscription = stream.listen(
      (snapshots) {
        _nearbyWorkers = snapshots.map((doc) {
          final data = doc.data()!;
          double? dist;
          final lat = data['latitude'] as double?;
          final lng = data['longitude'] as double?;

          if (lat != null && lng != null) {
            dist = LocationHelper.calculateDistance(
              _userLocation!.latitude,
              _userLocation!.longitude,
              lat,
              lng,
            );
          }

          return WorkerModel.fromSnapshot(doc, calculatedDistance: dist);
        }).toList();

        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _errorMessage = 'Error loading workers: ${e.toString()}';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void setRadius(double newRadius) {
    if (_radius != newRadius) {
      _radius = newRadius;
      notifyListeners();
      _setupGeoListener();
    }
  }

  void setSearchText(String text) {
    _searchText = text.trim();
    notifyListeners();
  }

  Future<void> refreshLocation() async {
    _userLocation = null;

    await _loadAndSetupWorkers();
  }

  @override
  void dispose() {
    _geoSubscription?.cancel();
    super.dispose();
  }
}
