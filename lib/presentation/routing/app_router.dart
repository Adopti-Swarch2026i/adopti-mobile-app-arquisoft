import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/animations/app_animations.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/chat/conversation_list_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/pets/pet_create_screen.dart';
import '../screens/pets/pet_detail_screen.dart';
import '../screens/pets/pet_filter_screen.dart';
import '../screens/pets/pet_list_screen.dart';
import '../screens/profile/about_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/splash_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => AppPageTransitions.fadeScale(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => AppPageTransitions.fadeScale(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/pets',
        pageBuilder: (context, state) => AppPageTransitions.fadeScale(
          key: state.pageKey,
          child: const PetListScreen(),
        ),
      ),
      GoRoute(
        path: '/pets/create',
        pageBuilder: (context, state) => AppPageTransitions.fadeScale(
          key: state.pageKey,
          child: const PetCreateScreen(),
        ),
      ),
      GoRoute(
        path: '/pets/filter',
        pageBuilder: (context, state) => AppPageTransitions.fadeScale(
          key: state.pageKey,
          child: const PetFilterScreen(),
        ),
      ),
      GoRoute(
        path: '/pets/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return AppPageTransitions.fadeScale(
            key: state.pageKey,
            child: PetDetailScreen(petId: id),
          );
        },
      ),
      GoRoute(
        path: '/chat',
        pageBuilder: (context, state) => AppPageTransitions.fadeScale(
          key: state.pageKey,
          child: const ConversationListScreen(),
        ),
      ),
      GoRoute(
        path: '/chat/:conversationId',
        pageBuilder: (context, state) {
          final conversationId = state.pathParameters['conversationId']!;
          return AppPageTransitions.fadeScale(
            key: state.pageKey,
            child: ChatScreen(conversationId: conversationId),
          );
        },
      ),
      GoRoute(
        path: '/notifications',
        pageBuilder: (context, state) => AppPageTransitions.fadeScale(
          key: state.pageKey,
          child: const NotificationsScreen(),
        ),
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => AppPageTransitions.fadeScale(
          key: state.pageKey,
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: '/about',
        pageBuilder: (context, state) => AppPageTransitions.fadeScale(
          key: state.pageKey,
          child: const AboutScreen(),
        ),
      ),
    ],
  );
});
