import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/auth_cubit.dart';
import 'screen/login_screen.dart';
import 'services/auth_service.dart';
import 'cubit/post_cubit.dart';
import 'services/post_service.dart';
import 'screen/post_list_screen.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PostCubit(PostService())),
        BlocProvider(
          create: (_) => AuthCubit(AuthService())..checkAuthStatus(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          // Selama state awal atau loading, tampilkan splash screen
          if (state is AuthInitial || state is AuthLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          // Jika sudah terotentikasi, tampilkan halaman post
          else if (state is AuthAuthenticated) {
            return PostListScreen();
          }
          // Jika tidak, tampilkan halaman login
          else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
