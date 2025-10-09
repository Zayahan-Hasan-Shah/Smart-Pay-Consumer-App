import 'dart:convert';

List<SignupModel> signupModelFromJson(String str) => List<SignupModel>.from(
  json.decode(str).map((x) => SignupModel.fromJson(x)),
);

String signupModelToJson(SignupModel data) => json.encode(data.toJson());

class SignupModel {
  final String message;

  SignupModel({required this.message});

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(message: json["message"] ?? "");
  }

  Map<String, dynamic> toJson() => {"message": message};
}
