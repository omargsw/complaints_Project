// To parse this JSON data, do
//
//     final commentApi = commentApiFromJson(jsonString);

import 'dart:convert';

List<CommentApi> commentApiFromJson(String str) => List<CommentApi>.from(json.decode(str).map((x) => CommentApi.fromJson(x)));

String commentApiToJson(List<CommentApi> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentApi {
  CommentApi({
    required this.id,
    required this.postId,
    required this.commentApiUserId,
    required this.description,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.userTypeId,
  });

  final int id;
  final int postId;
  final int commentApiUserId;
  final String description;
  final int userId;
  final String name;
  final String email;
  final String phone;
  final String image;
  final int userTypeId;

  factory CommentApi.fromJson(Map<String, dynamic> json) => CommentApi(
    id: json["id"],
    postId: json["post_id"],
    commentApiUserId: json["user_id"],
    description: json["description"],
    userId: json["userID"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    image: json["image"],
    userTypeId: json["user_type_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "post_id": postId,
    "user_id": commentApiUserId,
    "description": description,
    "userID": userId,
    "name": name,
    "email": email,
    "phone": phone,
    "image": image,
    "user_type_id": userTypeId,
  };
}
