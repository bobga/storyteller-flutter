// class StoryModel {
//   Story story;
//   List<Story> datas = [];

//   StoryModel.fromJson(Map<String, dynamic> parsedJson) {
//     story = Story(parsedJson);
//   }
//   StoryModel.fromJsonList(Map<String, dynamic> parsedJson) {
//     List<Story> temp = [];
//     for (int i = 0; i < parsedJson['data'].length; i++) {
//       Story data = Story(parsedJson['data'][i]);
//       temp.add(data);
//     }
//     datas = temp;
//   }
//   Story get data => story;
// }

// class Story {
//   int id;
//   int userId;
//   String path;
//   String duration;
//   String createdat;
//   String updatedat;

//   Story(parsedJson) {
//     id = parsedJson['id'];
//     userId = parsedJson['userId'];
//     path = parsedJson['path'];
//     duration = parsedJson['duration'];
//     createdat = parsedJson['created_at'];
//     updatedat = parsedJson['updated_at'];
//   }

//   Map toMap() {
//     var map = new Map<String, dynamic>();
//     map["id"] = id;
//     map["userId"] = userId;
//     map["path"] = path;
//     map["duration"] = duration;

//     return map;
//   }
// }

class Story {
  int id;
  int userId;
  String path;
  String duration;
  String type;
  String createdAt;
  String updatedAt;

  Story({
    this.id,
    this.userId,
    this.path,
    this.duration,
    this.type,
    this.createdAt,
    this.updatedAt,
  });
}
