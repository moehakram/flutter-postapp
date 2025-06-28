part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

// State awal sebelum ada aksi apapun.
class AuthInitial extends AuthState {}

// State ketika sedang memproses otentikasi (login/logout).
class AuthLoading extends AuthState {}

// State ketika pengguna berhasil login.
class AuthAuthenticated extends AuthState {}

// State ketika pengguna tidak login atau setelah logout.
class AuthUnauthenticated extends AuthState {}

// State jika terjadi error saat otentikasi.
class AuthError extends AuthState {
  final String message;
  final Map<String, dynamic>? errors;
  const AuthError({required this.message, this.errors});

  // @override
  // List<Object> get props => [message];
}
