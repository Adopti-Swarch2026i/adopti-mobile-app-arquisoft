import '../../entities/conversation.dart';
import '../../repositories/chat_repository.dart';

class CreateConversation {
  final ChatRepository _repository;

  const CreateConversation(this._repository);

  Future<Conversation> call(List<String> participantIds) =>
      _repository.createConversation(participantIds);
}
