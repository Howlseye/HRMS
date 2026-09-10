class ProfileModel {
  final String name;
  final String role;
  final String? avatarAsset;

  ProfileModel({
    required this.name,
    required this.role,
    this.avatarAsset,
  });
}
