import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../model/post.dart';
import '../resource/remote_resource.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final RemoteResource _remoteResource;

  PostCubit(this._remoteResource) : super(PostInitial());

  Future<void> fetchPosts() async {
    emit(PostLoading());
    final result = await _remoteResource.getPosts();

    result.fold((error) => emit(PostError(error)), (response) {
      if (response.success == true && response.data != null) {
        emit(PostLoaded(response.data!));
      } else {
        emit(PostError(response.message ?? 'Unknown error'));
      }
    });
  }

  Future<void> createPost({
    required String title,
    required String content,
    File? imageFile,
  }) async {
    emit(PostActionLoading());
    final result = await _remoteResource.createPost(
      title: title,
      content: content,
      imageFile: imageFile,
    );

    result.fold((error) => emit(PostError(error)), (response) {
      if (response.success == true) {
        emit(
          PostActionSuccess(response.message ?? 'Post created successfully'),
        );
        fetchPosts(); // Refresh the list
      } else {
        emit(PostError(response.message ?? 'Failed to create post'));
      }
    });
  }

  Future<void> updatePost({
    required String slug,
    required String title,
    required String content,
    File? imageFile,
  }) async {
    emit(PostActionLoading());
    final result = await _remoteResource.updatePost(
      slug: slug,
      title: title,
      content: content,
      imageFile: imageFile,
    );

    result.fold((error) => emit(PostError(error)), (response) {
      if (response.success == true) {
        emit(
          PostActionSuccess(response.message ?? 'Post updated successfully'),
        );
        fetchPosts(); // Refresh the list
      } else {
        emit(PostError(response.message ?? 'Failed to update post'));
      }
    });
  }

  Future<void> deletePost(String slug) async {
    emit(PostActionLoading());
    final result = await _remoteResource.deletePost(slug);

    result.fold((error) => emit(PostError(error)), (response) {
      if (response.success == true) {
        emit(
          PostActionSuccess(response.message ?? 'Post deleted successfully'),
        );
        fetchPosts(); // Refresh the list
      } else {
        emit(PostError(response.message ?? 'Failed to delete post'));
      }
    });
  }
}
