import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:Storyteller/src/models/message_model.dart';
import 'package:Storyteller/src/models/user_model.dart';
import 'package:Storyteller/src/resources/repository.dart';

final bloc = SignUpBloc();

class SignUpBloc {
  final repository = Repository();
  final resetFetcher = PublishSubject<MessageModel>();
  StreamView<MessageModel> get getMessage => resetFetcher.stream;

  userSignup(User user) async {
    try {
      MessageModel userModel = await repository.userSignup(user);
      resetFetcher.sink.add(userModel);
    } catch (e) {
      resetFetcher.sink.addError(e);
    }
  }

  dispose() {
    resetFetcher.close();
  }
}
