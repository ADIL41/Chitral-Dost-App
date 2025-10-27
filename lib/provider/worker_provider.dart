import 'package:chitral_dost_app/models/service_model.dart';
import 'package:chitral_dost_app/models/worker_model.dart';
import 'package:flutter/material.dart';

class WorkerProvider with ChangeNotifier {
  List<WorkerModel> _workers = [];
  WorkerModel? _selectedWorker;

  List<WorkerModel> get workers => _workers;
  WorkerModel? get selectedWorker => _selectedWorker;

  WorkerProvider() {
    _loadWorkers();
  }

  void _loadWorkers() {
    _workers = [
      WorkerModel(
        name: "Bilal",
        service: ServiceModel(
          label: "Cleaning",
          icon: Icons.cleaning_services,
          backgroundColor: Colors.white,
          avatarColor: Colors.blue,
          address: 'Drosh',
        ),
        phone: '03009876543',
        place: 'Drosh',
      ),
      WorkerModel(
        name: "Usman",
        service: ServiceModel(
          label: "Electrician",
          icon: Icons.electrical_services,
          backgroundColor: Colors.white,
          avatarColor: Colors.orange,
          address: 'Serdur',
        ),
        phone: "03007654321",
        place: 'Drosh',
      ),
    ];
  }

  void selectWorker(WorkerModel worker) {
    _selectedWorker = worker;
    notifyListeners();
  }

  void addWorker(
    String name,
    ServiceModel service,
    String phone,
    String place,
  ) {
    final newworker = WorkerModel(
      name: name,
      service: service,
      phone: phone,
      place: place,
    );
    _workers.add(newworker);
    notifyListeners();
  }

  

  List<WorkerModel> getWorkersByService(ServiceModel service) {
    return _workers
        .where((worker) => worker.service.label == service.label)
        .toList();
  }
}
