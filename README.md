# Adopti Mobile

Aplicacion movil Flutter para el proyecto Adopti — Arquitectura de Software 2026-I.

## Arquitectura

Clean Architecture / Hexagonal con:
- **Domain**: entidades puras, interfaces de repositorio, casos de uso
- **Data**: modelos DTO, datasources (REST, GraphQL, WebSocket/STOMP), implementaciones de repositorios
- **Presentation**: Riverpod providers, GoRouter, screens y widgets

## Stack

- Flutter 3.29+ + Dart
- Riverpod (state management)
- GoRouter (navegacion)
- Dio (HTTP REST)
- graphql_flutter (GraphQL)
- stomp_dart_client (WebSocket STOMP)
- firebase_auth + google_sign_in (autenticacion)
- firebase_messaging (push notifications)

## Servicios Backend

| Servicio | Endpoint Gateway |
|---|---|
| pets-service | `/api/pets` |
| matching-service | `/api/search`, `/api/matches` |
| media-service | `/api/media/upload` |
| notification-service | `/api/notifications` |
| chat-service | `/api/chat/graphql`, `/api/chat/ws` |

## Setup

1. Copiar `.env.example` a `.env` y ajustar URLs segun entorno.
2. Colocar `google-services.json` en `android/app/`.
3. Ejecutar `flutter pub get`.
4. Ejecutar `flutter run`.

## Estructura

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   ├── errors/
│   ├── theme/
│   └── utils/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── data/
│   ├── models/
│   ├── datasources/
│   └── repositories/
├── presentation/
│   ├── providers/
│   ├── routing/
│   ├── screens/
│   └── widgets/
└── config/
```

## Autor

Juan Carlos Andrade Unigarro — yosoyepa <jandradeu@unal.edu.co>
