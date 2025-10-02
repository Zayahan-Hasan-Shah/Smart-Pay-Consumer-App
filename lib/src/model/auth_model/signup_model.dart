import 'dart:convert';

List<SignupModel> signupModelFromJson(String str) =>
    List<SignupModel>.from(json.decode(str).map((x) => SignupModel.fromJson(x)));

String signupModelToJson(SignupModel data) => json.encode(data.toJson());

class SignupModel {
  String name;
  String email;
  String password;
  String phoneNumber;
  String cnic;

  SignupModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.cnic,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) => SignupModel(
    name: json["name"],
    email: json["email"],
    password: json["password"],
    phoneNumber: json["phoneNumber"],
    cnic: json["cnic"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
    "phoneNumber": phoneNumber,
    "cnic": cnic,
  };
}
