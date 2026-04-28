import '../entities/conversation.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<List<Conversation>> getConversations(String userId);
  Future<List<Message>> getMessages(String conversationId);
  Future<Conversation> createConversation(List<String> participantIds);
  Future<void> connectWebSocket();
  Future<void> disconnectWebSocket();
  Future<void> sendMessage(String conversationId, String content);
  Stream<Message> subscribeToMessages(String conversationId);
}
