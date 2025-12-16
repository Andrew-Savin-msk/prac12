import 'package:prac12/data/datasources/account/account_local_datasource.dart';
import 'package:prac12/data/datasources/account/account_secure_storage_data_source.dart';
import 'package:prac12/data/datasources/account/supabase_auth_remote_datasource.dart';
import 'package:prac12/data/datasources/account/supabase_user_mapper.dart';
import 'package:prac12/core/models/account/user_account_model.dart';
import 'package:prac12/core/models/account/auth_tokens.dart';
import 'package:prac12/domain/repositories/account/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountLocalDataSource _dataSource;
  final AccountSecureStorageDataSource _secureStorage;
  final SupabaseAuthRemoteDataSource _supabaseAuth;

  AccountRepositoryImpl(
    this._dataSource,
    this._secureStorage,
    this._supabaseAuth,
  );
  
  /// Инициализация: загрузить пользователей из SQLite при старте
  Future<void> initialize() async {
    await _dataSource.initialize();
  }

  @override
  UserAccount? getCurrentUser() {
    // Возвращаем локально сохраненного пользователя
    // Для получения свежих данных используем getCurrentUserFromRemote
    return _dataSource.getCurrentUser();
  }
  
  /// Получить текущего пользователя из Supabase (GET /user)
  Future<UserAccount> getCurrentUserFromRemote() async {
    print('=== getCurrentUserFromRemote START ===');
    final tokens = await getAuthTokens();
    print('Retrieved tokens: ${tokens != null ? "exists" : "null"}');
    if (tokens != null) {
      print('Access token length: ${tokens.accessToken.length}');
      print('Access token first 20 chars: ${tokens.accessToken.length > 20 ? tokens.accessToken.substring(0, 20) + "..." : tokens.accessToken}');
      print('User ID: ${tokens.userId}');
      print('User email: ${tokens.userEmail}');
    }
    
    if (tokens == null || tokens.accessToken.isEmpty) {
      print('ERROR: No access token available');
      throw Exception('No access token available');
    }
    
    try {
      print('Calling _supabaseAuth.getUser with token...');
      final user = await _supabaseAuth.getUser(tokens.accessToken);
      print('Successfully fetched user from Supabase: ${user.id}, ${user.email}');
      await saveUserData(user);
      print('User data saved locally');
      _dataSource.setCurrentUser(user);
      print('Current user set in dataSource');
      print('=== getCurrentUserFromRemote SUCCESS ===');
      return user;
    } catch (e, stackTrace) {
      print('ERROR fetching user from Supabase: $e');
      print('Stack trace: $stackTrace');
      print('=== getCurrentUserFromRemote ERROR ===');
      rethrow;
    }
  }

  @override
  bool get isLoggedIn => _dataSource.isLoggedIn;

  @override
  Future<UserAccount> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // POST /signup через Supabase (получаем токены и данные пользователя)
    final signupResult = await _supabaseAuth.signUpWithUser(
      email: email,
      password: password,
      fullName: name,
    );
    
    final tokens = signupResult.tokens;
    final userFromResponse = signupResult.user;
    
    // Сохраняем токены
    await saveAuthTokens(tokens);
    
    // Пытаемся получить данные пользователя
    UserAccount user;
    
    if (userFromResponse != null) {
      // Используем данные пользователя из ответа signup
      user = SupabaseUserMapper.toUserAccount(userFromResponse);
      print('Using user data from signup response');
    } else if (tokens.accessToken.isNotEmpty) {
      // Если данных пользователя нет в ответе, делаем запрос GET /user
      try {
        user = await _supabaseAuth.getUser(tokens.accessToken);
        print('Fetched user data via GET /user');
      } catch (e) {
        // Если запрос не удался, создаем пользователя из доступных данных
        print('Warning: Could not fetch user after signup: $e');
        user = UserAccount(
          id: tokens.userId ?? '',
          name: name,
          email: tokens.userEmail ?? email,
          password: '',
        );
      }
    } else {
      // Если токена нет, создаем пользователя из доступных данных
      user = UserAccount(
        id: tokens.userId ?? '',
        name: name,
        email: tokens.userEmail ?? email,
        password: '',
      );
    }
    
    // Сохраняем данные пользователя локально
    await saveUserData(user);
    _dataSource.setCurrentUser(user);
    
    return user;
  }

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    print('=== LOGIN START ===');
    print('Email: $email');
    
    // POST /token?grant_type=password через Supabase
    print('Calling _supabaseAuth.signInWithPassword...');
    final tokens = await _supabaseAuth.signInWithPassword(
      email: email,
      password: password,
    );
    print('SignInWithPassword successful');
    print('Tokens received:');
    print('  - Access token length: ${tokens.accessToken.length}');
    print('  - Access token first 20: ${tokens.accessToken.length > 20 ? tokens.accessToken.substring(0, 20) + "..." : tokens.accessToken}');
    print('  - Refresh token: ${tokens.refreshToken != null ? "exists" : "null"}');
    print('  - User ID: ${tokens.userId}');
    print('  - User email: ${tokens.userEmail}');
    
    // Сохраняем токены
    print('Saving auth tokens...');
    await saveAuthTokens(tokens);
    print('Auth tokens saved');
    
    // Проверяем, что токены сохранились
    final savedTokens = await getAuthTokens();
    print('Verification - retrieved tokens after save:');
    if (savedTokens != null) {
      print('  - Access token length: ${savedTokens.accessToken.length}');
      print('  - Access token matches: ${savedTokens.accessToken == tokens.accessToken}');
    } else {
      print('  - ERROR: Tokens are null after save!');
    }
    
    // Получаем данные пользователя
    print('Fetching user data via GET /user...');
    UserAccount user;
    try {
      if (tokens.accessToken.isNotEmpty) {
        user = await _supabaseAuth.getUser(tokens.accessToken);
        print('Fetched user data via GET /user after login: ${user.id}, ${user.email}');
      } else {
        print('ERROR: Access token is empty, cannot fetch user');
        throw Exception('Access token is empty after login');
      }
    } catch (e, stackTrace) {
      print('ERROR: Could not fetch user after login: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
    
    // Сохраняем данные пользователя локально
    print('Saving user data locally...');
    await saveUserData(user);
    print('User data saved');
    _dataSource.setCurrentUser(user);
    print('Current user set in dataSource');
    print('=== LOGIN SUCCESS ===');
  }

  @override
  Future<void> logout() async {
    // POST /logout через Supabase
    final tokens = await getAuthTokens();
    if (tokens != null && tokens.accessToken.isNotEmpty) {
      try {
        await _supabaseAuth.logout(tokens.accessToken);
      } catch (e) {
        // Игнорируем ошибки при logout (токен может быть уже невалидным)
        print('Error during logout: $e');
      }
    }
    
    _dataSource.logout();
    // Очищаем токены при выходе
    clearAuthTokens();
  }

  @override
  Future<void> saveAuthTokens(AuthTokens tokens) async {
    print('=== saveAuthTokens START ===');
    print('Access token length: ${tokens.accessToken.length}');
    print('Refresh token: ${tokens.refreshToken != null ? "exists" : "null"}');
    print('User ID: ${tokens.userId}');
    print('User email: ${tokens.userEmail}');
    await _secureStorage.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      userId: tokens.userId,
      userEmail: tokens.userEmail,
    );
    print('=== saveAuthTokens COMPLETE ===');
  }

  @override
  Future<AuthTokens?> getAuthTokens() async {
    print('=== getAuthTokens START ===');
    final tokens = await _secureStorage.readTokens();
    if (tokens != null) {
      print('Tokens retrieved:');
      print('  - Access token length: ${tokens.accessToken.length}');
      print('  - Refresh token: ${tokens.refreshToken != null ? "exists" : "null"}');
      print('  - User ID: ${tokens.userId}');
      print('  - User email: ${tokens.userEmail}');
    } else {
      print('Tokens are NULL');
    }
    print('=== getAuthTokens COMPLETE ===');
    return tokens;
  }

  @override
  Future<void> clearAuthTokens() async {
    await _secureStorage.clearTokens();
  }

  @override
  Future<void> saveUserData(UserAccount user) async {
    await _secureStorage.saveUserData(user);
  }

  @override
  Future<void> restoreSession() async {
    // Если пользователь уже залогинен, ничего не делаем
    if (_dataSource.isLoggedIn) {
      return;
    }

    // Читаем токены из secure storage
    final tokens = await getAuthTokens();
    if (tokens == null || tokens.refreshToken == null || tokens.refreshToken!.isEmpty) {
      // Нет токенов - очищаем всё
      await clearAuthTokens();
      return;
    }

    try {
      // POST /token?grant_type=refresh_token через Supabase
      final newTokens = await _supabaseAuth.refreshToken(tokens.refreshToken!);
      
      // Сохраняем новые токены
      await saveAuthTokens(newTokens);
      
      // Получаем данные пользователя
      final user = await _supabaseAuth.getUser(newTokens.accessToken);
      
      // Сохраняем данные пользователя локально
      await saveUserData(user);
      _dataSource.setCurrentUser(user);
    } catch (e) {
      // Ошибка при восстановлении сессии - очищаем токены
      print('Error restoring session: $e');
      await clearAuthTokens();
    }
  }

  @override
  Future<void> updateProfile({
    required String name,
    required String email,
    String? avatarUrl,
  }) async {
    final tokens = await getAuthTokens();
    if (tokens == null || tokens.accessToken.isEmpty) {
      throw Exception('No access token available');
    }
    
    // PUT /user через Supabase
    final updatedUser = await _supabaseAuth.updateUser(
      accessToken: tokens.accessToken,
      fullName: name,
    );
    
    // Обновляем локальные данные
    await saveUserData(updatedUser);
    _dataSource.setCurrentUser(updatedUser);
  }
}

