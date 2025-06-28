import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/post_cubit.dart';
import '../model/post.dart';
import 'post_form_screen.dart';

// LANGKAH 1: Ubah menjadi StatefulWidget
class PostDetailPage extends StatefulWidget {
  final Post post;

  const PostDetailPage({super.key, required this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  // LANGKAH 2: Buat variabel state untuk menampung data post yang akan ditampilkan.
  late Post currentPost;

  @override
  void initState() {
    super.initState();
    // Inisialisasi dengan data post awal yang diterima widget.
    currentPost = widget.post;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Post'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'edit') {
                // Selalu gunakan 'currentPost' yang terbaru untuk diedit.
                _navigateToForm(context, currentPost);
              } else if (value == 'delete') {
                _showDeleteDialog(context, currentPost);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Hapus', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      // LANGKAH 3: Gunakan BlocListener untuk MENDENGARKAN perubahan dan MEMPERBARUI state
      body: BlocListener<PostCubit, PostState>(
        listener: (context, state) {
          // JIKA UPDATE BERHASIL:
          if (state is PostUpdateSuccess) {
            // Tampilkan Snackbar dengan pesan dari state.
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message), // Gunakan pesan dari state
                  backgroundColor: Colors.green,
                ),
              );
            // Perbarui data di halaman ini menggunakan setState.
            // Ini akan memicu build() ulang dengan data 'currentPost' yang baru.
            setState(() {
              currentPost = state.post;
            });
          }
          // JIKA DELETE BERHASIL:
          else if (state is PostActionSuccess) {
            // Tampilkan snackbar sukses sebelum kembali.
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            // Kembali ke halaman list setelah delete.
            Navigator.of(context).pop();
          }
        },
        // UI akan selalu dibangun menggunakan 'currentPost'
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Post
              if (currentPost.image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    '${currentPost.imageUrl}',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // Judul Post
              Text(
                currentPost.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Tanggal Pembuatan
              Text(
                'Dibuat pada: ${currentPost.createdAt != null ? currentPost.createdAt.toString().substring(0, 10) : 'Unknown'}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              // Konten Post
              Text(
                currentPost.content,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToForm(BuildContext context, Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
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
        title: const Text('Hapus Post'),
        content: Text(
          'Apakah Anda yakin ingin menghapus post "${post.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              postCubit.deletePost(post.slug!);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
