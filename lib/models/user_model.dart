class UserModel {
  final String id;
  final String fullName;
  final String identificationNumber;
  final String phoneNumber;
  final String email;
  final String password;
  final DateTime birthdate;
  final String gender;

  UserModel({
    required this.id,
    required this.fullName,
    required this.identificationNumber,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.birthdate,
    required this.gender,
  });

  // Define copyWith method
  UserModel copyWith({
    String? id,
    String? fullName,
    String? identificationNumber,
    String? phoneNumber,
    String? email,
    String? password,
    DateTime? birthdate,
    String? gender,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      identificationNumber: identificationNumber ?? this.identificationNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      password: password ?? this.password,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      identificationNumber: json['identificationNumber'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      password: json['password'],
      birthdate: DateTime.parse(json['birthdate']),
      gender: json['gender'],
    );
  }
}
