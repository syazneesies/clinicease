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
