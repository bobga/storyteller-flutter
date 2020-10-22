import 'dart:convert';
import 'package:Storyteller/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Storyteller/src/ui/profile.dart';
import '../blocs/notification_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'conversation_send.dart';
import 'dart:async';
import 'package:flutter_icons/flutter_icons.dart';
import 'globals.dart' as global;

class StoryTellerNotification extends StatefulWidget {
  @override
  PagewiseGridViewExample createState() => PagewiseGridViewExample();
}

class PagewiseGridViewExample extends State<StoryTellerNotification> {
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  bool user = true;
  @override
  void initState() {
    super.initState();
    bloc.fetchUser(0);
    bloc.userDetail.listen(
      (data) {
        if (data != null) {
          if (user == true) {
            print(data.user.id);
            global.userId = data.user.id;
            global.blockList = data.user.block;
            user = false;
          }
        }
      },
    );

    check().then(
      (internet) {
        if (internet == false) {
        } else {
          bloc.fetchAllNotifications();
          bloc.userFetcherStatus.listen((onData) {
            bloc.fetchAllNotifications();
          });
        }
      },
    );
  }

  bool isBlock(int id) {
    var blocklist = global.blockList.split(",");
    return blocklist.contains(id.toString());
  }

  bool isBlocked(String list) {
    var id = global.userId;
    var blocklist = list.split(",");
    return blocklist.contains(id.toString());
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  refresh() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildList(),
          Container(
            height: MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildList() {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          elevation: 0.0,
          expandedHeight: kToolbarHeight,
          pinned: true,
          floating: true,
          actions: [
            IconButton(
              icon: Icon(Feather.trash, size: 26.0),
              padding: EdgeInsets.only(right: 20.0),
              onPressed: () {
                bloc.readNotifications();
              },
            )
          ],
          centerTitle: false,
          title: Text(
            AppLocalizations.instance.text('activity'),
            style: TextStyle(
              fontFamily: 'SFProDisplayBold',
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        StreamBuilder(
          stream: bloc.allNotifications,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.datas.length == 0) {
                return SliverToBoxAdapter(
                  child: Container(
                    height: 50.0,
                    child: Center(
                      child: Text("Still nothing",
                          style: TextStyle(
                            color: Color.fromRGBO(148, 148, 148, 1),
                            fontSize: 11.7,
                          )),
                    ),
                  ),
                );
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      dynamic notificationdata =
                          json.decode(snapshot.data.datas[index].data);
                      print(snapshot.data.datas[index].data);
                      switch (snapshot.data.datas[index].type) {
                        case "App\\Notifications\\StartedToFollowNotification":
                          return isBlock(notificationdata["user"]["id"]) ==
                                  false
                              ? InkWell(
                                  child: ListTile(
                                    leading: ClipRRect(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                      child: CachedNetworkImage(
                                        height: kToolbarHeight / 1,
                                        width: kToolbarHeight / 1,
                                        fit: BoxFit.cover,
                                        imageUrl: (notificationdata["user"]
                                            ["avatar"]),
                                      ),
                                    ),
                                    title: new Text(
                                      notificationdata["user"]["name"],
                                      style: TextStyle(
                                        fontFamily: 'SFProDisplayBold',
                                      ),
                                    ),
                                    subtitle: new Text(
                                      AppLocalizations.instance
                                          .text('startfollow'),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StorytellerProfile(
                                                notificationdata["user"]["id"],
                                                false,
                                                refresh),
                                      ),
                                    );
                                  },
                                )
                              : Container();

                          break;
                        case "App\\Notifications\\LikedPhotoNotification":
                          return isBlock(notificationdata["user"]["id"]) ==
                                  false
                              ? ListTile(
                                  leading: ClipRRect(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                    child: CachedNetworkImage(
                                      height: kToolbarHeight / 1,
                                      width: kToolbarHeight / 1,
                                      fit: BoxFit.cover,
                                      imageUrl: (notificationdata["user"]
                                          ["avatar"]),
                                    ),
                                  ),
                                  title: new Text(
                                    notificationdata["user"]["name"],
                                    style: TextStyle(
                                      fontFamily: 'SFProDisplayBold',
                                    ),
                                  ),
                                  subtitle: new Text(
                                    AppLocalizations.instance.text('likedpost'),
                                  ),
                                  trailing: ClipRRect(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                    child: CachedNetworkImage(
                                      height: kToolbarHeight / 1.2,
                                      width: kToolbarHeight / 1.2,
                                      fit: BoxFit.cover,
                                      imageUrl: notificationdata["post"]
                                          ["image"],
                                    ),
                                  ),
                                )
                              : Container();

                          break;
                        case "App\\Notifications\\NewConversation":
                          return isBlock(notificationdata["from"]["id"]) ==
                                  false
                              ? InkWell(
                                  child: ListTile(
                                    leading: ClipRRect(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                      child: CachedNetworkImage(
                                        height: kToolbarHeight / 1.1,
                                        width: kToolbarHeight / 1.1,
                                        fit: BoxFit.cover,
                                        imageUrl: (notificationdata["from"]
                                            ["avatar"]),
                                      ),
                                    ),
                                    title: new Text(
                                      notificationdata["from"]["name"],
                                      style: TextStyle(
                                        fontFamily: 'SFProDisplayBold',
                                      ),
                                    ),
                                    subtitle: new Text(
                                      AppLocalizations.instance
                                          .text('recivedmessage'),
                                    ),
                                    trailing: ButtonTheme(
                                      height: kToolbarHeight / 1.7,
                                      minWidth:
                                          MediaQuery.of(context).size.width /
                                              3.7,
                                      child: FlatButton(
                                        color: Color.fromRGBO(0, 141, 252, 1),
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    10.0)),
                                        child: new Text(
                                          "Message",
                                          style: new TextStyle(
                                              fontSize: 16.5,
                                              color: Colors.white,
                                              fontFamily:
                                                  'SFProDisplayRegular'),
                                        ),
                                        onPressed: () {
                                          print(notificationdata);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ConversationSendForm(
                                                      notificationdata["from"]
                                                          ["id"]),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StorytellerProfile(
                                                notificationdata["from"]["id"],
                                                false,
                                                refresh),
                                      ),
                                    );
                                  },
                                )
                              : Container();

                          break;
                      }

                      return Container();
                    },
                    childCount: snapshot.data.datas.length,
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return SliverToBoxAdapter(
                child: Container(
                  height: 50.0,
                  child: Center(
                    child: Text(snapshot.error.toString()),
                  ),
                ),
              );
            }

            return SliverToBoxAdapter(
              child: Container(
                height: 50.0,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
