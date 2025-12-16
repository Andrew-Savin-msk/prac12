# prac12

Flutter проект с Clean Architecture.

## Настройка Supabase Auth

Для работы функций авторизации необходимо настроить Supabase.

### 1. Создайте проект в Supabase

1. Перейдите на [supabase.com](https://supabase.com)
2. Зарегистрируйтесь или войдите
3. Создайте новый проект (или используйте существующий)
4. Дождитесь завершения создания проекта (обычно 1-2 минуты)

### 2. Получите ключи

1. В проекте Supabase перейдите в **Settings** → **API**
2. Найдите следующие значения:
   - **Project URL** (например: `https://abcdefghijklmnop.supabase.co`)
   - **anon public** key (длинная строка, начинается с `eyJ...`)

### 3. Запустите приложение с ключами

#### Через командную строку:

```bash
flutter run --dart-define=SUPABASE_URL=https://ваш-проект.supabase.co --dart-define=SUPABASE_ANON_KEY=ваш-anon-key
```

**Пример:**
```bash
flutter run --dart-define=SUPABASE_URL=https://abcdefghijklmnop.supabase.co --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiY2RlZmdoaWprbG1ub3AiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTYzODk2NzIwMCwiZXhwIjoxOTU0NTQzMjAwfQ.abcdefghijklmnopqrstuvwxyz1234567890
```

#### Через VS Code:

Создайте файл `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define=SUPABASE_URL=https://ваш-проект.supabase.co",
        "--dart-define=SUPABASE_ANON_KEY=ваш-anon-key"
      ]
    }
  ]
}
```

#### Через Android Studio:

1. Run → Edit Configurations
2. В поле "Additional run args" добавьте:
```
--dart-define=SUPABASE_URL=https://ваш-проект.supabase.co --dart-define=SUPABASE_ANON_KEY=ваш-anon-key
```

### 4. Проверка

После запуска с ключами:
- Приложение должно запускаться без ошибок
- Регистрация и вход должны работать
- В логах должны быть видны запросы к Supabase API

## API Endpoints

### DEV.to API
- `GET /articles` - список статей
- `GET /articles/latest` - последние статьи
- `GET /articles/{id}` - статья по ID
- `GET /tags` - список тегов
- `GET /comments` - комментарии к статье

### Supabase Auth API
- `POST /signup` - регистрация
- `POST /token` - вход и обновление токена
- `GET /user` - получение текущего пользователя
- `PUT /user` - обновление профиля
- `POST /logout` - выход

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
