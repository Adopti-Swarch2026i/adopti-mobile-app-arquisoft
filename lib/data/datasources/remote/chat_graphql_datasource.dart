import 'package:graphql_flutter/graphql_flutter.dart' hide ServerException;

import '../../../core/errors/exceptions.dart';
import '../../models/conversation_model.dart';
import '../../models/message_model.dart';

class ChatGraphQLDataSource {
  final GraphQLClient _client;

  ChatGraphQLDataSource(this._client);

  Future<List<ConversationModel>> getConversations(String userId) async {
    const query = r'''
      query GetConversations($userId: String!) {
        conversations(userId: $userId) {
          id
          participantIds
          participantNames
          createdAt
          updatedAt
        }
      }
    ''';

    final result = await _client.query(
      QueryOptions(
        document: gql(query),
        variables: {'userId': userId},
      ),
    );

    if (result.hasException) {
      throw ServerException(result.exception.toString());
    }

    final data = result.data?['conversations'] as List<dynamic>? ?? [];
    return data
        .map((e) => ConversationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MessageModel>> getMessages(String conversationId) async {
    const query = r'''
      query GetMessages($conversationId: String!) {
        messages(conversationId: $conversationId) {
          id
          conversationId
          senderId
          content
          timestamp
        }
      }
    ''';

    final result = await _client.query(
      QueryOptions(
        document: gql(query),
        variables: {'conversationId': conversationId},
      ),
    );

    if (result.hasException) {
      throw ServerException(result.exception.toString());
    }

    final data = result.data?['messages'] as List<dynamic>? ?? [];
    return data
        .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ConversationModel> createConversation(List<String> participantIds) async {
    const mutation = r'''
      mutation CreateConversation($participantIds: [String!]!) {
        createConversation(participantIds: $participantIds) {
          id
          participantIds
          participantNames
          createdAt
        }
      }
    ''';

    final result = await _client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: {'participantIds': participantIds},
      ),
    );

    if (result.hasException) {
      throw ServerException(result.exception.toString());
    }

    return ConversationModel.fromJson(
      result.data!['createConversation'] as Map<String, dynamic>,
    );
  }
}
