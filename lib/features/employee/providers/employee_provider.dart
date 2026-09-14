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
    EmployeeModel(id: '1', name: 'Afdal Ramdan', role: 'UI/UX Designer', location: 'Bandung', joinDate: '1 Januari 2024', email: 'afdal@tujuhsembilan.com', placement: 'KAI', phoneNumber: '08123456789'),
    EmployeeModel(id: '2', name: 'Budi Santoso', role: 'HR Manager', location: 'Jakarta', joinDate: '15 Februari 2023', email: 'budi@tujuhsembilan.com', placement: 'Internal', phoneNumber: '08123456780'),
    EmployeeModel(id: '3', name: 'Citra Dewi', role: 'Data Analyst', location: 'Bandung', joinDate: '10 Maret 2024', email: 'citra@tujuhsembilan.com', placement: 'KAI', phoneNumber: '08123456781'),
    EmployeeModel(id: '4', name: 'Doni Prabowo', role: 'Project Coordinator', location: 'Jakarta', joinDate: '5 April 2022', email: 'doni@tujuhsembilan.com', placement: 'Internal', phoneNumber: '08123456782'),
    EmployeeModel(id: '5', name: 'Eka Saputra', role: 'Software Engineer', location: 'Bandung', joinDate: '20 Mei 2023', email: 'eka@tujuhsembilan.com', placement: 'Mandiri', phoneNumber: '08123456783'),
    EmployeeModel(id: '6', name: 'Faisal Akbar', role: 'DevOps Engineer', location: 'Jakarta', joinDate: '12 Juni 2021', email: 'faisal@tujuhsembilan.com', placement: 'Mandiri', phoneNumber: '08123456784'),
    EmployeeModel(id: '7', name: 'Gita Lestari', role: 'QA Tester', location: 'Bandung', joinDate: '8 Juli 2024', email: 'gita@tujuhsembilan.com', placement: 'KAI', phoneNumber: '08123456785'),
    EmployeeModel(id: '8', name: 'Hadi Wijaya', role: 'Product Manager', location: 'Jakarta', joinDate: '30 Agustus 2020', email: 'hadi@tujuhsembilan.com', placement: 'Internal', phoneNumber: '08123456786'),
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
