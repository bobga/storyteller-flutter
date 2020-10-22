import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:Storyteller/src/models/conversation_model.dart';
import 'package:Storyteller/src/models/message_model.dart';
import 'package:Storyteller/src/resources/repository.dart';

final blocList = ConversationListBloc();

class ConversationListBloc {
  final repository = Repository();
  final conversationFetcher = PublishSubject<ConversationModel>();
  final conversationFetcherStatus = PublishSubject<MessageModel>();

  StreamSubscription<ConversationModel> _subscription;

  ConversationListBloc() {
    conversationFetcher.stream;
    _subscription = Observable<ConversationModel>.periodic(Duration(seconds: 1))
        .listen((data) {});
  }

  dispose() async {
    await conversationFetcher.drain();
    conversationFetcher.close();
    conversationFetcherStatus.close();
    _subscription.cancel();
  }

  fetchUserConversationList(int toUsernameController) async {
    ConversationModel conversationModel =
        await repository.fetchUserConversationList(toUsernameController);
    conversationFetcher.sink.add(conversationModel);
  }
}
