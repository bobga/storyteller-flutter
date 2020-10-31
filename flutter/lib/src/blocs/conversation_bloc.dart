import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:Storyteller/src/models/conversation_model.dart';
import 'package:Storyteller/src/models/message_model.dart';
import 'package:Storyteller/src/resources/repository.dart';
import 'package:Storyteller/src/models/user_model.dart';

final bloc = ConversationBloc();

class ConversationBloc {
  final repository = Repository();
  final conversationFetcher = PublishSubject<ConversationModel>();
  final conversationFetcherStatus = PublishSubject<MessageModel>();
  final userFetcher = PublishSubject<UserModel>();
  
  StreamView<UserModel> get allUsers => userFetcher.stream;
  StreamView<UserModel> get userDetail => userFetcher.stream;

  StreamSubscription<ConversationModel> _subscription;

  ConversationBloc() {
    conversationFetcher.stream;
  }

  dispose() async {
    await conversationFetcher.drain();
    conversationFetcher.close();
    conversationFetcherStatus.close();
    _subscription.cancel();
    await userFetcher.drain();
    userFetcher.close();
  }

   fetchUser(int userid) async {
    UserModel userModel = await repository.getUser(userid);
    userFetcher.sink.add(userModel);
    bloc.dispose();
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
