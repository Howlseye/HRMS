import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/employee_model.dart';
import 'employee_filter_provider.dart';

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(() {
  return SearchQueryNotifier();
});

final allEmployeesProvider = Provider<List<EmployeeModel>>((ref) {
  return [
    EmployeeModel(id: '1', name: 'Afdal Ramdan', role: 'UI/UX Designer', location: 'Bandung'),
    EmployeeModel(id: '2', name: 'Budi Santoso', role: 'HR Manager', location: 'Jakarta'),
    EmployeeModel(id: '3', name: 'Citra Dewi', role: 'Data Analyst', location: 'Bandung'),
    EmployeeModel(id: '4', name: 'Doni Prabowo', role: 'Project Coordinator', location: 'Jakarta'),
    EmployeeModel(id: '5', name: 'Eka Saputra', role: 'Software Engineer', location: 'Bandung'),
    EmployeeModel(id: '6', name: 'Faisal Akbar', role: 'DevOps Engineer', location: 'Jakarta'),
    EmployeeModel(id: '7', name: 'Gita Lestari', role: 'QA Tester', location: 'Bandung'),
    EmployeeModel(id: '8', name: 'Hadi Wijaya', role: 'Product Manager', location: 'Jakarta'),
  ];
});

final employeeProvider = Provider<List<EmployeeModel>>((ref) {
  final allEmployees = ref.watch(allEmployeesProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final filterState = ref.watch(employeeFilterProvider);

  return allEmployees.where((employee) {
    // 1. Search Query
    final matchesSearch = employee.name.toLowerCase().contains(searchQuery) ||
                          employee.role.toLowerCase().contains(searchQuery);

    // 2. Location Filter
    final matchesLocation = filterState.selectedLocations.isEmpty ||
                            filterState.selectedLocations.contains(employee.location);

    // 3. Role Filter
    final matchesRole = filterState.selectedRoles.isEmpty ||
                        filterState.selectedRoles.contains(employee.role);

    return matchesSearch && matchesLocation && matchesRole;
  }).toList();
});
