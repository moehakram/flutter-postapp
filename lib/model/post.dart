import 'dart:convert';

class Post {
  final int? id;
  final String? image;
  final String? title;
  final String? slug;
  final String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Post({
    this.id,
    this.image,
    this.title,
    this.slug,
    this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    image: json["image"],
    title: json["title"],
    slug: json["slug"],
    content: json["content"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "title": title,
    "slug": slug,
    "content": content,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
