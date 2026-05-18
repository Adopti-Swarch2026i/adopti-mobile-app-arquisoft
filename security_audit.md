# Auditoría de Seguridad - Adopti Mobile App

Basado en la teoría de Seguridad (CIA Triad, Tácticas y Patrones Arquitectónicos):

## Cumple

### Tácticas: Resistir Ataques
*   **Encrypt Data:** 
    *   El archivo `.env` de producción apunta exclusivamente a URLs seguras: `https://10.0.2.2/...` y `wss://10.0.2.2/...`. Esto asegura que todo el tráfico entre la app y el gateway NGINX viaja cifrado con TLS.
*   **Authenticate Actor:** El proyecto utiliza librerías de identidad como `firebase_auth` y `google_sign_in` (evidenciado en `pubspec.yaml`). La app verifica la identidad del usuario mediante Firebase Authentication y tokens ID de Google.
*   **Change Default Settings:** 
    *   `EnvConfig` (`lib/config/env_config.dart`) fue endurecido con validación `kReleaseMode`: si una variable obligatoria falta o usa esquemas inseguros (`http://`, `ws://`) en una build de release, la app lanza `StateError` en tiempo de ejecución en lugar de caer silenciosamente a un default inseguro.
    *   Todos los getters (`petsApiUrl`, `chatGraphqlUrl`, `chatWsUrl`, etc.) ahora usan `_required()` sin valores por defecto inseguros.
*   **Limit Access / Authorize Actors:** La inclusión de mecanismos de autenticación permite restringir rutas y acceso a datos basándose en el estado de autenticación del usuario.

### Tácticas: Reaccionar a Ataques
*   **Revoke Access:** El uso de Firebase Auth soporta operaciones inherentes como el cierre de sesión y la expiración de tokens en el dispositivo, ayudando a la revocación de acceso a nivel local.

## No Cumple / Gaps conocidos
*   **Certificate Pinning NO implementado:** No existe anclaje (pinning) de certificados ni validación adicional de la cadena de certificados mediante `SecurityContext` personalizado. Los clientes `Dio` y `GraphQLClient` confían en el almacén de certificados del sistema operativo del dispositivo. Un certificado raíz malicioso instalado en el dispositivo (ataque MITM con `mitmproxy` + Frida) podría interceptar el tráfico HTTPS/WSS sin que la app lo detecte.
    *   *Mitigación parcial:* El tráfico sigue siendo TLS y requiere compromiso del dispositivo, pero el riesgo existe en escenarios de dispositivos rooteados o con perfiles MDM maliciosos.
*   **WebSocket STOMP sin pinning adicional:** Aunque `chatWsUrl` usa `wss://`, la conexión STOMP hereda la misma confianza del sistema operativo sin capa adicional de validación de certificados.
*   **No se detecta dependencia de pinning** (`http_certificate_pinning`, `ssl_pinning_plugin` o equivalente) en `pubspec.yaml`.
*   **Detectar Ataques / Maintain Audit Trail:** No hay evidencia directa en las dependencias del cliente sobre mecanismos avanzados de detección de intrusos o registro de auditoría seguro a nivel de aplicación (comúnmente delegado al backend, pero importante notarlo).

## Decisiones del Laboratorio 5
*   **Aplicación del Secure Channel Pattern en este servicio:** Se eliminaron las URLs `http://` y `ws://` del `.env` real; todas las comunicaciones backend ahora transitan por `https://` y `wss://`. Se implementó validación estricta en `EnvConfig` que bloquea esquemas inseguros en builds de release (`kReleaseMode`). **Queda pendiente** la implementación de *certificate pinning* como capa adicional de defensa en profundidad contra MITM avanzados.
