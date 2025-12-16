import 'package:dio/dio.dart';
import 'package:prac12/data/datasources/remote/api/exceptions.dart';

/// Интерсептор для логирования запросов и ответов
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('[${options.method}] ${options.uri}');
    if (options.data != null) {
      final dataStr = options.data.toString();
      print('Request body: ${dataStr.length > 200 ? dataStr.substring(0, 200) + "..." : dataStr}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[${response.statusCode}] ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('[${err.response?.statusCode ?? 'ERROR'}] ${err.requestOptions.uri}');
    print('Error: ${err.message}');
    super.onError(err, handler);
  }
}

/// Интерсептор для обработки ошибок
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Если ошибка уже обработана (error является AppException), пробрасываем дальше
    if (err.error is AppException) {
      super.onError(err, handler);
      return;
    }
    
    // Маппим DioException в AppException
    final appException = mapDioException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: appException,
        type: err.type,
        response: err.response,
      ),
    );
  }
}

