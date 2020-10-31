import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:Storyteller/src/models/message_model.dart';
import 'package:Storyteller/src/resources/repository.dart';

final bloc = ResetBloc();

class ResetBloc {
  final repository = Repository();
  final resetFetcher = PublishSubject<MessageModel>();
  String email;
  StreamView<MessageModel> get getMessage => resetFetcher.stream;

  resetLogin(email) async {
    try {
      MessageModel userModel = await repository.resetLogin(email);
      resetFetcher.sink.add(userModel);
    } catch (e) {
      resetFetcher.sink.addError("invalid reset");
    }
  }

  dispose() {
    resetFetcher.close();
  }
}
