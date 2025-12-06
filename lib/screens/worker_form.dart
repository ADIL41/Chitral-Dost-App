import 'package:chitral_dost_app/data/service_data.dart';
import 'package:chitral_dost_app/models/service_model.dart';
import 'package:chitral_dost_app/provider/worker_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
  final _placeController = TextEditingController();
  final _descriptionController = TextEditingController();
  ServiceModel? _selectedService;
  @override
  void dispose() {
    _nameController.dispose();
    _serviceController.dispose();
    _phoneController.dispose();
    _placeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Worker Form',
          style: GoogleFonts.poppins(
            color: Theme.of(context).secondaryHeaderColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: Colors.teal[800],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
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
              const SizedBox(height: 6),
              TextFormField(
                controller: _serviceController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Service',
                  prefixIcon: Icon(Icons.work),
                  border: OutlineInputBorder(
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
                          _selectedService = selected;
                          _serviceController.text = selected.label;
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
              const SizedBox(height: 6),
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
              const SizedBox(height: 6),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // only allow digits
                  LengthLimitingTextInputFormatter(11), // max 11 digits
                ],

                decoration: const InputDecoration(
                  labelText: 'Phone ',
                  prefixIcon: Icon(Icons.phone),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Number';
                  }
                  if (value.length != 11) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _placeController,
                decoration: const InputDecoration(
                  labelText: 'Place',

                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your place';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _selectedService != null) {
                    Provider.of<WorkerProvider>(context, listen: false);

                    FirebaseFirestore.instance.collection('workers').add({
                      'name': _nameController.text,
                      'service': _selectedService!.label,
                      'phone': _phoneController.text,
                      'place': _placeController.text,
                      'description': _descriptionController.text,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Submitted successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
