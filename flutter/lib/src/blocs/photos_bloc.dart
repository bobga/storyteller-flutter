// import 'package:Storyteller/src/models/story_model.dart';
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:Storyteller/src/models/image_model.dart';
import 'package:Storyteller/src/models/message_model.dart';
import 'package:Storyteller/src/resources/repository.dart';
import 'package:Storyteller/src/models/user_model.dart';

final bloc = PhotosBloc();

class PhotosBloc {
  final repository = Repository();
  final photoFetcher = PublishSubject<ImageModel>();
  final photoFetcherStatus = PublishSubject<MessageModel>();
  final userFetcher = PublishSubject<UserModel>();
  final storyFetcher = PublishSubject<UserModel>();
  final savedFetcher = PublishSubject<ImageModel>();
  // final storyListFetcher = PublishSubject<StoryModel>();

  StreamView<ImageModel> get allPhotos => photoFetcher.stream;
  StreamView<UserModel> get allStories => storyFetcher.stream;
  StreamView<UserModel> get userDetail => userFetcher.stream;
  StreamView<ImageModel> get allSavedPosts => savedFetcher.stream;
  // Observable<StoryModel> get allStoryList => storyListFetcher.stream;

  dispose() async {
    await photoFetcher.drain();
    await userFetcher.drain();
    await storyFetcher.drain();
    await savedFetcher.drain();
    // await storyListFetcher.drain();
    userFetcher.close();
    photoFetcher.close();
    storyFetcher.close();
    savedFetcher.close();
    photoFetcherStatus.close();
    // storyListFetcher.close();
  }

  fetchUser(int userid) async {
    UserModel userModel = await repository.getUser(userid);
    userFetcher.sink.add(userModel);
    bloc.dispose();
  }

  fetchAllPhoto() async {
    ImageModel imageModel = await repository.fetchAllPhoto();
    photoFetcher.sink.add(imageModel);
  }

  unlikepost(int photoid) async {
    MessageModel imageModel = await repository.unlikePhoto(photoid);
    photoFetcherStatus.sink.add(imageModel);
  }

  likepost(int photoid) async {
    MessageModel imageModel = await repository.likePhoto(photoid);
    photoFetcherStatus.sink.add(imageModel);
  }

  likespost(int photoid) async {
    UserModel userModel = await repository.likesPhoto(photoid);
    userFetcher.sink.add(userModel);
  }

  saveImage(Data image) async {
    try {
      MessageModel userModel = await repository.saveImage(image);
      photoFetcherStatus.sink.add(userModel);
    } catch (e) {
      photoFetcherStatus.sink.addError(e);
    }
  }

  savePost(int postId) async {
    MessageModel imageModel = await repository.savePost(postId);
    photoFetcherStatus.sink.add(imageModel);
  }

  removePost(int postId) async {
    MessageModel imageModel = await repository.removePost(postId);
    photoFetcherStatus.sink.add(imageModel);
  }

  fetchSavedList() async {
    ImageModel imageModel = await repository.fetchSavedList();
    savedFetcher.sink.add(imageModel);
  }

  reportpost(int postID) async {
    MessageModel imageModel = await repository.report(postID);
    photoFetcherStatus.sink.add(imageModel);
  }

  fetchStoryList() async {
    UserModel userModel = await repository.fetchStoryUser();
    storyFetcher.sink.add(userModel);
  }

  // fetchStories(int userId) async {
  //   StoryModel storyModel = await repository.fetchStories(userId);
  //   storyListFetcher.sink.add(storyModel);
  // }

  destoryStory(int id) async {
    MessageModel storyModel = await repository.destoryStory(id);
    photoFetcherStatus.sink.add(storyModel);
  }
}
