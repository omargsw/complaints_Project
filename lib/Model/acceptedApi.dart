// To parse this JSON data, do
//
//     final acceptedApi = acceptedApiFromJson(jsonString);

import 'dart:convert';

List<AcceptedApi> acceptedApiFromJson(String str) => List<AcceptedApi>.from(json.decode(str).map((x) => AcceptedApi.fromJson(x)));

String acceptedApiToJson(List<AcceptedApi> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AcceptedApi {
  AcceptedApi({
    required this.id,
    required this.acceptedApiUserId,
    required this.title,
    required this.description,
    required this.image,
    required this.status,
    required this.type,
    required this.active,
    required this.acceptedId,
    required this.createdAt,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.userImage,
    required this.userTypeId,
  });

  final int id;
  final int acceptedApiUserId;
  final String title;
  final String description;
  final String image;
  final String status;
  final String type;
  final String active;
  final String acceptedId;
  final DateTime createdAt;
  final int userId;
  final String name;
  final String email;
  final String phone;
  final String userImage;
  final int userTypeId;

  factory AcceptedApi.fromJson(Map<String, dynamic> json) => AcceptedApi(
    id: json["id"],
    acceptedApiUserId: json["user_id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
    status: json["status"],
    type: json["type"],
    active: json["active"],
    acceptedId: json["accepted_id"],
    createdAt: DateTime.parse(json["created_at"]),
    userId: json["userID"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    userImage: json["UserImage"],
    userTypeId: json["user_type_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": acceptedApiUserId,
    "title": title,
    "description": description,
    "image": image,
    "status": status,
    "type": type,
    "active": active,
    "accepted_id": acceptedId,
    "created_at": createdAt.toIso8601String(),
    "userID": userId,
    "name": name,
    "email": email,
    "phone": phone,
    "UserImage": userImage,
    "user_type_id": userTypeId,
  };
}
