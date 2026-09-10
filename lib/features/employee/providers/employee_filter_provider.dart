import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeeFilterState {
  final List<String> selectedLocations;
  final List<String> selectedRoles;

  EmployeeFilterState({
    required this.selectedLocations,
    required this.selectedRoles,
  });

  EmployeeFilterState copyWith({
    List<String>? selectedLocations,
    List<String>? selectedRoles,
  }) {
    return EmployeeFilterState(
      selectedLocations: selectedLocations ?? this.selectedLocations,
      selectedRoles: selectedRoles ?? this.selectedRoles,
    );
  }
}

class EmployeeFilterNotifier extends Notifier<EmployeeFilterState> {
  @override
  EmployeeFilterState build() {
    return EmployeeFilterState(
      selectedLocations: [],
      selectedRoles: [],
    );
  }

  void toggleLocation(String location) {
    final currentLocations = List<String>.from(state.selectedLocations);
    if (currentLocations.contains(location)) {
      currentLocations.remove(location);
    } else {
      currentLocations.add(location);
    }
    state = state.copyWith(selectedLocations: currentLocations);
  }

  void toggleRole(String role) {
    final currentRoles = List<String>.from(state.selectedRoles);
    if (currentRoles.contains(role)) {
      currentRoles.remove(role);
    } else {
      currentRoles.add(role);
    }
    state = state.copyWith(selectedRoles: currentRoles);
  }

  void resetFilters() {
    state = EmployeeFilterState(selectedLocations: [], selectedRoles: []);
  }
}

final employeeFilterProvider = NotifierProvider<EmployeeFilterNotifier, EmployeeFilterState>(() {
  return EmployeeFilterNotifier();
});
