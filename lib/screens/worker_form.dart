import 'package:chitral_dost_app/data/service_data.dart';
import 'package:chitral_dost_app/models/service_model.dart';
import 'package:chitral_dost_app/provider/worker_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WorkerForm extends StatelessWidget {
  const WorkerForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorkerFormProvider(),
      child: const _WorkerFormView(),
    );
  }
}

class _WorkerFormView extends StatelessWidget {
  const _WorkerFormView();

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkerFormProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              ' Registration Form',
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
              key: provider.formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: provider.nameController,
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

                  TextFormField(
                    controller: provider.serviceController,
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
                          onChanged: provider.selectService,
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

                  TextFormField(
                    controller: provider.descriptionController,
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

                  TextFormField(
                    controller: provider.phoneController,
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

                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: provider.place != null
                            ? Colors.teal
                            : Colors.grey[300]!,
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
                                color: provider.place != null
                                    ? Colors.teal
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Location',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: provider.place != null
                                      ? Colors.teal
                                      : Colors.grey[700],
                                ),
                              ),
                              const Spacer(),
                              if (provider.isGettingLocation)
                                const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Text(
                            provider.locationStatus,
                            style: TextStyle(
                              color: provider.place != null
                                  ? Colors.green
                                  : Colors.orange,
                              fontWeight: provider.place != null
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),

                          if (provider.place != null) ...[
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
                                    '📍 ${provider.place}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ],

                          if (provider.latitude != null &&
                              provider.longitude != null) ...[
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
                                  '${provider.latitude!.toStringAsFixed(6)}, '
                                  '${provider.longitude!.toStringAsFixed(6)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],

                          if (provider.address != null &&
                              provider.address!.isNotEmpty) ...[
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
                                    provider.address!,
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

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: provider.isGettingLocation
                                  ? null
                                  : () => provider.getCurrentLocation(context),
                              icon: Icon(
                                provider.place != null
                                    ? Icons.refresh
                                    : Icons.location_searching,
                              ),
                              label: Text(
                                provider.place != null
                                    ? 'Update Location'
                                    : 'Get My Location',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: provider.place != null
                                    ? Colors.teal[50]
                                    : Colors.teal,
                                foregroundColor: provider.place != null
                                    ? Colors.teal
                                    : Colors.white,
                                side: const BorderSide(color: Colors.teal),
                              ),
                            ),
                          ),

                          if (provider.place == null)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () =>
                                    provider.getCurrentLocation(context),
                                child: const Text('Enter manually'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  if (provider.place != null &&
                      provider.latitude != null &&
                      provider.longitude != null)
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

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => provider.submitForm(context),
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
      },
    );
  }
}
