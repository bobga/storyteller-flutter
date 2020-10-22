import 'package:Storyteller/src/models/user_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:Storyteller/src/models/message_model.dart';
import 'package:Storyteller/src/models/notification_model.dart';
import 'package:Storyteller/src/resources/repository.dart';

final bloc = NotificationsBloc();

class NotificationsBloc {
  final repository = Repository();
  final notificationFetcher = PublishSubject<NotificationModel>();
  final userFetcherStatus = PublishSubject<MessageModel>();
  final userFetcher = PublishSubject<UserModel>();

  Observable<NotificationModel> get allNotifications =>
      notificationFetcher.stream;
  Observable<UserModel> get userDetail => userFetcher.stream;

  dispose() async {
    await notificationFetcher.drain();
    notificationFetcher.close();
    userFetcherStatus.close();
    userFetcher.close();
  }

  fetchUser(int userid) async {
    UserModel userModel = await repository.getUser(userid);
    userFetcher.sink.add(userModel);
    bloc.dispose();
  }

  fetchAllNotifications() async {
    NotificationModel userModel = await repository.fetchAllNotifications();
    notificationFetcher.sink.add(userModel);
  }

  unFollowUser(int userid) async {
    MessageModel userModel = await repository.unFollowUser(userid);
    userFetcherStatus.sink.add(userModel);
  }

  followUser(int userid) async {
    MessageModel userModel = await repository.followUser(userid);
    userFetcherStatus.sink.add(userModel);
  }

  readNotifications() async {
    MessageModel userModel = await repository.readNotifications();
    userFetcherStatus.sink.add(userModel);
  }
}
