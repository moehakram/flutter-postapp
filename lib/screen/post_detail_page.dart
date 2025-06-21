import 'package:flutter/material.dart';
import 'package:posts_app_241117/resource/remote_resource.dart';
import '../model/post.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;

  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final imageUrl = post.image != null
        ? '${RemoteResource.baseStorage}/${post.image}'
        : null;

    return Scaffold(
      appBar: AppBar(title: Text(post.title ?? 'Post Detail')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imageUrl),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.image, size: 100, color: Colors.grey[600]),
              ),
            SizedBox(height: 16),
            Text(
              post.title ?? 'No Title',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 8),
            Text(
              'Slug: ${post.slug ?? '-'}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            Text(post.content ?? 'No Content', style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            Text(
              'Created: ${post.createdAt?.toLocal().toString().substring(0, 19) ?? 'Unknown'}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 4),
            Text(
              'Updated: ${post.updatedAt?.toLocal().toString().substring(0, 19) ?? 'Unknown'}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
