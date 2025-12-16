# Инструкция по настройке Supabase для проверки проекта

## Проблема

При запуске приложения появляется ошибка:
```
Supabase не настроен. Используйте --dart-define для передачи SUPABASE_URL и SUPABASE_ANON_KEY.
```

Это происходит потому, что для работы функций авторизации (регистрация, вход, профиль) необходимо настроить подключение к Supabase.

## Что нужно сделать

### Шаг 1: Получить ключи Supabase

1. Перейдите на сайт [supabase.com](https://supabase.com)
2. Войдите в аккаунт (или создайте новый, если его нет)
3. Создайте новый проект:
   - Нажмите "New Project"
   - Введите название проекта
   - Выберите регион (можно любой)
   - Введите пароль для базы данных
   - Дождитесь создания проекта (1-2 минуты)

4. После создания проекта:
   - Перейдите в **Settings** (настройки) → **API**
   - Найдите секцию **Project API keys**
   - Скопируйте два значения:
     - **Project URL** - это будет `SUPABASE_URL`
       - Пример: `https://abcdefghijklmnop.supabase.co`
     - **anon public** key или **publishable key** - это будет `SUPABASE_ANON_KEY`
       - Это строка, может начинаться с `eyJ...` (JWT) или `sb_publishable_...` (новый формат)

### Шаг 2: Установить переменные окружения

#### Вариант 1: Использовать скрипт (рекомендуется)

**macOS/Linux:**
```bash
source setup_supabase.sh
```

**Windows:**
```cmd
setup_supabase.bat
```

После этого можно запускать приложение обычной командой:
```bash
flutter run
```

#### Вариант 2: Установить вручную

**macOS/Linux:**
```bash
export SUPABASE_URL="https://zqojzjokbxonwypjhjms.supabase.co"
export SUPABASE_ANON_KEY="sb_publishable_xK21hJAFo1KmYilKHS_Pbg_qJJkywGd"
```

**Windows:**
```cmd
set SUPABASE_URL=https://zqojzjokbxonwypjhjms.supabase.co
set SUPABASE_ANON_KEY=sb_publishable_xK21hJAFo1KmYilKHS_Pbg_qJJkywGd
```

#### Вариант 3: Через --dart-define (если переменные окружения не работают)

```bash
flutter run --dart-define=SUPABASE_URL=https://zqojzjokbxonwypjhjms.supabase.co --dart-define=SUPABASE_ANON_KEY=sb_publishable_xK21hJAFo1KmYilKHS_Pbg_qJJkywGd
```

**Примечание:** Приложение автоматически проверяет сначала `--dart-define`, затем переменные окружения.

### Шаг 3: Проверка работы

После запуска с ключами:
- ✅ Приложение должно запуститься без ошибок
- ✅ Можно зарегистрировать нового пользователя
- ✅ Можно войти в систему
- ✅ Можно просмотреть и редактировать профиль
- ✅ В логах видны запросы к Supabase API (5 ручек)

## Альтернативный способ (для VS Code)

Если используете VS Code, можно создать файл `.vscode/launch.json`:

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

## Важно

- ⚠️ **Не коммитьте реальные ключи в репозиторий** - они передаются только через `--dart-define`
- ✅ Supabase предоставляет бесплатный тарифный план для разработки
- ✅ Создание проекта занимает 1-2 минуты
- ✅ Ключи можно найти в Settings → API вашего проекта

## Где найти ключи (визуально)

1. Войдите в проект Supabase
2. В левом меню нажмите на иконку ⚙️ **Settings**
3. В подменю выберите **API**
4. В секции **Project API keys** найдите:
   - **Project URL** - в поле с URL
   - **anon public** или **publishable key** - кнопка "Reveal" или уже видимый ключ

## Контакты для помощи

Если возникли проблемы:
- Документация Supabase: https://supabase.com/docs
- Создание проекта: https://supabase.com/dashboard/new

