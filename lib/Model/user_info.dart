// To parse this JSON data, do
//
//     final userInfoApi = userInfoApiFromJson(jsonString);

import 'dart:convert';

List<UserInfoApi> userInfoApiFromJson(String str) => List<UserInfoApi>.from(json.decode(str).map((x) => UserInfoApi.fromJson(x)));

String userInfoApiToJson(List<UserInfoApi> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserInfoApi {
  UserInfoApi({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.image,
    required this.phone,
    required this.userTypeId,
  });

  final int id;
  final String name;
  final String email;
  final String password;
  final String image;
  final String phone;
  final int userTypeId;

  factory UserInfoApi.fromJson(Map<String, dynamic> json) => UserInfoApi(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    password: json["password"],
    image: json["image"],
    phone: json["phone"],
    userTypeId: json["user_type_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "password": password,
    "image": image,
    "phone": phone,
    "user_type_id": userTypeId,
  };
}
