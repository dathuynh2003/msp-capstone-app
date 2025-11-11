import 'package:get_it/get_it.dart';
import 'package:msp_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:msp_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:msp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:msp_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:msp_app/features/auth/presentation/providers/auth_provider.dart';

final GetIt di = GetIt.instance;

void setupDI() {
  // DataSource
  di.registerLazySingleton<AuthRemoteDatasource>(() => AuthRemoteDatasource());

  // Repository
  di.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(di<AuthRemoteDatasource>()),
  );

  // Use Case
  di.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(di<AuthRepository>()),
  );

  // Provider
  di.registerFactory<AuthProvider>(() => AuthProvider(di<LoginUseCase>()));
}
