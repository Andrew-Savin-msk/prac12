import 'package:dio/dio.dart';
import 'package:prac12/data/datasources/remote/api/interceptors.dart';

/// Создает настроенный Dio клиент
Dio createDioClient({
  required String baseUrl,
  Map<String, String>? defaultHeaders,
  Duration? connectTimeout,
  Duration? receiveTimeout,
  Duration? sendTimeout,
  bool enableLogging = true,
  bool enableErrorMapping = true,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout ?? const Duration(seconds: 30),
      receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
      sendTimeout: sendTimeout ?? const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        ...?defaultHeaders,
      },
    ),
  );

  if (enableLogging) {
    dio.interceptors.add(LoggingInterceptor());
  }

  if (enableErrorMapping) {
    dio.interceptors.add(ErrorInterceptor());
  }

  return dio;
}

