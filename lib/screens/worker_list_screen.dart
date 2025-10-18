import 'package:chitral_dost_app/data/workers_data.dart';

import 'package:flutter/material.dart';

class WorkerListScreen extends StatelessWidget {
  final String service;

  const WorkerListScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final filteredWorker = workers.where((w) => w.service == service).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        title: Text(
          '$service Workers',
          style: TextStyle(color: Colors.orangeAccent),
        ),
        centerTitle: true,
      ),
      body: filteredWorker.isEmpty
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
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(worker.name),
                    subtitle: Text(worker.phone),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                );
              },
            ),
    );
  }
}
