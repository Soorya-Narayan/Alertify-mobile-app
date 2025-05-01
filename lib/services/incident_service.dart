class Incident {
  final String type;
  final String address;
  final String details;

  Incident({
    required this.type,
    required this.address,
    required this.details,
  });
}

class IncidentService {
  static final IncidentService _instance = IncidentService._internal();
  factory IncidentService() => _instance;
  IncidentService._internal();

  final List<Incident> _incidents = [];

  void addIncident(String address, String type, String details) {
    _incidents.add(Incident(type: type, address: address, details: details));
  }

  List<Incident> getIncidents() => List.unmodifiable(_incidents);
}
