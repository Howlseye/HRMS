class BenefitTypeModel {
  final String name;

  BenefitTypeModel({required this.name});

  factory BenefitTypeModel.fromJson(Map<String, dynamic> json) {
    return BenefitTypeModel(
      name: json['name'] as String? ?? '',
    );
  }
}
