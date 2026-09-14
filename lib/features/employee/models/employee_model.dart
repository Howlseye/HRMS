class EmployeeModel {
  final String id;
  final String name;
  final String role;
  final String? avatarAsset;
  final String? phoneNumber;
  final String location;
  final String joinDate;
  final String email;
  final String placement;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.role,
    this.avatarAsset,
    this.phoneNumber,
    required this.location,
    required this.joinDate,
    required this.email,
    required this.placement,
  });

  EmployeeModel copyWith({
    String? id,
    String? name,
    String? role,
    String? avatarAsset,
    String? phoneNumber,
    String? location,
    String? joinDate,
    String? email,
    String? placement,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      joinDate: joinDate ?? this.joinDate,
      email: email ?? this.email,
      placement: placement ?? this.placement,
    );
  }
}
