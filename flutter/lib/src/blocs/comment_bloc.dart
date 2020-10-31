import 'dart:async';

import 'package:Storyteller/src/models/user_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:Storyteller/src/models/comment_model.dart';
import 'package:Storyteller/src/models/message_model.dart';
import 'package:Storyteller/src/resources/repository.dart';

final bloc = ConversationBloc();

class ConversationBloc {
  final repository = Repository();
  final commentFetcher = PublishSubject<CommentModel>();
  final commentFetcherStatus = PublishSubject<MessageModel>();
  final userFetcher = PublishSubject<UserModel>();

  StreamView<UserModel> get userDetail => userFetcher.stream;

  StreamSubscription<CommentModel> _subscription;

  ConversationBloc() {
    commentFetcher.stream;
  }

  dispose() async {
    await commentFetcher.drain();
    await userFetcher.drain();
    userFetcher.close();
    commentFetcher.close();
    commentFetcherStatus.close();
    _subscription.cancel();
  }

  fetchUser(int userid) async {
    UserModel userModel = await repository.getUser(userid);
    userFetcher.sink.add(userModel);
    bloc.dispose();
  }

  fetchComment(toPostController) async {
    CommentModel commentModel = await repository.fetchComment(toPostController);
    commentFetcher.sink.add(commentModel);
  }

  saveComment(Data comment) async {
    try {
      MessageModel conversationModel = await repository.saveComment(comment);
      commentFetcherStatus.sink.add(conversationModel);
    } catch (e) {
      commentFetcherStatus.sink.addError(e);
    }
  }

  deleteComment(int id) async {
    MessageModel imageModel = await repository.destroyComment(id);
    commentFetcherStatus.sink.add(imageModel);
  }

  like(int userId, int commentId) async {
    MessageModel imageModel = await repository.commentLike(userId, commentId);
    commentFetcherStatus.sink.add(imageModel);
  }

  unlike(int userId, int commentId) async {
    MessageModel imageModel = await repository.commentUnlike(userId, commentId);
    commentFetcherStatus.sink.add(imageModel);
  }
}
