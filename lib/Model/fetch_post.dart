// To parse this JSON data, do
//
//     final postApi = postApiFromJson(jsonString);

import 'dart:convert';

List<PostApi> postApiFromJson(String str) => List<PostApi>.from(json.decode(str).map((x) => PostApi.fromJson(x)));

String postApiToJson(List<PostApi> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostApi {
  PostApi({
    required this.id,
    required this.postApiUserId,
    required this.title,
    required this.description,
    required this.image,
    required this.staus,
    required this.type,
    required this.createdAt,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.userImage,
    required this.userTypeId,
  });

  final int id;
  final int postApiUserId;
  final String title;
  final String description;
  final String image;
  final String staus;
  final String type;
  final DateTime createdAt;
  final int userId;
  final String name;
  final String email;
  final String phone;
  final String userImage;
  final int userTypeId;

  factory PostApi.fromJson(Map<String, dynamic> json) => PostApi(
    id: json["id"],
    postApiUserId: json["user_id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
    staus: json["staus"],
    type: json["type"],
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
    "user_id": postApiUserId,
    "title": title,
    "description": description,
    "image": image,
    "staus": staus,
    "type": type,
    "created_at": createdAt.toIso8601String(),
    "userID": userId,
    "name": name,
    "email": email,
    "phone": phone,
    "UserImage": userImage,
    "user_type_id": userTypeId,
  };
}
