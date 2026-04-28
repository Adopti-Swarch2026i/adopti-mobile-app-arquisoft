import '../../entities/message.dart';
import '../../repositories/chat_repository.dart';

class GetMessages {
  final ChatRepository _repository;

  const GetMessages(this._repository);

  Future<List<Message>> call(String conversationId) =>
      _repository.getMessages(conversationId);
}
