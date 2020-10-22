import 'package:Storyteller/src/models/user_model.dart';

class ConversationModel {
  List<Data> datas = [];
  UserModel user;
  ConversationModel.fromJson(Map<String, dynamic> parsedJson) {
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
  int conversationFrom;
  int conversationTo;
  String message;
  UserModel from;
  UserModel to;
  String createdAt;
  String updatedAt;

  Data(parsedJson) {
    id = parsedJson['id'];
    conversationFrom = parsedJson['conversation_from'];
    conversationTo = parsedJson['conversation_to'];
    message = parsedJson['message'];
    from = UserModel.fromJson(parsedJson['from']);
    to = UserModel.fromJson(parsedJson['to']);
    createdAt = parsedJson['created_at'];
    updatedAt = parsedJson['updated_at'];
  }

  Data.add(int conversationFrom, int conversationTo, String message) {
    this.conversationFrom = conversationFrom;
    this.conversationTo = conversationTo;
    this.message = message;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["conversation_from"] = conversationFrom;
    map["conversation_to"] = conversationTo;
    map["message"] = message;
    return map;
  }
}
