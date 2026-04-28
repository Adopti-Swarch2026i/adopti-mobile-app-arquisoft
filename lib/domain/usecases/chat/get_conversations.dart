import '../../entities/conversation.dart';
import '../../repositories/chat_repository.dart';

class GetConversations {
  final ChatRepository _repository;

  const GetConversations(this._repository);

  Future<List<Conversation>> call(String userId) =>
      _repository.getConversations(userId);
}
