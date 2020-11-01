import 'dart:async';

import 'package:Storyteller/src/models/user_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:Storyteller/src/models/image_model.dart';
import 'package:Storyteller/src/models/message_model.dart';
import 'package:Storyteller/src/resources/repository.dart';

final bloc = SearchMainBloc();

class SearchMainBloc {
  final repository = Repository();
  final photoFetcherSearch = PublishSubject<ImageModel>();
  final photoFetcherStatusSearch = PublishSubject<MessageModel>();
  final userFetcher = PublishSubject<UserModel>();

  StreamView<ImageModel> get allPhotos => photoFetcherSearch.stream;
  StreamView<UserModel> get userDetail => userFetcher.stream;

  dispose() async {
    await photoFetcherSearch.drain();
    photoFetcherSearch.close();
    photoFetcherStatusSearch.close();
    userFetcher.close();
  }

  fetchUser(int userid) async {
    UserModel userModel = await repository.getUser(userid);
    userFetcher.sink.add(userModel);
    bloc.dispose();
  }

  fetchPhoto(String postSearch) async {
    ImageModel imageModel = await repository.fetchPhoto(postSearch);
    photoFetcherSearch.sink.add(imageModel);
  }

  unlikepost(int photoid) async {
    MessageModel imageModel = await repository.unlikePhoto(photoid);
    photoFetcherStatusSearch.sink.add(imageModel);
  }

  likepost(int photoid) async {
    MessageModel imageModel = await repository.likePhoto(photoid);
    photoFetcherStatusSearch.sink.add(imageModel);
  }

  reportpost(int postID) async {
    MessageModel imageModel = await repository.report(postID);
    photoFetcherStatusSearch.sink.add(imageModel);
  }

  savePost(int postId) async {
    MessageModel imageModel = await repository.savePost(postId);
    photoFetcherStatusSearch.sink.add(imageModel);
  }

  removePost(int postId) async {
    MessageModel imageModel = await repository.removePost(postId);
    photoFetcherStatusSearch.sink.add(imageModel);
  }
}
