import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:Storyteller/src/models/conversation_model.dart';
import 'package:Storyteller/src/models/message_model.dart';
import 'package:Storyteller/src/resources/repository.dart';

final bloc = ConversationBloc();

class ConversationBloc {
  final repository = Repository();
  final conversationFetcher = PublishSubject<ConversationModel>();
  final conversationFetcherStatus = PublishSubject<MessageModel>();

  StreamSubscription<ConversationModel> _subscription;

  ConversationBloc() {
    conversationFetcher.stream;
  }

  dispose() async {
    await conversationFetcher.drain();
    conversationFetcher.close();
    conversationFetcherStatus.close();
    _subscription.cancel();
  }

  fetchUserConversation(toUsernameController) async {
    ConversationModel conversationModel =
        await repository.fetchUserConversation(toUsernameController);
    conversationFetcher.sink.add(conversationModel);
  }

  saveConversation(Data conversation) async {
    try {
      MessageModel conversationModel =
          await repository.saveConversation(conversation);
      conversationFetcherStatus.sink.add(conversationModel);
    } catch (e) {
      conversationFetcherStatus.sink.addError(e);
    }
  }

  fetchUserConversationList(int toUsernameController) async {
    ConversationModel conversationModel =
        await repository.fetchUserConversationList(toUsernameController);
    conversationFetcher.sink.add(conversationModel);
  }
}
