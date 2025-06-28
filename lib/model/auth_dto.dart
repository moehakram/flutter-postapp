// Data Transfer Object untuk permintaan login.
class LoginRequestDto {
  final String email;
  final String password;

  LoginRequestDto({required this.email, required this.password});

  // Mengonversi objek DTO menjadi format JSON untuk dikirim ke API.
  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

// Data Transfer Object untuk respons login yang berhasil.
class LoginResponseDto {
  final String? token;

  LoginResponseDto({required this.token});

  // Factory constructor untuk membuat objek DTO dari data JSON yang diterima dari API.
  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(token: json['token'] as String);
  }
}

// DTO untuk respons error dari API.
class ErrorResponseDto {
  final Map<String, dynamic>? errors;
  final String message;

  ErrorResponseDto({this.errors, required this.message});

  factory ErrorResponseDto.fromJson(Map<String, dynamic> json) {
    return ErrorResponseDto(errors: json['errors'], message: json['message']);
  }
}
