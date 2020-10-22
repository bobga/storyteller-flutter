import 'dart:convert';

class NotificationModel {
  _Notification notification;
  List<_Notification> datas = [];
  NotificationModel.fromJson(Map<String, dynamic> parsedJson) {
    notification = _Notification(parsedJson);
  }
  NotificationModel.fromJsonList(List<dynamic> parsedJson) {
    List<_Notification> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      _Notification data = _Notification(parsedJson[i]);
      temp.add(data);
    }
    datas = temp;
  }
  _Notification get data => notification;
}

class _Notification {
  String id;
  String type;
  String notifiabletype;
  String notifiableid;
  String data;
  String readat;
  String createdat;
  String updatedat;

  _Notification(parsedJson) {
    id = parsedJson['id'].toString();
    type = parsedJson['type'].toString();
    notifiabletype = parsedJson['notifiable_type'].toString();
    notifiableid = parsedJson['tynotifiable_idpe'].toString();
    data = jsonEncode(parsedJson['data']);
    readat = parsedJson['read_at'].toString();
    createdat = parsedJson['created_at'].toString();
    updatedat = parsedJson['updated_at'].toString();
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["type"] = type;
    map["notifiable_type"] = notifiabletype;
    map["notifiable_id"] = notifiableid;

    map["data"] = data;
    map["read_at"] = readat;
    map["created_at"] = createdat;
    map["updated_at"] = updatedat;

    return map;
  }
}
