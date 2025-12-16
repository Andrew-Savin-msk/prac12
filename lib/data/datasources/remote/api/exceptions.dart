import 'package:dio/dio.dart';

/// Базовый класс для сетевых исключений
abstract class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

/// Исключение при таймауте запроса
class TimeoutException extends AppException {
  TimeoutException([super.message = 'Request timeout']);
}

/// Исключение при ошибке 400
class BadRequestException extends AppException {
  BadRequestException([super.message = 'Bad request']);
}

/// Исключение при ошибке 401
class UnauthorizedException extends AppException {
  UnauthorizedException([super.message = 'Unauthorized']);
}

/// Исключение при ошибке сервера (5xx)
class ServerException extends AppException {
  ServerException([super.message = 'Server error']);
}

/// Исключение при сетевой ошибке
class NetworkException extends AppException {
  NetworkException([super.message = 'Network error']);
}

/// Маппинг DioException в AppException
AppException mapDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return TimeoutException(error.message ?? 'Request timeout');

    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      if (statusCode == 400) {
        return BadRequestException('Bad request: ${error.message}');
      } else if (statusCode == 401) {
        return UnauthorizedException('Unauthorized: ${error.message}');
      } else if (statusCode != null && statusCode >= 500) {
        return ServerException('Server error: ${error.message}');
      }
      return BadRequestException('Bad response: ${error.message}');

    case DioExceptionType.connectionError:
      return NetworkException('Connection error: ${error.message}');

    case DioExceptionType.cancel:
      return NetworkException('Request cancelled');

    case DioExceptionType.unknown:
    default:
      return NetworkException('Unknown error: ${error.message}');
  }
}

