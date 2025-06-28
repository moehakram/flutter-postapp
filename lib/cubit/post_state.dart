part of 'post_cubit.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;

  const PostLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

class PostError extends PostState {
  final String message;

  const PostError(this.message);

  @override
  List<Object> get props => [message];
}

class PostActionLoading extends PostState {}

class PostActionSuccess extends PostState {
  final String message;

  const PostActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class PostUpdateSuccess extends PostState {
  final Post post;
  final String message;

  const PostUpdateSuccess(this.post, this.message);

  @override
  List<Object> get props => [post, message];
}
