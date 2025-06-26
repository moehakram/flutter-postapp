import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app_241117/resource/remote_resource.dart';
import 'package:posts_app_241117/screen/post_detail_page.dart';
import '../cubit/post_cubit.dart';
import '../model/post.dart';
import 'post_form_screen.dart';

class PostListScreen extends StatefulWidget {
  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => context.read<PostCubit>().fetchPosts(),
          ),
        ],
      ),
      body: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {
          if (state is PostError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is PostActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is PostLoading || state is PostActionLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PostLoaded) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return PostCard(
                  post: post,
                  onEdit: () => _navigateToForm(context, post),
                  onDelete: () => _showDeleteDialog(context, post),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PostDetailPage(post: post),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is PostError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () => context.read<PostCubit>().fetchPosts(),
                    child: Text('Coba lagi!'),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text('No posts available'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(context, null),
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToForm(BuildContext context, Post? post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<PostCubit>(),
          child: PostFormScreen(post: post),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Post post) {
    final postCubit = context.read<PostCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete Post'),
        content: Text(
          'Are you sure you want to delete "${post.title ?? 'this post'}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (post.slug != null) {
                postCubit.deletePost(post.slug!);
              }
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const PostCard({
    super.key,
    required this.post,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        onTap: onTap,
        leading: post.image != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(
                  '${RemoteResource.baseStorage}/${post.image}',
                ),
              )
            : CircleAvatar(child: Icon(Icons.broken_image)),
        title: Text(post.title ?? 'No Title'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.content ?? 'No Content',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              'Created: ${post.createdAt != null ? post.createdAt.toString().substring(0, 10) : 'Unknown'}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            }
          },
        ),
      ),
    );
  }
}
