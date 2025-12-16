import 'package:dio/dio.dart';
import 'package:prac12/core/constants/supabase_config.dart';
import 'package:prac12/core/models/account/auth_tokens.dart';
import 'package:prac12/core/models/account/user_account_model.dart';
import 'package:prac12/data/datasources/account/dto/supabase_auth_response_dto.dart';
import 'package:prac12/data/datasources/account/dto/supabase_user_dto.dart';
import 'package:prac12/data/datasources/account/supabase_auth_mapper.dart';
import 'package:prac12/data/datasources/account/supabase_user_mapper.dart';
import 'package:prac12/data/datasources/remote/api/exceptions.dart';

/// Remote datasource для работы с Supabase Auth API
/// Использует только Dio, без SDK
class SupabaseAuthRemoteDataSource {
  final Dio _dio;

  SupabaseAuthRemoteDataSource(this._dio);

  /// Проверка конфигурации Supabase
  void _checkConfiguration() {
    if (!SupabaseConfig.isConfigured) {
      throw Exception(
        'Supabase не настроен. Используйте --dart-define для передачи SUPABASE_URL и SUPABASE_ANON_KEY.\n'
        'Пример: flutter run --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your-key',
      );
    }
  }

  /// POST /signup - Регистрация нового пользователя
  /// Возвращает AuthTokens и данные пользователя из ответа
  Future<({AuthTokens tokens, SupabaseUserDto? user})> signUpWithUser({
    required String email,
    required String password,
    String? fullName,
  }) async {
    _checkConfiguration();
    try {
      final body = <String, dynamic>{
        'email': email,
        'password': password,
      };

      if (fullName != null && fullName.isNotEmpty) {
        body['data'] = {'full_name': fullName};
      }

      print('Signup request body: $body');
      print('Using API key: ${SupabaseConfig.supabaseAnonKey.substring(0, 20)}...');
      print('Request URL: ${SupabaseConfig.authBaseUrl}/signup');

      final response = await _dio.post<Map<String, dynamic>>(
        '/signup',
        data: body,
      );

      print('Signup response: ${response.data}');

      final dto = SupabaseAuthResponseDto.fromJson(response.data!);
      print('Parsed DTO - accessToken: ${dto.accessToken != null ? "present" : "null"}, user: ${dto.user?.id ?? "null"}');
      
      return (
        tokens: SupabaseAuthMapper.toAuthTokens(dto),
        user: dto.user,
      );
    } on DioException catch (e) {
      print('Signup error: ${e.response?.data}');
      print('Status code: ${e.response?.statusCode}');
      print('Request URL: ${e.requestOptions.uri}');
      print('Request body: ${e.requestOptions.data}');
      
      if (e.response?.statusCode == 401) {
        throw Exception(
          'Ошибка авторизации (401). Возможно, используется неправильный ключ.\n'
          'Для Supabase Auth API нужен anon key (JWT токен, начинается с eyJ...), а не publishable key.\n'
          'Проверьте Settings → API в вашем проекте Supabase и используйте anon public key.'
        );
      }
      if (e.response?.statusCode == 422) {
        final errorData = e.response?.data;
        final errorMessage = errorData is Map 
            ? errorData['message'] ?? errorData['error_description'] ?? errorData.toString()
            : errorData?.toString() ?? 'Validation error';
        throw Exception('Ошибка регистрации: $errorMessage');
      }
      
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      rethrow;
    }
  }

  /// POST /signup - Регистрация нового пользователя (старый метод для совместимости)
  Future<AuthTokens> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final result = await signUpWithUser(
      email: email,
      password: password,
      fullName: fullName,
    );
    return result.tokens;
  }

  /// POST /token?grant_type=password - Логин по email и паролю
  Future<AuthTokens> signInWithPassword({
    required String email,
    required String password,
  }) async {
    _checkConfiguration();
    try {
      print('Login request - email: $email');
      print('Request URL: ${SupabaseConfig.authBaseUrl}/token?grant_type=password');
      
      final response = await _dio.post<Map<String, dynamic>>(
        '/token',
        queryParameters: {'grant_type': 'password'},
        data: {
          'email': email,
          'password': password,
        },
      );

      print('Login response: ${response.data}');

      final dto = SupabaseAuthResponseDto.fromJson(response.data!);
      return SupabaseAuthMapper.toAuthTokens(dto);
    } on DioException catch (e) {
      print('Login error: ${e.response?.data}');
      print('Status code: ${e.response?.statusCode}');
      print('Request URL: ${e.requestOptions.uri}');
      print('Request body: ${e.requestOptions.data}');
      
      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        final errorMessage = errorData is Map 
            ? errorData['message'] ?? errorData['error_description'] ?? errorData.toString()
            : errorData?.toString() ?? 'Bad request';
        throw Exception('Ошибка входа: $errorMessage');
      }
      if (e.response?.statusCode == 401) {
        throw Exception('Неверный email или пароль');
      }
      
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      rethrow;
    }
  }

  /// POST /token?grant_type=refresh_token - Обновление токена
  Future<AuthTokens> refreshToken(String refreshToken) async {
    _checkConfiguration();
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/token',
        queryParameters: {'grant_type': 'refresh_token'},
        data: {
          'refresh_token': refreshToken,
        },
      );

      final dto = SupabaseAuthResponseDto.fromJson(response.data!);
      return SupabaseAuthMapper.toAuthTokens(dto);
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      rethrow;
    }
  }

  /// GET /user - Получить текущего пользователя по access token
  Future<UserAccount> getUser(String accessToken) async {
    _checkConfiguration();
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/user',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      final dto = SupabaseUserDto.fromJson(response.data!);
      return SupabaseUserMapper.toUserAccount(dto);
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      rethrow;
    }
  }

  /// PUT /user - Обновить профиль пользователя
  Future<UserAccount> updateUser({
    required String accessToken,
    String? fullName,
  }) async {
    _checkConfiguration();
    try {
      final body = <String, dynamic>{};
      if (fullName != null && fullName.isNotEmpty) {
        body['data'] = {'full_name': fullName};
      }

      final response = await _dio.put<Map<String, dynamic>>(
        '/user',
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      final dto = SupabaseUserDto.fromJson(response.data!);
      return SupabaseUserMapper.toUserAccount(dto);
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      rethrow;
    }
  }

  /// POST /logout - Выход из системы
  Future<void> logout(String accessToken) async {
    _checkConfiguration();
    try {
      await _dio.post(
        '/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      rethrow;
    }
  }
}

