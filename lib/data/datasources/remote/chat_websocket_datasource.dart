import 'dart:async';
import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../../core/constants/api_constants.dart';
import '../../models/message_model.dart';

class ChatWebSocketDataSource {
  StompClient? _client;
  final Map<String, StreamController<MessageModel>> _subscriptions = {};

  void connect(String token) {
    _client = StompClient(
      config: StompConfig(
        url: ApiConstants.chatWsUrl,
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
        stompConnectHeaders: {'Authorization': 'Bearer $token'},
        onConnect: _onConnect,
        onWebSocketError: (dynamic error) => print('WS Error: $error'),
        onDisconnect: (_) => print('WS Disconnected'),
      ),
    );
    _client?.activate();
  }

  void _onConnect(StompFrame frame) {
    // Re-subscribe to pending subscriptions
    for (final entry in _subscriptions.entries) {
      _subscribeToConversation(entry.key, entry.value);
    }
  }

  Stream<MessageModel> subscribeToMessages(String conversationId) {
    if (_subscriptions.containsKey(conversationId)) {
      return _subscriptions[conversationId]!.stream;
    }

    final controller = StreamController<MessageModel>.broadcast();
    _subscriptions[conversationId] = controller;

    if (_client?.connected ?? false) {
      _subscribeToConversation(conversationId, controller);
    }

    return controller.stream;
  }

  void _subscribeToConversation(
    String conversationId,
    StreamController<MessageModel> controller,
  ) {
    _client?.subscribe(
      destination: '/topic/chat/$conversationId',
      callback: (frame) {
        if (frame.body != null) {
          final json = jsonDecode(frame.body!) as Map<String, dynamic>;
          controller.add(MessageModel.fromJson(json));
        }
      },
    );
  }

  void sendMessage(String conversationId, String senderId, String content) {
    _client?.send(
      destination: '/app/chat.send',
      body: jsonEncode({
        'conversationId': conversationId,
        'senderId': senderId,
        'content': content,
      }),
    );
  }

  void disconnect() {
    for (final controller in _subscriptions.values) {
      controller.close();
    }
    _subscriptions.clear();
    _client?.deactivate();
    _client = null;
  }
}
