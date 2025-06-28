import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app_241117/cubit/auth_cubit.dart';
import 'components/post_grid_item.dart';
import '../screen/post_detail_page.dart';
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
    // Memuat data post saat layar pertama kali dibuka
    context.read<PostCubit>().fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts Grid'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Tombol untuk memuat ulang data
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => context.read<PostCubit>().fetchPosts(),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
      body: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {
          // Menampilkan pesan error atau sukses
          if (state is PostError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is PostActionSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          // Menampilkan loading indicator saat data sedang dimuat
          if (state is PostLoading || state is PostActionLoading) {
            return Center(child: CircularProgressIndicator());
          }
          // Menampilkan grid jika data berhasil dimuat
          else if (state is PostLoaded) {
            if (state.posts.isEmpty) {
              return Center(child: Text('Tidak ada post yang tersedia.'));
            }
            // Menggunakan GridView.builder untuk menampilkan data dalam bentuk grid
            return GridView.builder(
              padding: const EdgeInsets.all(12.0),
              // Konfigurasi layout grid
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 kolom
                crossAxisSpacing: 12.0, // Jarak horizontal antar item
                mainAxisSpacing: 12.0, // Jarak vertikal antar item
                childAspectRatio:
                    3 / 4, // Rasio aspek item (lebar / tinggi) disesuaikan
              ),
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                // Menggunakan widget PostGridItem yang sudah disederhanakan
                return PostGridItem(
                  post: post,
                  onTap: () => _navigateToDetail(context, post),
                );
              },
            );
          }
          // Menampilkan pesan error jika terjadi kesalahan
          else if (state is PostError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.read<PostCubit>().fetchPosts(),
                    child: Text('Coba lagi!'),
                  ),
                ],
              ),
            );
          }
          // Fallback jika tidak ada state yang cocok
          return Center(child: Text('Silakan muat ulang untuk melihat post.'));
        },
      ),
      // Tombol untuk menambah post baru
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(context, null),
        tooltip: 'Tambah Post',
        child: Icon(Icons.add),
      ),
    );
  }

  // Navigasi ke halaman detail dengan menyediakan PostCubit
  void _navigateToDetail(BuildContext context, Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // Bungkus PostDetailPage dengan BlocProvider.value untuk meneruskan PostCubit
        builder: (_) => BlocProvider.value(
          value: context.read<PostCubit>(),
          child: PostDetailPage(post: post),
        ),
      ),
    );
  }

  // Navigasi ke halaman form untuk tambah/edit post
  void _navigateToForm(BuildContext context, Post? post) {
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
}
