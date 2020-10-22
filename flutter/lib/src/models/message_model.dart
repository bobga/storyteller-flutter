class MessageModel {
  Message message;

  MessageModel.fromJson(Map<String, dynamic> parsedJson) {
    message = Message(parsedJson);
  }

  Message get data => message;
}

class Message {
  String message;
  bool status;

  Message(parsedJson) {
    message = parsedJson['message'];
    status = parsedJson['status'];
  }
  Message.set(String message, bool status) {
    this.message = message;
    this.status = status;
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["message"] = message;
    map["status"] = status;

    return map;
  }
}
