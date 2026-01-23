
class WorkerSearch {
  static bool matchesQuery(Map<String, dynamic> data, String query) {
    final queryLower = query.toLowerCase();
    
    final fieldsToSearch = [
      data['name'],
      data['service'], 
      data['place'],
      data['phone'],
      data['description'],
    ];
    
    return fieldsToSearch.any((field) => 
        field?.toString().toLowerCase().contains(queryLower) ?? false);
  }
}