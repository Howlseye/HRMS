class EmployeeModel {
  final String id;
  final String name;
  final String role;
  final String? avatarAsset;
  final String? phoneNumber;
  final String location;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.role,
    this.avatarAsset,
    this.phoneNumber,
    required this.location,
  });

  EmployeeModel copyWith({
    String? id,
    String? name,
    String? role,
    String? avatarAsset,
    String? phoneNumber,
    String? location,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
    );
  }
}
