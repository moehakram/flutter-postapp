import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:either_dart/either.dart';
import 'package:posts_app_241117/model/post.dart';
import '../config/app_config.dart';
import '../model/post_action_response.dart';

class PostService {
  Uri _baseUrl(String path) => Uri.parse("${AppConfig.baseUrl}/api/$path");

  Future<Either<String, PostActionResponse<List<Post>>>> getPosts() async {
    try {
      final response = await http.get(
        _baseUrl('posts'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Right(
          PostActionResponse.fromJson(jsonData, (data) {
            return List<Post>.from(data.map((x) => Post.fromJson(x)));
          }),
        );
      } else {
        return Left('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Network error: $e');
    }
  }

  Future<Either<String, PostActionResponse<Post>>> createPost({
    required String title,
    required String content,
    File? imageFile,
  }) async {
    try {
      var request = http.MultipartRequest('POST', _baseUrl('posts'));

      request.fields['title'] = title;
      request.fields['content'] = content;

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return Right(
          PostActionResponse.fromJson(jsonData, (data) => Post.fromJson(data)),
        );
      } else {
        return Left('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Network error: $e');
    }
  }

  Future<Either<String, PostActionResponse<Post>>> updatePost({
    required String slug,
    required String title,
    required String content,
    File? imageFile,
  }) async {
    try {
      var request = http.MultipartRequest('POST', _baseUrl('posts/$slug'));

      request.fields['title'] = title;
      request.fields['content'] = content;
      request.fields['_method'] = 'PUT';

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Right(
          PostActionResponse.fromJson(jsonData, (data) => Post.fromJson(data)),
        );
      } else {
        return Left('Failed to update post: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Network error: $e');
    }
  }

  Future<Either<String, PostActionResponse>> deletePost(String slug) async {
    try {
      final response = await http.delete(
        _baseUrl('posts/$slug'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Right(PostActionResponse.fromJson(jsonData, null));
      } else {
        return Left('Failed to delete post: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Network error: $e');
    }
  }
}
