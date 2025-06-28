import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  String? _token;

  AuthCubit(this._authService) : super(AuthInitial());

  String? get token => _token;

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    emit(AuthUnauthenticated());
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await _authService.login(email, password);

    result.fold(
      (error) async {
        emit(AuthUnauthenticated());
        await Future.delayed(const Duration(milliseconds: 500));
        emit(AuthError(message: error.message, errors: error.errors));
      },
      (loginResponse) {
        _token = loginResponse.token;
        emit(AuthAuthenticated());
      },
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await _authService.logout();
    _token = null;
    emit(AuthUnauthenticated());
  }
}
