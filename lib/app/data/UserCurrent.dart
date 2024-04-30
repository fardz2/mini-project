class UserCurrent {
  String id;
  final String name;
  final String? email;
  final String phoneNumber;
  final String address;
  final String? image;

  UserCurrent({
    this.id = "",
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.image,
  });

  factory UserCurrent.fromJson(Map<String, dynamic> json) {
    return UserCurrent(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      phoneNumber: json['phoneNumber'] as String,
      image: json['image'] as String,
    );
  }
}
