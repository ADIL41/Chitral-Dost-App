import 'package:chitral_dost_app/data/service_data.dart';
import 'package:chitral_dost_app/models/worker_model.dart';

final List<WorkerModel> workers = [
  WorkerModel(
    name: "Bilal",
    service: services.firstWhere((s) => s.label == "Plumbing"),
    phone: "03009876543",
    place: 'Drosh',
    description: '',
    

  ),
  WorkerModel(
    name: "Usman",
    service: services.firstWhere((s) => s.label == "Electrician"),
    phone: "03007654321",
    place: 'Drosh',
    description: ''
  ),
  WorkerModel(
    name: "Ahmed",
    service: services.firstWhere((s) => s.label == 'Cleaning'),
    phone: "03001112222",
    place: 'Chitral',
    description: '',
  ),

  WorkerModel(
    name: "Zeeshan",
    service: services.firstWhere((s) => s.label == "Driver"),
    phone: "03007778899",
    place: 'kesu',
    description: '',
  ),
  WorkerModel(
    name: "Zeeshan",
    service: services.firstWhere((s) => s.label == "Doctor"),
    phone: "03007778899",
    place: 'kesu',
    description: '',
  ),
  WorkerModel(
    name: "Zeeshan",
    service: services.firstWhere((s) => s.label == "Police"),
    phone: "03007778899",
    place: 'Drosh',
    description: '',
  ),
  WorkerModel(
    name: "Zeeshan",
    service: services.firstWhere((s) => s.label == "Driver"),
    phone: "03007778899",
    place: 'Drosh',
    description: '',
  ),
];
