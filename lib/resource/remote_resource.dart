import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:either_dart/either.dart';
import '../model/post_action_response.dart';

class RemoteResource {
  static const String baseUrl = 'http://postsapi.test:8000/api';
  static const String baseStorage = 'http://postsapi.test:8000/storage';

  Future<Either<String, PostActionResponse>> getPosts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Right(PostActionResponse.fromJson(jsonData));
      } else {
        return Left('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Network error: $e');
    }
  }

  Future<Either<String, PostActionResponse>> createPost({
    required String title,
    required String content,
    File? imageFile,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/posts'));

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
        return Right(PostActionResponse.fromJson(jsonData));
      } else {
        return Left('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Network error: $e');
    }
  }

  Future<Either<String, PostActionResponse>> updatePost({
    required String slug,
    required String title,
    required String content,
    File? imageFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/posts/$slug'),
      );

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
        return Right(PostActionResponse.fromJson(jsonData));
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
        Uri.parse('$baseUrl/posts/$slug'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Right(PostActionResponse.fromJson(jsonData));
      } else {
        return Left('Failed to delete post: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Network error: $e');
    }
  }
}
