import 'package:Storyteller/src/models/user_model.dart';
// import 'package:Storyteller/src/models/image_model.dart';

class CommentModel {
  List<Data> datas = [];
  UserModel user;
  CommentModel.fromJson(Map<String, dynamic> parsedJson) {
    List<Data> temp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      Data data = Data(parsedJson['data'][i]);
      temp.add(data);
    }
    datas = temp;
    if (parsedJson['user'] != null) {
      user = UserModel.fromJson(parsedJson['user']);
    }
  }

  List<Data> get data => datas;
}

class Data {
  int id;
  int userId;
  int postId;
  String comment;
  UserModel from;
  int like;
  String isLike;
  int likecount;
  String createdAt;
  String updatedAt;
  String badge;

  Data(parsedJson) {
    id = parsedJson['id'];
    userId = parsedJson['user_id'];
    postId = parsedJson['post_id'];
    comment = parsedJson['comment'];
    from = UserModel.fromJson(parsedJson['from']);
    like = parsedJson['like'];
    isLike = parsedJson['is_like'];
    likecount = parsedJson['like_count'];
    createdAt = parsedJson['created_at'];
    updatedAt = parsedJson['updated_at'];
    badge = parsedJson['badge'];
  }

  Data.add(int userId, int postId, String comment) {
    this.userId = userId;
    this.postId = postId;
    this.comment = comment;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    // map["id"] = id;
    map["user_id"] = userId;
    map["post_id"] = postId;
    map["comment"] = comment;
    return map;
  }
}
