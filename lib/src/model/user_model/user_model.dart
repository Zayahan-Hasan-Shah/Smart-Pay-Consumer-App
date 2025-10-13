import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int userId;
  String name;
  String email;
  String phoneNumber;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userId: json["userId"],
    name: json["name"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "name": name,
    "email": email,
    "phoneNumber": phoneNumber,
  };
}
