import 'package:Storyteller/src/models/user_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:Storyteller/src/models/message_model.dart';
import 'package:Storyteller/src/resources/repository.dart';

final bloc = BlockListBlock();

class BlockListBlock {
  final repository = Repository();

  final userFetcherStatus = PublishSubject<MessageModel>();
  final userFetcher = PublishSubject<UserModel>();

  Observable<UserModel> get allUsers => userFetcher.stream;
  Observable<UserModel> get userDetail => userFetcher.stream;

  dispose() async {
    await userFetcher.drain();
    userFetcherStatus.close();
    userFetcher.close();
  }

  fetchBlockedUser() async {
    UserModel userModel = await repository.getBlockedUser();
    userFetcher.sink.add(userModel);
  }

  unBlockuser(int id) async {
    MessageModel imageModel = await repository.unBlockUser(id);
    userFetcherStatus.sink.add(imageModel);
  }
}
