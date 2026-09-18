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
  return [];
});

final employeeProvider = Provider<List<EmployeeModel>>((ref) {
  final allEmployees = ref.watch(allEmployeesProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final filterState = ref.watch(employeeFilterProvider);

  return allEmployees.where((employee) {

    final matchesSearch = employee.name.toLowerCase().contains(searchQuery) ||
                          employee.role.toLowerCase().contains(searchQuery);


    final matchesLocation = filterState.selectedLocations.isEmpty ||
                            filterState.selectedLocations.contains(employee.location);


    final matchesRole = filterState.selectedRoles.isEmpty ||
                        filterState.selectedRoles.contains(employee.role);

    return matchesSearch && matchesLocation && matchesRole;
  }).toList();
});
