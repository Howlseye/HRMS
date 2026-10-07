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
  final String? expenseApprover;
  final String? company;
  final String? defaultShift;

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
    this.expenseApprover,
    this.company,
    this.defaultShift,
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
    String? expenseApprover,
    String? company,
    String? defaultShift,
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
      expenseApprover: expenseApprover ?? this.expenseApprover,
      company: company ?? this.company,
      defaultShift: defaultShift ?? this.defaultShift,
    );
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> json, {String? avatarAsset}) {
    return EmployeeModel(
      id: json['name'] ?? '',
      name: json['employee_name'] ?? '',
      role: json['designation'] ?? '',
      avatarAsset: avatarAsset,
      phoneNumber: null,
      location: json['branch'] ?? '',
      joinDate: json['date_of_joining'] ?? '',
      email: json['personal_email'] ?? '',
      placement: json['department'] ?? '',
      expenseApprover: json['expense_approver'],
      company: json['company'],
      defaultShift: json['default_shift'],
    );
  }
}
