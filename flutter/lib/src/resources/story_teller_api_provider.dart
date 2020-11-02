import 'dart:convert';

import 'package:Storyteller/src/models/story_model.dart';
import 'package:http/http.dart' show Client;
import 'package:Storyteller/src/constant/httpService.dart';
import 'package:Storyteller/src/constant/utils.dart';
import 'package:Storyteller/src/models/conversation_model.dart' as conversation;
import 'package:Storyteller/src/models/comment_model.dart' as comment;
import 'package:Storyteller/src/models/image_model.dart';
import 'package:Storyteller/src/models/message_model.dart';
import 'package:Storyteller/src/models/notification_model.dart';
import 'package:Storyteller/src/models/user_model.dart';

class StoryTellerApiProvider {
  static Client client = Client();
  static var baseUrl = "${NetworkUtils.urlBase}${NetworkUtils.serverApi}";

  Future<ImageModel> fetchPhotoList() async {
    bool isLoggedIn = await HttpService().ensureLoggedIn();
    if (isLoggedIn) {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };
      var response = await client.get("${baseUrl}posts", headers: headers);
      if (response.statusCode == 200) {
        return ImageModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load post');
      }
    }
    return null;
  }

  Future<ImageModel> fetchList(String postSearch) async {
    bool isLoggedIn = await HttpService().ensureLoggedIn();
    if (isLoggedIn) {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };
      var response = await client.post("${baseUrl}posts/search",
          body: {'q': postSearch}, headers: headers);
      if (response.statusCode == 200) {
        return ImageModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load post');
      }
    }
    return null;
  }

  Future<UserModel> fetchUser() async {
    bool isLoggedIn = await HttpService().ensureLoggedIn();
    print("isLoggedIn == ${isLoggedIn}");
    if (isLoggedIn) {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };
      var response = await client.get("${baseUrl}users/me", headers: headers);
      if (response.statusCode == 200) {
        return UserModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load post');
      }
    } else {
      throw Exception('not valid login');
    }
  }

  static Future<String> fetchToken() async {
    var client = await HttpService().getClient();
    return client.credentials.accessToken.toString();
  }

  Future<MessageModel> resetUser(String email) async {
    Map<String, String> headers = {'Accept': 'application/json'};
    var response;
    response = await client.post("${baseUrl}forgot/password",
        body: {"email": email}, headers: headers);
    if (response.statusCode == 201) {
      return MessageModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed reset user');
    }
  }

  Future<MessageModel> signupUser(User user) async {
    Map<String, String> myheaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    String jsonBody = json.encode(user.toMap());

    var response = await client.post("${baseUrl}signup",
        body: jsonBody, headers: myheaders);
    if (response.statusCode == 201) {
      await HttpService().setClient(user.email, user.password);
      var message = Message.set(response.reasonPhrase, true);
      return MessageModel.fromJson(message.toMap());
    } else {
      throw Exception(
          MessageModel.fromJson(json.decode(response.body)).message.message);
    }
  }

  Future<UserModel> loginUserLogin(String username, String password) async {
    try {
      await HttpService().setClient(username, password);
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };
      var response = await client.get("${baseUrl}users/me", headers: headers);
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        print("result: ${headers.toString()}");
        return UserModel.fromJson(result["data"]);
      } else {
        print("Exception 1");
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print("Exception 2 == ${e.error}");
      throw Exception(e.error);
    }
  }

  Future<MessageModel> unlikePhoto(int photoid) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };
      var response = await client.delete("${baseUrl}posts/unlike/$photoid",
          headers: headers);
      if (response.statusCode == 201) {
        var result = json.decode(response.body);
        return MessageModel.fromJson(result);
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print(e);
      throw Exception(e.error);
    }
  }

  Future<MessageModel> destroyPhoto(int id) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };
      var response =
          await client.delete("${baseUrl}posts/destroy/$id", headers: headers);
      if (response.statusCode == 201) {
        var result = json.decode(response.body);
        return MessageModel.fromJson(result);
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print(e);
      throw Exception(e.error);
    }
  }

  Future<MessageModel> likePhoto(int photoid) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };
      var response =
          await client.post("${baseUrl}posts/like/$photoid", headers: headers);
      if (response.statusCode == 201) {
        var result = json.decode(response.body);
        return MessageModel.fromJson(result);
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      throw Exception(e.error);
    }
  }

  Future<UserModel> likesPhoto(int photoid) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + await fetchToken(),
    };
    var response =
        await client.get("${baseUrl}posts/likes/$photoid", headers: headers);
    if (response.statusCode == 200) {
      return UserModel.fromJsonList(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<MessageModel> unFollowUser(int userid) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };
      var response = await client.delete("${baseUrl}users/unfollow/$userid",
          headers: headers);
      if (response.statusCode == 201) {
        var result = json.decode(response.body);
        return MessageModel.fromJson(result);
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      throw Exception(e.error);
    }
  }

  Future<MessageModel> followUser(int userid) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };
      var response =
          await client.post("${baseUrl}users/follow/$userid", headers: headers);
      if (response.statusCode == 201) {
        var result = json.decode(response.body);
        return MessageModel.fromJson(result);
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      throw Exception(e.error);
    }
  }

  Future<MessageModel> blockUser(int userid) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };

      var response =
          await client.post("${baseUrl}users/block/$userid", headers: headers);
      if (response.statusCode == 201) {
        var result = json.decode(response.body);

        return MessageModel.fromJson(result);
      } else {
        throw Exception('Failed to block user');
      }
    } catch (e) {
      throw Exception(e.error);
    }
  }

  Future<MessageModel> unBlockUser(int userid) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };

      var response = await client.post("${baseUrl}users/unblock/$userid",
          headers: headers);
      print(json.decode(response.body));
      if (response.statusCode == 201) {
        var result = json.decode(response.body);
        return MessageModel.fromJson(result);
      } else {
        throw Exception('Failed to unblock user');
      }
    } catch (e) {
      throw Exception(e.error);
    }
  }

  Future<UserModel> fetchAllUsers(String userSearch) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + await fetchToken(),
    };
    var response = await client.post('${baseUrl}users/find',
        body: {'q': userSearch}, headers: headers);
    if (response.statusCode == 200) {
      return UserModel.fromJsonList(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<UserModel> getBlockedUser() async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + await fetchToken(),
    };
    var response =
        await client.post('${baseUrl}users/blocklist', headers: headers);
    if (response.statusCode == 201) {
      return UserModel.fromJsonList(json.decode(response.body));
    } else {
      throw Exception('Failed to load blocklist');
    }
  }

  Future<UserModel> getUser(int userid) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + await fetchToken(),
    };
    var response =
        await client.get('${baseUrl}users/$userid', headers: headers);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      return UserModel.fromJson(result["data"]);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<ImageModel> fetchUserPhotos(int userid) async {
    bool isLoggedIn = await HttpService().ensureLoggedIn();
    if (isLoggedIn) {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };
      var response =
          await client.get("${baseUrl}posts/$userid", headers: headers);
      if (response.statusCode == 200) {
        return ImageModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load post');
      }
    }
    return null;
  }

  Future<MessageModel> userEdit(User user) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + await fetchToken(),
    };
    String jsonBody = json.encode(user.toMap());

    var response = await client.patch("${baseUrl}users/0",
        body: jsonBody, headers: headers);
    if (response.statusCode == 201) {
      var message = Message.set(response.reasonPhrase, true);
      return MessageModel.fromJson(message.toMap());
    } else {
      throw Exception(
          MessageModel.fromJson(json.decode(response.body)).message.message);
    }
  }

  Future<NotificationModel> fetchAllNotifications() async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + await fetchToken(),
    };
    var response =
        await client.get('${baseUrl}users/notifications', headers: headers);
    if (response.statusCode == 201) {
      return NotificationModel.fromJsonList(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<MessageModel> saveImage(Data image) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + await fetchToken(),
    };
    String jsonBody = json.encode(image.toMap());
    var response =
        await client.post('${baseUrl}posts', body: jsonBody, headers: headers);
    if (response.statusCode == 201) {
      var message = Message.set(response.reasonPhrase, true);
      return MessageModel.fromJson(message.toMap());
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<MessageModel> savePost(int id) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + await fetchToken(),
    };
    var response =
        await client.post('${baseUrl}posts/save/$id', headers: headers);
    print(response.body);
    if (response.statusCode == 201) {
      var message = Message.set(response.reasonPhrase, true);
      return MessageModel.fromJson(message.toMap());
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<MessageModel> removePost(int id) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + await fetchToken(),
    };
    var response =
        await client.post('${baseUrl}posts/remove/$id', headers: headers);
    if (response.statusCode == 201) {
      var message = Message.set(response.reasonPhrase, true);
      return MessageModel.fromJson(message.toMap());
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<ImageModel> fetchSavedList() async {
    bool isLoggedIn = await HttpService().ensureLoggedIn();
    if (isLoggedIn) {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };
      var response =
          await client.post("${baseUrl}posts/savelist", headers: headers);
      if (response.statusCode == 200) {
        return ImageModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load post');
      }
    }
    return null;
  }

  Future<comment.CommentModel> fetchComments(toPostIdController) async {
    bool isLoggedIn = await HttpService().ensureLoggedIn();
    if (isLoggedIn) {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };
      Map data = {'post_id': toPostIdController};
      String jsonBody = json.encode(data);

      var response = await client.post("${baseUrl}comments/index",
          body: jsonBody, headers: headers);
      if (response.statusCode == 200) {
        return comment.CommentModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load post');
      }
    }
    return null;
  }

  Future<MessageModel> saveComment(comment.Data comment) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + await fetchToken(),
    };
    String jsonBody = json.encode(comment.toMap());
    var response = await client.post('${baseUrl}comments',
        body: jsonBody, headers: headers);
    if (response.statusCode == 201) {
      var message = Message.set(response.reasonPhrase, true);
      return MessageModel.fromJson(message.toMap());
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<MessageModel> commentLike(int userId, int commentId) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + await fetchToken(),
    };
    Map data = {'user_id': userId, 'comment_id': commentId};

    String jsonBody = json.encode(data);

    var response = await client.post('${baseUrl}comments/like',
        body: jsonBody, headers: headers);
    if (response.statusCode == 201) {
      var message = Message.set(response.reasonPhrase, true);
      return MessageModel.fromJson(message.toMap());
    } else {
      throw Exception('Failed to comment like');
    }
  }

  Future<MessageModel> commentUnlike(int userId, int commentId) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + await fetchToken(),
    };
    Map data = {'user_id': userId, 'comment_id': commentId};

    String jsonBody = json.encode(data);

    var response = await client.post('${baseUrl}comments/unlike',
        body: jsonBody, headers: headers);
    if (response.statusCode == 201) {
      var message = Message.set(response.reasonPhrase, true);
      return MessageModel.fromJson(message.toMap());
    } else {
      throw Exception('Failed to comment unlike');
    }
  }

  Future<MessageModel> destroyComment(int commentId) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };

      var response = await client.delete("${baseUrl}comments/$commentId",
          headers: headers);

      print(json.decode(response.body));
      if (response.statusCode == 201) {
        var result = json.decode(response.body);
        return MessageModel.fromJson(result);
      } else {
        throw Exception('Failed to delete comment');
      }
    } catch (e) {
      throw Exception(e.error);
    }
  }

  Future<conversation.ConversationModel> fetchUserConversations(
      toUsernameController) async {
    bool isLoggedIn = await HttpService().ensureLoggedIn();
    if (isLoggedIn) {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };
      var response = await client.get(
          "${baseUrl}conversations?conversation_to=$toUsernameController",
          headers: headers);
      if (response.statusCode == 200) {
        return conversation.ConversationModel.fromJson(
            json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load post');
      }
    }
    return null;
  }

  Future<MessageModel> saveConversation(conversation.Data conversation) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + await fetchToken(),
    };
    String jsonBody = json.encode(conversation.toMap());
    var response = await client.post('${baseUrl}conversations',
        body: jsonBody, headers: headers);
    if (response.statusCode == 201) {
      var message = Message.set(response.reasonPhrase, true);
      return MessageModel.fromJson(message.toMap());
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<conversation.ConversationModel> fetchUserConversationsList(
      toUsernameController) async {
    bool isLoggedIn = await HttpService().ensureLoggedIn();
    if (isLoggedIn) {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };
      var response = await client.get(
          "${baseUrl}conversations/list?conversation_to=$toUsernameController",
          headers: headers);
      if (response.statusCode == 200) {
        return conversation.ConversationModel.fromJson(
            json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load post');
      }
    }
    return null;
  }

  Future<MessageModel> deleteConversation(int toUserId) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };

      var response = await client.delete("${baseUrl}conversations/$toUserId",
          headers: headers);
      if (response.statusCode == 201) {
        var result = json.decode(response.body);
        return MessageModel.fromJson(result);
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print(e);
      throw Exception(e.error);
    }
  }

  Future<MessageModel> readNotifications() async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + await fetchToken(),
    };

    var response = await client.post('${baseUrl}users/read_notifications',
        headers: headers);
    if (response.statusCode == 201) {
      var message = Message.set(response.reasonPhrase, true);
      return MessageModel.fromJson(message.toMap());
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<MessageModel> report(int postID) async {
    String jsonBody = json.encode({"postID": postID});
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + await fetchToken(),
    };
    var response = await client.post('${baseUrl}posts/report',
        body: jsonBody, headers: headers);
    if (response.statusCode == 201) {
      var message = Message.set(response.reasonPhrase, true);
      return MessageModel.fromJson(message.toMap());
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<MessageModel> deleteAccount(int userID) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };

      var response = await client.delete("${baseUrl}users/destroy/$userID",
          headers: headers);
      if (response.statusCode == 201) {
        var result = json.decode(response.body);
        return MessageModel.fromJson(result);
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print(e);
      throw Exception(e.error);
    }
  }

  Future<UserModel> fetchStoryUser() async {
    bool isLoggedIn = await HttpService().ensureLoggedIn();
    if (isLoggedIn) {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };
      var response = await client.get("${baseUrl}stories", headers: headers);
      if (response.statusCode == 200) {
        return UserModel.fromJsonList(json.decode(response.body));
      } else {
        throw Exception('Failed to load story');
      }
    }
    return null;
  }

  // Future<StoryModel> fetchStories(int userId) async {
  //   bool isLoggedIn = await HttpService().ensureLoggedIn();

  //   if (isLoggedIn) {
  //     Map<String, String> headers = {
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer ' + await fetchToken(),
  //     };
  //     var response =
  //         await client.post("${baseUrl}stories/$userId", headers: headers);

  //     if (response.statusCode == 200) {
  //       return StoryModel.fromJsonList(json.decode(response.body));
  //     } else {
  //       throw Exception('Failed to load stories');
  //     }
  //   }
  //   return null;
  // }

  static Future<List<Story>> getStories(int userId) async {
    bool isLoggedIn = await HttpService().ensureLoggedIn();
    var res;
    if (isLoggedIn) {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };
      var response =
          await client.post("${baseUrl}stories/$userId", headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes))['data'];
        res = data.map<Story>((it) {
          return Story(
            id: it['id'],
            userId: it['user_id'],
            path: it['path'],
            duration: it['duration'],
            type: it['type'],
            createdAt: it['created_at'],
            updatedAt: it['updated_at'],
          );
        }).toList();
      } else {
        throw Exception('Failed to load stories');
      }
    }
    return res;
  }

  Future<MessageModel> destoryStory(int id) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + await fetchToken(),
      };

      var response = await client.delete("${baseUrl}stories/destroy/$id",
          headers: headers);
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        return MessageModel.fromJson(result);
      } else {
        throw Exception('Failed to delete post');
      }
    } catch (e) {
      print(e);
      throw Exception(e.error);
    }
  }
}
