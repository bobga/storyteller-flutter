import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:Storyteller/src/models/message_model.dart';
import 'package:Storyteller/src/models/user_model.dart';
import 'package:Storyteller/src/resources/repository.dart';

final bloc = UsersBloc();

class UsersBloc {
  final repository = Repository();
  final userFetcher = PublishSubject<UserModel>();
  final userFetcherStatus = PublishSubject<MessageModel>();

  StreamView<UserModel> get allUsers => userFetcher.stream;

  dispose() async {
    await userFetcher.drain();
    userFetcher.close();
    userFetcherStatus.close();
  }

  fetchAllUsers(String userSearch) async {
    UserModel userModel = await repository.fetchAllUsers(userSearch);
    userFetcher.sink.add(userModel);
  }

  unFollowUser(int userid) async {
    MessageModel userModel = await repository.unFollowUser(userid);
    userFetcherStatus.sink.add(userModel);
  }

  followUser(int userid) async {
    MessageModel userModel = await repository.followUser(userid);
    userFetcherStatus.sink.add(userModel);
  }
}
