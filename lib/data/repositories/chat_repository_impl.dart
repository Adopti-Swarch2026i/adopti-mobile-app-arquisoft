import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/local/firebase_auth_datasource.dart';
import '../datasources/remote/chat_graphql_datasource.dart';
import '../datasources/remote/chat_websocket_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatGraphQLDataSource _graphqlDataSource;
  final ChatWebSocketDataSource _wsDataSource;
  final FirebaseAuthDataSource _authDataSource;

  ChatRepositoryImpl(
    this._graphqlDataSource,
    this._wsDataSource,
    this._authDataSource,
  );

  @override
  Future<List<Conversation>> getConversations(String userId) async {
    try {
      final models = await _graphqlDataSource.getConversations(userId);
      return models.map((m) => m.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    }
  }

  @override
  Future<List<Message>> getMessages(String conversationId) async {
    try {
      final models = await _graphqlDataSource.getMessages(conversationId);
      return models.map((m) => m.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    }
  }

  @override
  Future<Conversation> createConversation(List<String> participantIds) async {
    try {
      final model = await _graphqlDataSource.createConversation(participantIds);
      return model.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    }
  }

  @override
  Future<void> connectWebSocket() async {
    final token = await _authDataSource.getIdToken();
    if (token != null) {
      _wsDataSource.connect(token);
    }
  }

  @override
  Future<void> disconnectWebSocket() async {
    _wsDataSource.disconnect();
  }

  @override
  Future<void> sendMessage(String conversationId, String content) async {
    final user = await _authDataSource.getCurrentUser();
    final senderId = user?.id ?? '';
    _wsDataSource.sendMessage(conversationId, senderId, content);
  }

  @override
  Stream<Message> subscribeToMessages(String conversationId) {
    return _wsDataSource
        .subscribeToMessages(conversationId)
        .map((model) => model.toEntity());
  }
}
