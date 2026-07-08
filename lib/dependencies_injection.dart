import 'package:get_it/get_it.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/auth/auth.dart';
import 'package:jaga_saku/features/home/home.dart';
import 'package:jaga_saku/features/onboarding/onboarding.dart';
import 'package:jaga_saku/features/settings/settings.dart';
import 'package:jaga_saku/features/users/users.dart';

GetIt sl = GetIt.instance;

Future<void> serviceLocator({
  bool isUnitTest = false,
  bool isHiveEnable = true,
  String prefixBox = '',
}) async {
  if (isUnitTest) {
    await sl.reset();
  }

  if (isHiveEnable) {
    await _initHiveBoxes(isUnitTest: isUnitTest, prefixBox: prefixBox);
  }

  sl.registerLazySingleton<AuthTokenService>(() => AuthTokenService());
  sl.registerSingleton<PermissionService>(PermissionServiceImpl());

  sl.registerSingleton<DioClient>(DioClient(isUnitTest: isUnitTest));
  sl.registerLazySingleton<UploadService>(() => UploadService(sl()));
  sl.registerLazySingleton<RemoteConfigService>(
    () => RemoteConfigService(sl()),
  );

  if (!isUnitTest) {
    final connectivityService = ConnectivityService();
    sl.registerSingleton<ConnectivityService>(connectivityService);
    // Seed real connectivity state before the app runs so a cold start while
    // offline fails fast instead of letting requests hang until timeout.
    await connectivityService.checkConnectivity();

    // FCM push notifications. Registered for the real app only — unit tests
    // must not touch the FirebaseMessaging platform channels. `init()` is
    // driven from main() after FirebaseServices.init(), not here.
    sl.registerSingleton<NotificationService>(NotificationService());

    // Analytics. Real app only (touches Firebase platform channels); its
    // observer is wired into the go_router config in AppRoute.routerFor.
    sl.registerSingleton<AnalyticsService>(AnalyticsService());
  }

  _dataSources();
  _repositories();
  _useCase();
  _cubit();
}

Future<void> _initHiveBoxes({
  bool isUnitTest = false,
  String prefixBox = '',
}) async {
  await MainBoxMixin.initHive(prefixBox);

  // One-time migration: clear legacy token keys from Hive.
  // Safe to run on every startup — once keys are gone these become no-ops.
  // isLogin is intentionally NOT deleted here; it remains the auth state flag.
  MainBoxMixin.mainBox?.delete('accessToken');
  MainBoxMixin.mainBox?.delete('refreshToken');

  sl.registerSingleton<MainBoxMixin>(MainBoxMixin());

  // Offline response cache (separate Hive box so it can be cleared on logout
  // without touching prefs/tokens).
  sl.registerSingleton<CacheStore>(await CacheStore.open(prefixBox));
}

void _repositories() {
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl(), sl()),
  );
  sl.registerLazySingleton<UsersRepository>(() => UsersRepositoryImpl(sl()));
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AuthStatusRepository>(
    () => AuthStatusRepositoryImpl(sl()),
  );
}

void _dataSources() {
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<UsersRemoteDatasource>(
    () => UsersRemoteDatasourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton<SettingsLocalDatasource>(
    () => SettingsLocalDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(sl()),
  );
}

void _useCase() {
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => ClearSession(sl()));
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => GetUser(sl()));
  sl.registerLazySingleton(() => UpdateUser(sl()));
  sl.registerLazySingleton(() => DeleteUser(sl()));
  sl.registerLazySingleton(() => GetSettings(sl()));
  sl.registerLazySingleton(() => UpdateTheme(sl()));
  sl.registerLazySingleton(() => UpdateLanguage(sl()));
}

void _cubit() {
  sl.registerFactory(() => AuthCubit(sl(), sl()));
  sl.registerFactory(() => LogoutCubit(sl(), sl()));
  sl.registerFactory(() => PermissionCubit(sl()));

  if (sl.isRegistered<ConnectivityService>()) {
    sl.registerFactory(() => ConnectivityCubit(sl()));
  }

  sl.registerFactory(() => UserCubit(sl()));
  sl.registerFactory(() => UsersCubit(sl()));
  sl.registerFactory(() => UserDetailCubit(sl()));
  sl.registerFactory(() => UserEditCubit(sl(), sl(), sl()));
  sl.registerFactory(() => SettingsCubit(sl(), sl(), sl()));
  sl.registerFactory(() => EditNameCubit(sl(), sl()));
  sl.registerFactory(() => MainCubit());
}
