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

// Pets
final petsApiProvider = Provider(
  (ref) => PetsApiDataSource(ref.watch(dioProvider)),
);

final matchingApiProvider = Provider(
  (ref) => MatchingApiDataSource(ref.watch(dioProvider)),
);

final petRepositoryProvider = Provider<PetRepository>(
  (ref) => PetRepositoryImpl(
    ref.watch(petsApiProvider),
    ref.watch(matchingApiProvider),
  ),
);

// Media
final mediaApiProvider = Provider(
  (ref) => MediaApiDataSource(ref.watch(dioProvider)),
);

final mediaRepositoryProvider = Provider<MediaRepository>(
  (ref) => MediaRepositoryImpl(ref.watch(mediaApiProvider)),
);

// Notifications
final notificationsApiProvider = Provider(
  (ref) => NotificationsApiDataSource(ref.watch(dioProvider)),
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
