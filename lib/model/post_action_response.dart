class PostActionResponse<T> {
  final bool? success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? errors;

  PostActionResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory PostActionResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? dataParser,
  ) {
    return PostActionResponse<T>(
      success: json['success'],
      message: json['message'],
      data: dataParser != null && json['data'] != null
          ? dataParser(json['data'])
          : json['data'],
      errors: json['errors']?.cast<String, dynamic>(),
    );
  }
}
