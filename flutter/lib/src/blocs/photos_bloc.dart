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

  Observable<ImageModel> get allPhotos => photoFetcher.stream;
  Observable<UserModel> get allUsers => userFetcher.stream;
  Observable<UserModel> get userDetail => userFetcher.stream;

  dispose() async {
    await photoFetcher.drain();
    await userFetcher.drain();
    userFetcher.close();
    photoFetcher.close();
    photoFetcherStatus.close();
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

  reportpost(int postID) async {
    MessageModel imageModel = await repository.report(postID);
    photoFetcherStatus.sink.add(imageModel);
  }
}
