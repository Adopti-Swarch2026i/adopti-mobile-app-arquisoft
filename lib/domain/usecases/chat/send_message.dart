import '../../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository _repository;

  const SendMessage(this._repository);

  Future<void> call(String conversationId, String content) =>
      _repository.sendMessage(conversationId, content);
}
