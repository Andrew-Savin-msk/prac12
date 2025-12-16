import 'dart:io';

/// Конфигурация Supabase
/// 
/// Поддерживает два способа передачи значений:
/// 1. Через --dart-define (приоритет)
/// 2. Через переменные окружения (SUPABASE_URL и SUPABASE_ANON_KEY)
/// 
/// Для установки переменных окружения:
/// - macOS/Linux: export SUPABASE_URL=... && export SUPABASE_ANON_KEY=...
/// - Windows: set SUPABASE_URL=... && set SUPABASE_ANON_KEY=...
class SupabaseConfig {
  /// URL Supabase проекта
  static String get supabaseUrl {
    // Сначала проверяем --dart-define
    const dartDefineUrl = String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: '',
    );
    if (dartDefineUrl.isNotEmpty && dartDefineUrl != 'YOUR-PROJECT-REF.supabase.co') {
      return dartDefineUrl;
    }
    
    // Затем проверяем переменные окружения
    final envUrl = Platform.environment['SUPABASE_URL'];
    if (envUrl != null && envUrl.isNotEmpty) {
      return envUrl;
    }
    
    // Дефолтное значение
    return 'https://YOUR-PROJECT-REF.supabase.co';
  }

  /// Anon key для Supabase
  static String get supabaseAnonKey {
    // Сначала проверяем --dart-define
    const dartDefineKey = String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: '',
    );
    if (dartDefineKey.isNotEmpty && dartDefineKey != 'YOUR_ANON_KEY') {
      return dartDefineKey;
    }
    
    // Затем проверяем переменные окружения
    final envKey = Platform.environment['SUPABASE_ANON_KEY'];
    if (envKey != null && envKey.isNotEmpty) {
      return envKey;
    }
    
    // Дефолтное значение
    return 'YOUR_ANON_KEY';
  }

  /// Base URL для Supabase Auth API
  static String get authBaseUrl => '$supabaseUrl/auth/v1';

  /// Проверка, что конфигурация настроена правильно
  static bool get isConfigured {
    return supabaseUrl != 'https://YOUR-PROJECT-REF.supabase.co' &&
           supabaseAnonKey != 'YOUR_ANON_KEY';
  }

  SupabaseConfig._();
}

