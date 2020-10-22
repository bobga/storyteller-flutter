import 'package:Storyteller/src/models/conversation_model.dart' as conversation;
import 'package:Storyteller/src/models/comment_model.dart' as comment;
import 'package:Storyteller/src/models/image_model.dart';
import 'package:Storyteller/src/models/message_model.dart';
import 'package:Storyteller/src/models/notification_model.dart';
import 'package:Storyteller/src/models/user_model.dart';

import 'story_teller_api_provider.dart';

class Repository {
  final storyTellerApiProvider = StoryTellerApiProvider();

  Future<ImageModel> fetchAllPhoto() => storyTellerApiProvider.fetchPhotoList();

  Future<ImageModel> fetchPhoto(String postSearch) =>
      storyTellerApiProvider.fetchList(postSearch);

  Future<UserModel> fetchUserLoginState() => storyTellerApiProvider.fetchUser();
  Future<MessageModel> resetLogin(String email) =>
      storyTellerApiProvider.resetUser(email);

  Future<MessageModel> userSignup(User user) =>
      storyTellerApiProvider.signupUser(user);

  Future<UserModel> loginUserLogin(String username, String password) =>
      storyTellerApiProvider.loginUserLogin(username, password);

  Future<MessageModel> unlikePhoto(int userid) =>
      storyTellerApiProvider.unlikePhoto(userid);

  Future<MessageModel> destroyPhoto(int userid) =>
      storyTellerApiProvider.destroyPhoto(userid);

  Future<MessageModel> likePhoto(int userid) =>
      storyTellerApiProvider.likePhoto(userid);

  Future<UserModel> likesPhoto(int userid) =>
      storyTellerApiProvider.likesPhoto(userid);

  Future<UserModel> fetchAllUsers(String userSearch) =>
      storyTellerApiProvider.fetchAllUsers(userSearch);

  Future<MessageModel> unFollowUser(int userid) =>
      storyTellerApiProvider.unFollowUser(userid);

  Future<MessageModel> followUser(int userid) =>
      storyTellerApiProvider.followUser(userid);

  Future<MessageModel> blockUser(int userid) =>
      storyTellerApiProvider.blockUser(userid);

  Future<MessageModel> unBlockUser(int userid) =>
      storyTellerApiProvider.unBlockUser(userid);

  Future<UserModel> getBlockedUser() => storyTellerApiProvider.getBlockedUser();

  Future<UserModel> getUser(int userid) =>
      storyTellerApiProvider.getUser(userid);

  Future<ImageModel> fetchUserPhotos(int userid) =>
      storyTellerApiProvider.fetchUserPhotos(userid);

  Future<MessageModel> userEdit(User user) =>
      storyTellerApiProvider.userEdit(user);

  Future<MessageModel> deleteAccount(int userID) =>
      storyTellerApiProvider.deleteAccount(userID);

  Future<MessageModel> report(int postID) =>
      storyTellerApiProvider.report(postID);

  Future<NotificationModel> fetchAllNotifications() =>
      storyTellerApiProvider.fetchAllNotifications();

  Future<MessageModel> saveImage(Data image) =>
      storyTellerApiProvider.saveImage(image);

  Future<comment.CommentModel> fetchComment(toPostIdController) =>
      storyTellerApiProvider.fetchComments(toPostIdController);

  Future<MessageModel> saveComment(comment.Data comment) =>
      storyTellerApiProvider.saveComment(comment);

  Future<MessageModel> commentLike(int userId, int commentId) =>
      storyTellerApiProvider.commentLike(userId, commentId);

  Future<MessageModel> commentUnlike(int userId, int commentId) =>
      storyTellerApiProvider.commentUnlike(userId, commentId);

  Future<MessageModel> destroyComment(int id) =>
      storyTellerApiProvider.destroyComment(id);

  Future<conversation.ConversationModel> fetchUserConversation(
          toUsernameController) =>
      storyTellerApiProvider.fetchUserConversations(toUsernameController);

  Future<MessageModel> saveConversation(conversation.Data conversation) =>
      storyTellerApiProvider.saveConversation(conversation);

  Future<conversation.ConversationModel> fetchUserConversationList(
          toUsernameController) =>
      storyTellerApiProvider.fetchUserConversationsList(toUsernameController);

  Future<MessageModel> readNotifications() =>
      storyTellerApiProvider.readNotifications();
}
