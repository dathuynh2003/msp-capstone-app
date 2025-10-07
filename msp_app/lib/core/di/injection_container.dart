import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:stream_video_flutter/stream_video_flutter.dart' hide ApiClient;

// Core
import '../network/api_client.dart';
import '../network/network_info.dart';

// Auth Feature
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';

// // Meeting Feature
// import '../../features/meeting/data/datasources/remote_datasource.dart';
// import '../../features/meeting/data/repositories/meeting_repository_impl.dart';
// import '../../features/meeting/domain/repositories/meeting_repository.dart';
// import '../../features/meeting/domain/usecases/get_meeting_by_id.dart';
// import '../../features/meeting/domain/usecases/get_user_meetings.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Bloc
  // sl.registerFactory(() => AuthBloc(login: sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  //! Features - Meeting
  // TODO: Uncomment when StreamVideo client is properly implemented
  // Use cases
  // sl.registerLazySingleton(() => GetMeetingById(repository: sl<MeetingRepository>()));
  // sl.registerLazySingleton(() => GetUserMeetings(repository: sl<MeetingRepository>()));

  // Repository
  // sl.registerLazySingleton<MeetingRepository>(
  //   () => MeetingRepositoryImpl(remoteDataSource: sl<MeetingRemoteDataSource>()),
  // );

  // Data sources
  // sl.registerLazySingleton<MeetingRemoteDataSource>(
  //   () => MeetingRemoteDataSource(client: sl<StreamVideo>()),
  // );

  // Stream Video Client (will be set by StreamVideoProvider)
  // sl.registerLazySingleton<StreamVideo>(
  //   () => throw Exception('StreamVideo not initialized yet'),
  // );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectivity: sl<Connectivity>()));
  sl.registerLazySingleton<ApiClient>(() => ApiClient(client: sl<http.Client>()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
}
