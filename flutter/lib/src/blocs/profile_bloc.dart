import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:Storyteller/src/models/image_model.dart';
import 'package:Storyteller/src/models/message_model.dart';
import 'package:Storyteller/src/models/user_model.dart';
import 'package:Storyteller/src/resources/repository.dart';

final bloc = ProfileBloc();

class ProfileBloc {
  final repository = Repository();
  final photoFetcher = PublishSubject<ImageModel>();
  final photoFetcherStatus = PublishSubject<MessageModel>();
  final userFetcher = PublishSubject<UserModel>();
  final userFetcherStatus = PublishSubject<MessageModel>();

  StreamView<ImageModel> get allPhotos => photoFetcher.stream;
  StreamView<UserModel> get userDetail => userFetcher.stream;

  dispose() async {
    await photoFetcher.drain();
    await userFetcher.drain();
    photoFetcher.close();
    photoFetcherStatus.close();
    userFetcher.close();
    userFetcherStatus.close();
  }

  fetchUser(int userid) async {
    UserModel userModel = await repository.getUser(userid);
    userFetcher.sink.add(userModel);
    bloc.dispose();
  }

  destroypost(int photoid) async {
    MessageModel imageModel = await repository.destroyPhoto(photoid);
    photoFetcherStatus.sink.add(imageModel);
  }

  fetchUserPhotos(int userid) async {
    ImageModel imageModel = await repository.fetchUserPhotos(userid);
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

  unfollowuser(int userowner) async {
    MessageModel imageModel = await repository.unFollowUser(userowner);
    userFetcherStatus.sink.add(imageModel);
  }

  followuser(int userowner) async {
    MessageModel imageModel = await repository.followUser(userowner);
    userFetcherStatus.sink.add(imageModel);
  }

  blockuser(int id) async {
    MessageModel imageModel = await repository.blockUser(id);
    userFetcherStatus.sink.add(imageModel);
  }

  editUser(User user) async {
    try {
      MessageModel userModel = await repository.userEdit(user);
      userFetcherStatus.sink.add(userModel);
    } catch (e) {
      userFetcherStatus.sink.addError(e);
    }
  }

  deleteaccount(int userID) async {
    try {
      MessageModel userModel = await repository.deleteAccount(userID);
      userFetcherStatus.sink.add(userModel);
    } catch (e) {
      userFetcherStatus.sink.addError(e);
    }
  }

  reportpost(int postID) async {
    MessageModel imageModel = await repository.report(postID);
    photoFetcherStatus.sink.add(imageModel);
  }
}
