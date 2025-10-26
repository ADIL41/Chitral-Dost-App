import 'package:chitral_dost_app/data/workers_data.dart';
import 'package:chitral_dost_app/models/service_model.dart';
import 'package:chitral_dost_app/provider/worker_provider.dart';
import 'package:chitral_dost_app/screens/worker_profile.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkerListScreen extends StatelessWidget {
  final ServiceModel service;

  const WorkerListScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final filteredWorker = workers.where((w) => w.service == service).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        title: Text(
          '${service.label} Workers',
          style: TextStyle(color: Colors.orangeAccent),
        ),
        centerTitle: true,
      ),
      body: Consumer<WorkerProvider>(
        builder: (context, workerProvider, child) {
          final filteredWorker = workerProvider.getWorkersByService(service);
          return filteredWorker.isEmpty
              ? const Center(
                  child: Text(
                    'No workers available for this service yet.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: filteredWorker.length,

                  itemBuilder: (context, index) {
                    final worker = filteredWorker[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [Color(0xff84fab0), Color(0xff8fd3f4)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(child: Icon(Icons.person)),
                          title: Text(
                            worker.name,
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            worker.phone,
                            style: TextStyle(color: Colors.black87),
                          ),
                          trailing: (Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.black54,
                          )),
                          onTap: () {
                            workerProvider.selectWorker(worker);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WorkerProfile(worker: worker),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
