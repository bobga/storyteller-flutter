import 'package:Storyteller/src/models/user_model.dart';
import 'package:Storyteller/src/models/comment_model.dart';

class ImageModel {
  List<Data> datas = [];

  ImageModel.fromJson(Map<String, dynamic> parsedJson) {
    List<Data> temp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      Data data = Data(parsedJson['data'][i]);
      temp.add(data);
    }
    datas = temp;
  }

  List<Data> get data => datas;
}

class Data {
  int id;
  int userid;
  String image;
  String description;
  int likes;
  String like;
  String saved;
  CommentModel from;
  int likecount;
  int commentcount;
  String createdat;
  String updatedat;
  UserModel user;

  Data(parsedJson) {
    id = parsedJson['id'];
    userid = parsedJson['user_id'];
    image = parsedJson['image'];
    description = parsedJson['description'];
    likes = parsedJson['likes'];
    user = UserModel.fromJson(parsedJson['user']);
    like = parsedJson['like'];
    saved = parsedJson['saved'];
    likecount = parsedJson['like_count'];
    commentcount = parsedJson['comment_count'];
    createdat = parsedJson['created_at'];
    updatedat = parsedJson['updated_at'];
  }

  Data.add(
    int userid,
    String image,
    int id,
    int likes,
    String description,
  ) {
    this.userid = userid;
    this.image = image;
    this.id = id;
    this.likes = likes;
    this.description = description;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["user_id"] = userid;
    map["image"] = image;
    map["likes"] = likes;
    map["description"] = description;
    return map;
  }
}
