import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/chat/chat_screen.dart';
import '../screens/chat/conversation_list_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/pets/pet_create_screen.dart';
import '../screens/pets/pet_detail_screen.dart';
import '../screens/pets/pet_filter_screen.dart';
import '../screens/pets/pet_list_screen.dart';
import '../screens/profile/about_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/splash_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/pets',
        builder: (context, state) => const PetListScreen(),
      ),
      GoRoute(
        path: '/pets/create',
        builder: (context, state) => const PetCreateScreen(),
      ),
      GoRoute(
        path: '/pets/filter',
        builder: (context, state) => const PetFilterScreen(),
      ),
      GoRoute(
        path: '/pets/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PetDetailScreen(petId: id);
        },
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const ConversationListScreen(),
      ),
      GoRoute(
        path: '/chat/:conversationId',
        builder: (context, state) {
          final conversationId = state.pathParameters['conversationId']!;
          return ChatScreen(conversationId: conversationId);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  );
});
