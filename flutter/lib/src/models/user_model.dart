class UserModel {
  User user;
  List<User> datas = [];

  UserModel.fromJson(Map<String, dynamic> parsedJson) {
    user = User(parsedJson);
  }
  UserModel.fromJsonList(Map<String, dynamic> parsedJson) {
    List<User> temp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      User data = User(parsedJson['data'][i]);
      temp.add(data);
    }
    datas = temp;
  }
  User get data => user;
}

class User {
  int id;
  String name;
  String username;
  String email;
  String password;
  String bio;
  String link;
  String avatar;
  String cover;
  String follow;
  int photocount;
  int follower;
  int following;
  String badge;
  String block;
  String createdat;
  String updatedat;

  User(parsedJson) {
    id = parsedJson['id'];
    name = parsedJson['name'];
    username = parsedJson['username'];
    email = parsedJson['email'];
    bio = parsedJson['bio'];
    link = parsedJson['link'];
    avatar = parsedJson['avatar'];
    cover = parsedJson['cover'];
    follow = parsedJson['follow'];
    photocount = parsedJson['photo_count'];
    follower = parsedJson['follower'];
    following = parsedJson['following'];
    badge = parsedJson['badge'];
    block = parsedJson['block'];
    createdat = parsedJson['created_at'];
    updatedat = parsedJson['updated_at'];
  }
  User.signup(String name, String email, String password) {
    this.name = name;
    this.email = email;
    this.password = password;
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["username"] = username;
    map["email"] = email;
    map["password"] = password;
    map["bio"] = bio;
    map["link"] = link;
    map["avatar"] = avatar;
    map["cover"] = cover;
    map["follow"] = follow;
    map["follower"] = follow;
    map["following"] = follow;
    map["photo_count"] = follow;

    return map;
  }

  User.edit(
    String name,
    String email,
    String bio,
    String link,
    String avatar,
  ) {
    this.name = name;
    this.username = username;
    this.email = email;
    this.bio = bio;
    this.avatar = avatar;
    this.link = link;
    this.cover = cover;
  }

  User.editNoPhoto(
    String name,
    String email,
    String bio,
    String link,
  ) {
    this.name = name;
    this.username = username;
    this.email = email;
    this.bio = bio;
    this.avatar = avatar;
    this.link = link;
    this.cover = cover;
  }

  User.editCover(
    String name,
    String email,
    String bio,
    String link,
    String cover,
  ) {
    this.name = name;
    this.username = username;
    this.email = email;
    this.bio = bio;
    this.avatar = avatar;
    this.link = link;
    this.cover = cover;
  }

  User.editNoCover(
    String name,
    String email,
    String bio,
    String link,
  ) {
    this.name = name;
    this.username = username;
    this.email = email;
    this.bio = bio;
    this.avatar = avatar;
    this.link = link;
    this.cover = cover;
  }
}
