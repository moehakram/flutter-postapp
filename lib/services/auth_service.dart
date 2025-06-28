import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../model/auth_dto.dart';

class AuthService {
  Uri get _baseUrl => Uri.parse("${AppConfig.baseUrl}/api/login");

  Future<Either<ErrorResponseDto, LoginResponseDto>> login(
    String email,
    String password,
  ) async {
    final requestDto = LoginRequestDto(email: email, password: password);

    try {
      final response = await http.post(
        _baseUrl,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(requestDto.toJson()),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Right(LoginResponseDto.fromJson(responseBody));
      } else {
        final errorDto = ErrorResponseDto.fromJson(responseBody);
        return Left(errorDto);
      }
    } catch (e) {
      return Left(
        ErrorResponseDto(message: e.toString().replaceAll('Exception: ', '')),
      );
    }
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
