import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../config/env_config.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/dio_interceptor.dart';
import '../../data/datasources/local/firebase_auth_datasource.dart';
import '../../data/datasources/remote/chat_graphql_datasource.dart';
import '../../data/datasources/remote/chat_websocket_datasource.dart';
import '../../data/datasources/remote/matching_api_datasource.dart';
import '../../data/datasources/remote/media_api_datasource.dart';
import '../../data/datasources/remote/notifications_api_datasource.dart';
import '../../data/datasources/remote/pets_api_datasource.dart';
import '../../core/services/fcm_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../data/repositories/media_repository_impl.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../data/repositories/pet_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/media_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/repositories/pet_repository.dart';
import '../../presentation/routing/app_router.dart';

// Auth
final firebaseAuthDataSourceProvider = Provider(
  (ref) => FirebaseAuthDataSource(),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(firebaseAuthDataSourceProvider)),
);

// Dio
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.petsApiUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
    ),
  );
  dio.interceptors.add(
    AuthInterceptor(ref.watch(firebaseAuthDataSourceProvider)),
  );
  return dio;
});

// Matching Dio (baseUrl diferente: /api para que /search resuelva /api/search)
final matchingDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.matchingApiUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
    ),
  );
  dio.interceptors.add(
    AuthInterceptor(ref.watch(firebaseAuthDataSourceProvider)),
  );
  return dio;
});

// Pets
final petsApiProvider = Provider(
  (ref) => PetsApiDataSource(ref.watch(dioProvider)),
);

final matchingApiProvider = Provider(
  (ref) => MatchingApiDataSource(ref.watch(matchingDioProvider)),
);

final petRepositoryProvider = Provider<PetRepository>(
  (ref) => PetRepositoryImpl(
    ref.watch(petsApiProvider),
    ref.watch(matchingApiProvider),
  ),
);

// Media Dio (usa baseUrl diferente: /api/media)
final mediaDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.mediaApiUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
    ),
  );
  dio.interceptors.add(
    AuthInterceptor(ref.watch(firebaseAuthDataSourceProvider)),
  );
  return dio;
});

// Media
final mediaApiProvider = Provider(
  (ref) => MediaApiDataSource(ref.watch(mediaDioProvider)),
);

final mediaRepositoryProvider = Provider<MediaRepository>(
  (ref) => MediaRepositoryImpl(ref.watch(mediaApiProvider)),
);

// Notifications Dio (baseUrl: /api para que /notifications resuelva /api/notifications)
final notificationsDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.notificationsApiUrl.replaceAll('/notifications', ''),
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
    ),
  );
  dio.interceptors.add(
    AuthInterceptor(ref.watch(firebaseAuthDataSourceProvider)),
  );
  return dio;
});

// Notifications
final notificationsApiProvider = Provider<NotificationsApiDataSource>(
  (ref) => NotificationsApiDataSource(
    ref.watch(notificationsDioProvider),
  ),
);

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => NotificationRepositoryImpl(ref.watch(notificationsApiProvider)),
);

// Chat
final chatGraphQLClientProvider = Provider<GraphQLClient>((ref) {
  final httpLink = HttpLink(EnvConfig.chatGraphqlUrl);
  final authLink = AuthLink(
    getToken: () async {
      final token = await ref.read(firebaseAuthDataSourceProvider).getIdToken();
      return token != null ? 'Bearer $token' : '';
    },
  );
  final link = authLink.concat(httpLink);
  return GraphQLClient(link: link, cache: GraphQLCache());
});

final chatGraphQLProvider = Provider(
  (ref) => ChatGraphQLDataSource(ref.watch(chatGraphQLClientProvider)),
);

final chatWebSocketProvider = Provider(
  (ref) => ChatWebSocketDataSource(),
);

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepositoryImpl(
    ref.watch(chatGraphQLProvider),
    ref.watch(chatWebSocketProvider),
    ref.watch(firebaseAuthDataSourceProvider),
  ),
);

// FCM
final fcmServiceProvider = Provider<FcmService>(
  (ref) => FcmService(
    notificationsApi: ref.watch(notificationsApiProvider),
    navigatorKey: rootNavigatorKey,
  ),
);
