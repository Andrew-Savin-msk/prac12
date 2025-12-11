import 'package:get_it/get_it.dart';
import 'package:prac12/data/datasources/account/account_local_datasource.dart';
import 'package:prac12/data/datasources/achievements/achievement_local_datasource.dart';
import 'package:prac12/data/datasources/activity_log/activity_log_local_datasource.dart';
import 'package:prac12/data/datasources/focus/focus_session_local_datasource.dart';
import 'package:prac12/data/datasources/goals/goal_local_datasource.dart';
import 'package:prac12/data/datasources/support/support_local_datasource.dart';
import 'package:prac12/data/datasources/tips/tips_local_datasource.dart';
import 'package:prac12/data/datasources/common/shared_prefs_data_source.dart';
import 'package:prac12/data/datasources/goals/goals_sqlite_data_source.dart';
import 'package:prac12/data/datasources/account/account_secure_storage_data_source.dart';
import 'package:prac12/data/datasources/account/account_sqlite_data_source.dart';
import 'package:prac12/data/repositories/account/account_repository_impl.dart';
import 'package:prac12/data/repositories/achievements/achievement_repository_impl.dart';
import 'package:prac12/data/repositories/activity_log/activity_log_repository_impl.dart';
import 'package:prac12/data/repositories/focus/focus_session_repository_impl.dart';
import 'package:prac12/data/repositories/goals/goal_repository_impl.dart';
import 'package:prac12/data/repositories/support/support_repository_impl.dart';
import 'package:prac12/data/repositories/tips/tips_repository_impl.dart';
import 'package:prac12/domain/repositories/account/account_repository.dart';
import 'package:prac12/domain/repositories/achievements/achievement_repository.dart';
import 'package:prac12/domain/repositories/activity_log/activity_log_repository.dart';
import 'package:prac12/domain/repositories/focus/focus_session_repository.dart';
import 'package:prac12/domain/repositories/goals/goal_repository.dart';
import 'package:prac12/domain/repositories/support/support_repository.dart';
import 'package:prac12/domain/repositories/tips/tips_repository.dart';
import 'package:prac12/domain/usecases/account/get_current_user_usecase.dart';
import 'package:prac12/domain/usecases/account/login_usecase.dart';
import 'package:prac12/domain/usecases/account/logout_usecase.dart';
import 'package:prac12/domain/usecases/account/register_usecase.dart';
import 'package:prac12/domain/usecases/account/update_profile_usecase.dart';
import 'package:prac12/domain/usecases/account/save_auth_tokens_usecase.dart';
import 'package:prac12/domain/usecases/account/get_auth_tokens_usecase.dart';
import 'package:prac12/domain/usecases/account/clear_auth_tokens_usecase.dart';
import 'package:prac12/domain/usecases/account/restore_session_usecase.dart';
import 'package:prac12/domain/usecases/achievements/get_achievements_usecase.dart';
import 'package:prac12/domain/usecases/activity_log/clear_activity_log_usecase.dart';
import 'package:prac12/domain/usecases/activity_log/get_activity_log_usecase.dart';
import 'package:prac12/domain/usecases/activity_log/log_tip_opened_usecase.dart';
import 'package:prac12/domain/usecases/focus/add_focus_session_usecase.dart';
import 'package:prac12/domain/usecases/focus/clear_focus_history_usecase.dart';
import 'package:prac12/domain/usecases/focus/get_focus_sessions_usecase.dart';
import 'package:prac12/domain/usecases/goals/add_goal_usecase.dart';
import 'package:prac12/domain/usecases/goals/delete_goal_usecase.dart';
import 'package:prac12/domain/usecases/goals/get_goals_usecase.dart';
import 'package:prac12/domain/usecases/goals/update_goal_subtasks_usecase.dart';
import 'package:prac12/domain/usecases/goals/get_saved_search_query_usecase.dart';
import 'package:prac12/domain/usecases/goals/save_search_query_usecase.dart';
import 'package:prac12/domain/usecases/support/get_faq_items_usecase.dart';
import 'package:prac12/domain/usecases/support/send_feedback_usecase.dart';
import 'package:prac12/domain/usecases/tips/get_tip_by_id_usecase.dart';
import 'package:prac12/domain/usecases/tips/get_tips_usecase.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  // Data Sources
  getIt.registerLazySingleton<SharedPrefsDataSource>(() => SharedPrefsDataSource());
  getIt.registerLazySingleton<GoalsSqliteDataSource>(() => GoalsSqliteDataSource());
  getIt.registerLazySingleton<AccountSqliteDataSource>(() => AccountSqliteDataSource());
  getIt.registerLazySingleton<AccountSecureStorageDataSource>(() => AccountSecureStorageDataSource());
  getIt.registerLazySingleton<GoalLocalDataSource>(() => GoalLocalDataSource());
  getIt.registerLazySingleton<AccountLocalDataSource>(
    () => AccountLocalDataSource(getIt<AccountSqliteDataSource>()),
  );
  getIt.registerLazySingleton<AchievementLocalDataSource>(() => AchievementLocalDataSource());
  getIt.registerLazySingleton<ActivityLogLocalDataSource>(() => ActivityLogLocalDataSource());
  getIt.registerLazySingleton<FocusSessionLocalDataSource>(() => FocusSessionLocalDataSource());
  getIt.registerLazySingleton<TipsLocalDataSource>(() => TipsLocalDataSource());
  getIt.registerLazySingleton<SupportLocalDataSource>(() => SupportLocalDataSource());

  // Repositories
  getIt.registerLazySingleton<GoalRepository>(
    () => GoalRepositoryImpl(
      getIt<GoalLocalDataSource>(),
      getIt<GoalsSqliteDataSource>(),
      getIt<SharedPrefsDataSource>(),
    ),
  );
  getIt.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(
      getIt<AccountLocalDataSource>(),
      getIt<AccountSecureStorageDataSource>(),
    ),
  );
  getIt.registerLazySingleton<AchievementRepository>(
    () => AchievementRepositoryImpl(
      getIt<AchievementLocalDataSource>(),
      getIt<ActivityLogLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<ActivityLogRepository>(
    () => ActivityLogRepositoryImpl(getIt<ActivityLogLocalDataSource>()),
  );
  getIt.registerLazySingleton<FocusSessionRepository>(
    () => FocusSessionRepositoryImpl(getIt<FocusSessionLocalDataSource>()),
  );
  getIt.registerLazySingleton<TipsRepository>(
    () => TipsRepositoryImpl(getIt<TipsLocalDataSource>()),
  );
  getIt.registerLazySingleton<SupportRepository>(
    () => SupportRepositoryImpl(getIt<SupportLocalDataSource>()),
  );

  // Use Cases - Goals
  getIt.registerLazySingleton<GetGoalsUseCase>(
    () => GetGoalsUseCase(getIt<GoalRepository>()),
  );
  getIt.registerLazySingleton<AddGoalUseCase>(
    () => AddGoalUseCase(
      getIt<GoalRepository>(),
      getIt<AchievementRepository>(),
      getIt<ActivityLogRepository>(),
    ),
  );
  getIt.registerLazySingleton<DeleteGoalUseCase>(
    () => DeleteGoalUseCase(
      getIt<GoalRepository>(),
      getIt<ActivityLogRepository>(),
    ),
  );
  getIt.registerLazySingleton<UpdateGoalSubtasksUseCase>(
    () => UpdateGoalSubtasksUseCase(
      getIt<GoalRepository>(),
      getIt<AchievementRepository>(),
      getIt<ActivityLogRepository>(),
    ),
  );
  getIt.registerLazySingleton<GetSavedSearchQueryUseCase>(
    () => GetSavedSearchQueryUseCase(getIt<GoalRepository>()),
  );
  getIt.registerLazySingleton<SaveSearchQueryUseCase>(
    () => SaveSearchQueryUseCase(getIt<GoalRepository>()),
  );

  // Use Cases - Account
  getIt.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(getIt<AccountRepository>()),
  );
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(
      getIt<AccountRepository>(),
      getIt<ActivityLogRepository>(),
    ),
  );
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      getIt<AccountRepository>(),
      getIt<ActivityLogRepository>(),
      getIt<SaveAuthTokensUseCase>(),
    ),
  );
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(
      getIt<AccountRepository>(),
      getIt<ActivityLogRepository>(),
    ),
  );
  getIt.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(
      getIt<AccountRepository>(),
      getIt<ActivityLogRepository>(),
    ),
  );
  getIt.registerLazySingleton<SaveAuthTokensUseCase>(
    () => SaveAuthTokensUseCase(getIt<AccountRepository>()),
  );
  getIt.registerLazySingleton<GetAuthTokensUseCase>(
    () => GetAuthTokensUseCase(getIt<AccountRepository>()),
  );
  getIt.registerLazySingleton<ClearAuthTokensUseCase>(
    () => ClearAuthTokensUseCase(getIt<AccountRepository>()),
  );
  getIt.registerLazySingleton<RestoreSessionUseCase>(
    () => RestoreSessionUseCase(getIt<AccountRepository>()),
  );

  // Use Cases - Achievements
  getIt.registerLazySingleton<GetAchievementsUseCase>(
    () => GetAchievementsUseCase(getIt<AchievementRepository>()),
  );

  // Use Cases - Activity Log
  getIt.registerLazySingleton<GetActivityLogUseCase>(
    () => GetActivityLogUseCase(getIt<ActivityLogRepository>()),
  );
  getIt.registerLazySingleton<ClearActivityLogUseCase>(
    () => ClearActivityLogUseCase(getIt<ActivityLogRepository>()),
  );
  getIt.registerLazySingleton<LogTipOpenedUseCase>(
    () => LogTipOpenedUseCase(getIt<ActivityLogRepository>()),
  );

  // Use Cases - Focus
  getIt.registerLazySingleton<GetFocusSessionsUseCase>(
    () => GetFocusSessionsUseCase(getIt<FocusSessionRepository>()),
  );
  getIt.registerLazySingleton<AddFocusSessionUseCase>(
    () => AddFocusSessionUseCase(
      getIt<FocusSessionRepository>(),
      getIt<ActivityLogRepository>(),
    ),
  );
  getIt.registerLazySingleton<ClearFocusHistoryUseCase>(
    () => ClearFocusHistoryUseCase(getIt<FocusSessionRepository>()),
  );

  // Use Cases - Tips
  getIt.registerLazySingleton<GetTipsUseCase>(
    () => GetTipsUseCase(getIt<TipsRepository>()),
  );
  getIt.registerLazySingleton<GetTipByIdUseCase>(
    () => GetTipByIdUseCase(getIt<TipsRepository>()),
  );

  // Use Cases - Support
  getIt.registerLazySingleton<GetFaqItemsUseCase>(
    () => GetFaqItemsUseCase(getIt<SupportRepository>()),
  );
  getIt.registerLazySingleton<SendFeedbackUseCase>(
    () => SendFeedbackUseCase(
      getIt<SupportRepository>(),
      getIt<ActivityLogRepository>(),
    ),
  );
}

