import 'package:chitral_dost_app/data/service_data.dart';
import 'package:chitral_dost_app/models/service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkerForm extends StatefulWidget {
  const WorkerForm({super.key});

  @override
  State<WorkerForm> createState() => _WorkerFormState();
}

class _WorkerFormState extends State<WorkerForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _serviceController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();

  ServiceModel? _selectedService;

  bool _isGettingLocation = false;
  String _locationStatus = 'Tap to get location';
  double? _latitude;
  double? _longitude;
  String? _address;
  String? _place;

  @override
  void initState() {
    super.initState();
    // Optionally get location automatically when form loads
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _serviceController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Get current location with all details
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
      _locationStatus = 'Getting location...';
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationStatus = 'Location services disabled';
          _isGettingLocation = false;
        });
        _showLocationErrorDialog('Please enable location services');
        return;
      }

      // Check and request permissions
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationStatus = 'Location permission denied';
            _isGettingLocation = false;
          });
          _showLocationErrorDialog('Location permission is required');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationStatus = 'Location permission permanently denied';
          _isGettingLocation = false;
        });
        _showLocationErrorDialog(
          'Location permissions are permanently denied. Please enable them in app settings.',
        );
        return;
      }

      // Get current position
      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      );

      // Pass the settings object to getCurrentPosition
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      // Get address details from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;

        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;

          // Format address
          _address = _formatAddress(placemark);

          // Use locality or subLocality as place
          _place =
              placemark.locality ??
              placemark.subLocality ??
              placemark.administrativeArea ??
              'Unknown Location';

          _locationStatus = 'Location acquired ✓';
          _isGettingLocation = false;
        });
      } else {
        setState(() {
          _locationStatus = 'Location acquired (no address details)';
          _isGettingLocation = false;
          _latitude = position.latitude;
          _longitude = position.longitude;
          _place =
              'Coordinates: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
        });
      }
    } catch (e) {
      setState(() {
        _locationStatus = 'Failed to get location';
        _isGettingLocation = false;
      });

      // Fallback: Allow manual location entry
      _showManualLocationDialog();
    }
  }

  String _formatAddress(Placemark placemark) {
    List<String> addressParts = [];

    if (placemark.street != null && placemark.street!.isNotEmpty) {
      addressParts.add(placemark.street!);
    }
    if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
      addressParts.add(placemark.subLocality!);
    }
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      addressParts.add(placemark.locality!);
    }
    if (placemark.administrativeArea != null &&
        placemark.administrativeArea!.isNotEmpty) {
      addressParts.add(placemark.administrativeArea!);
    }

    return addressParts.join(', ');
  }

  void _showLocationErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Required'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _getCurrentLocation(); // Try again
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showManualLocationDialog() {
    final manualPlaceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Location Manually'),
        content: TextField(
          controller: manualPlaceController,
          decoration: const InputDecoration(
            hintText: 'Enter your city/town/village',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (manualPlaceController.text.isNotEmpty) {
                setState(() {
                  _place = manualPlaceController.text;
                  _locationStatus = 'Manual location entered';
                  // Use default Chitral coordinates as fallback
                  _latitude = 35.8511;
                  _longitude = 71.7861;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // UPDATED SUBMIT FORM WITH GEOFLUTTERFIRE_PLUS
  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a service'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_place == null || _latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please get your location first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // --- CRITICAL CHANGES ---
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error: You must be logged in to register as a worker.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Get the user's UID to use as the Document ID (workerId)
    final String workerId = currentUser.uid;
    // --- END OF CRITICAL CHANGES ---

    final GeoPoint firestoreGeoPoint = GeoPoint(_latitude!, _longitude!);
    final GeoFirePoint geoFirePoint = GeoFirePoint(firestoreGeoPoint);

    // Submit to Firebase using .doc(workerId).set()
    try {
      await FirebaseFirestore.instance
          .collection('workers')
          // Use .doc(UID).set() to match the Firestore Security Rule:
          // allow write: if request.auth.uid == workerId;
          .doc(workerId)
          .set({
            'name': _nameController.text,
            'service': _selectedService!.label,
            'phone': _phoneController.text,
            'place': _place,
            'description': _descriptionController.text,
            'latitude': _latitude,
            'longitude': _longitude,
            'address': _address,
            'geo': geoFirePoint.data,
            'workerUID': workerId,
            'createdAt': FieldValue.serverTimestamp(),
            'locationUpdatedAt': FieldValue.serverTimestamp(),
          });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Worker registered successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form after successful submission
      _nameController.clear();
      _serviceController.clear();
      _phoneController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedService = null;
        _place = null;
        _latitude = null;
        _longitude = null;
        _address = null;
        _locationStatus = 'Tap to get location';
      });

      // Get fresh location for next registration
      _getCurrentLocation();

      Navigator.pop(context);
    } on FirebaseException catch (error) {
      // This handles the permission denied error directly

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error registering worker: ${error.message}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // The build method contains the original UI, preserved as requested.
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Worker Registration',
          style: GoogleFonts.poppins(
            color: Theme.of(context).secondaryHeaderColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: Colors.teal[800],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Service Field
              TextFormField(
                controller: _serviceController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Service',
                  prefixIcon: const Icon(Icons.work),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  suffixIcon: DropdownButtonHideUnderline(
                    child: DropdownButton<ServiceModel>(
                      icon: const Icon(Icons.arrow_drop_down),
                      items: services.map((service) {
                        return DropdownMenuItem<ServiceModel>(
                          value: service,
                          child: Row(
                            children: [
                              Icon(
                                service.icon,
                                size: 20,
                                color: service.avatarColor,
                              ),
                              const SizedBox(width: 8),
                              Text(service.label),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (ServiceModel? selected) {
                        if (selected != null) {
                          setState(() {
                            _selectedService = selected;
                            _serviceController.text = selected.label;
                          });
                        }
                      },
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your service';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                maxLength: 300,
                decoration: const InputDecoration(
                  labelText: 'Service Description',
                  hintText:
                      'Describe your skills, experience, services you offer, etc...',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe your services';
                  }
                  if (value.length < 20) {
                    return 'Description should be at least 20 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Phone Field
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length != 11) {
                    return 'Please enter a valid 11-digit phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Location Card with geohash info
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: _place != null ? Colors.teal : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: _place != null ? Colors.teal : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Location',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _place != null
                                  ? Colors.teal
                                  : Colors.grey[700],
                            ),
                          ),
                          const Spacer(),
                          if (_isGettingLocation)
                            const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Location Status
                      Text(
                        _locationStatus,
                        style: TextStyle(
                          color: _place != null ? Colors.green : Colors.orange,
                          fontWeight: _place != null
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),

                      // Show location details if available
                      if (_place != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.place,
                              size: 16,
                              color: Colors.teal,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '📍 $_place',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],

                      if (_latitude != null && _longitude != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.gps_fixed,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],

                      if (_address != null && _address!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.home,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _address!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 12),

                      // Get Location Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isGettingLocation
                              ? null
                              : _getCurrentLocation,
                          icon: Icon(
                            _place != null
                                ? Icons.refresh
                                : Icons.location_searching,
                          ),
                          label: Text(
                            _place != null
                                ? 'Update Location'
                                : 'Get My Location',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _place != null
                                ? Colors.teal[50]
                                : Colors.teal,
                            foregroundColor: _place != null
                                ? Colors.teal
                                : Colors.white,
                            side: const BorderSide(color: Colors.teal),
                          ),
                        ),
                      ),

                      // Manual Entry Option
                      if (_place == null)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _showManualLocationDialog,
                            child: const Text('Enter manually'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Information about geo features
              if (_place != null && _latitude != null && _longitude != null)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.teal[700],
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Your location will be used for efficient nearby search',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.teal[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Register as Worker',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
