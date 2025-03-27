part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initWebSocket();
  _initMessageHistory();
  //Please don't forget to add .env in assets pubspec.yaml
  // assets:
  //   - .env
  await dotenv.load(fileName: ".env");
  final FlutterSecureStorage storage = FlutterSecureStorage();
  serviceLocator.registerLazySingleton(() => storage);
  final tokenManager = TokenManager(storage);
  await tokenManager.loadTokens();
  serviceLocator.registerLazySingleton(() => tokenManager);
  serviceLocator.registerLazySingleton(
      () => DioClient(serviceLocator<TokenManager>()).dio);
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        client: serviceLocator<Dio>(),
      ),
    ) // using registerFactory because need to create multiple instance
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserSignIn(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogout(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetUserData(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        userLogout: serviceLocator(),
        getUserData: serviceLocator(),
      ),
    ); // using registerLazySingleton because bloc only need to create one instance
}

void _initWebSocket() {
  serviceLocator
    ..registerFactory<WebSocketRemoteDataSource>(
      () => WebSocketRemoteDataSourceImpl(
        client: serviceLocator<Dio>(),
      ),
    )
    ..registerFactory<WhatsappApiRepository>(
      () => WhatsappApiRepositoryImpl(remoteDataSource: serviceLocator()),
    )
    ..registerFactory(
      () => GetUserPhoneNumbers(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => SendMessage(repository: serviceLocator()),
    )
    //  Register WebSocketCubit as a lazy singleton (or factory if you want a new instance each time)
    ..registerLazySingleton<WebSocketCubit>(
      () => WebSocketCubit(
          repository: serviceLocator<WebSocketRemoteDataSource>()),
    )
    ..registerLazySingleton(
      () => WhatsappBloc(
        getUserPhoneNumber: serviceLocator(),
        sendMessage: serviceLocator(),
      ),
    );
}

void _initMessageHistory() {
  serviceLocator
    ..registerFactory<MessageHistoryRemoteDataSource>(
      () => MessageHistoryRemoteDataSourceImpl(
        client: serviceLocator<Dio>(),
      ),
    ) // using registerFactory because need to create multiple instance
    ..registerFactory<MessageHistoryRepository>(
      () => MessageHistoryRepositoriImpl(
        remoteDataSource: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetMessageHistory(
        repository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetMessageHistoryGroup(
        repository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteMessageHistory(
        repository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => MessageHistoryBloc(
        getMessageHistory: serviceLocator(),
        getMessageHistoryGroup: serviceLocator(),
        deleteMessageHistory: serviceLocator(),
      ),
    );
}
