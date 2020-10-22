import 'dart:async';

import 'package:Storyteller/app_localizations.dart';
import 'package:Storyteller/src/models/comment_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:line_icons/line_icons.dart';
import '../blocs/comment_bloc.dart';
import 'globals.dart' as global;

class Comments extends StatefulWidget {
  final int toPostIdController;
  Comments(this.toPostIdController, {Key key10}) : super(key: key10);

  @override
  _Comments createState() => new _Comments();
}

class _Comments extends State<Comments> {
  TextEditingController commentController = TextEditingController();

  StreamSubscription connectivitySubscription;
  Timer timer;

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
            global.avatar = data.user.avatar;
            user = false;
          }
        }
      },
    );
    const oneSec = const Duration(seconds: 1);
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {});

    timer = Timer.periodic(
      oneSec,
      (timer) {
        connectivitySubscription.resume();
        check().then(
          (internet) {
            if (internet == false) {
            } else {
              print(widget.toPostIdController);
              bloc.fetchComment(widget.toPostIdController);
              bloc.dispose();
            }
          },
        );
      },
    );
  }

  refresh() {}

  @override
  void dispose() {
    timer.cancel();
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0.6,
            title: Text(
              AppLocalizations.instance.text('comments'),
              style: TextStyle(
                fontFamily: "SFProDisplayBold",
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: StreamBuilder(
            stream: bloc.commentFetcher,
            builder: (context, AsyncSnapshot<CommentModel> snapshot) {
              if (snapshot.hasData) {
                return buildList(snapshot);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              );
            },
          ),
        ),
        Container(
          height: MediaQuery.of(context).padding.top,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
          ),
        ),
      ],
    );
  }

  Widget buildList(AsyncSnapshot<CommentModel> snapshot) {
    print(snapshot.data.data.length);
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 10,
            bottom: 85.0,
            left: 10,
            right: 10,
          ),
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            reverse: false,
            itemCount: snapshot.data.data.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: new BorderRadius.circular(30.0),
                    child: CachedNetworkImage(
                      height: kToolbarHeight / 1.3,
                      width: kToolbarHeight / 1.3,
                      fit: BoxFit.cover,
                      imageUrl: (snapshot.data.data[index].from.user.avatar),
                    ),
                  ),
                  title: new Text(
                    snapshot.data.data[index].comment,
                    style: TextStyle(
                      fontFamily: 'SFProDisplayRegular',
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        timeago
                            .format(
                                DateTime.parse(
                                        snapshot.data.data[index].createdAt)
                                    .toLocal(),
                                locale: AppLocalizations.instance.mlangCode)
                            .replaceAll("ago", "")
                            .replaceAll("moment", "few")
                            .replaceAll("minute", "m")
                            .replaceAll("hour", "h")
                            .replaceAll("day", "d")
                            .replaceAll("s", ""),
                        style: TextStyle(
                          fontFamily: "SFProDisplayRegular",
                          fontSize: 15,
                          color: Color.fromRGBO(152, 152, 152, 1),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        snapshot.data.data[index].like == 1 ||
                                snapshot.data.data[index].like == 0
                            ? '${snapshot.data.data[index].like} like'
                            : '${snapshot.data.data[index].like} likes',
                        style: TextStyle(
                          fontFamily: "SFProDisplayRegular",
                          fontSize: 15,
                          color: Color.fromRGBO(120, 120, 120, 1),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      snapshot.data.data[index].from.user.id == global.userId
                          ? GestureDetector(
                              onTap: () {
                                bloc.deleteComment(
                                    snapshot.data.data[index].id);
                              },
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  fontFamily: "SFProDisplayRegular",
                                  fontSize: 15,
                                  color: Color.fromRGBO(220, 0, 0, 1),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      if (snapshot.data.data[index].isLike == "true") {
                        bloc.unlike(
                            global.userId, snapshot.data.data[index].id);
                      } else {
                        bloc.like(global.userId, snapshot.data.data[index].id);
                      }
                    },
                    child: snapshot.data.data[index].isLike == "true"
                        ? Icon(Icons.favorite, color: Colors.red, size: 23)
                        : Icon(
                            Icons.favorite_border,
                            size: 23,
                            color: Colors.black45,
                          ),
                  ),
                ),
                padding: null,
              );
            },
          ),
        ),
        Positioned(
          left: 15.0,
          bottom: 22.0,
          child: CircleAvatar(
            radius: 20.0,
            backgroundImage: new CachedNetworkImageProvider(
              (global.avatar),
            ),
          ),
        ),
        Positioned(
          left: 65.0,
          bottom: 22.0,
          right: 15.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Theme.of(context).cardColor,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: TextField(
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) {},
                      controller: commentController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Add a comment...',
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(LineIcons.paper_plane),
                  iconSize: 29.0,
                  color: Color.fromRGBO(0, 0, 0, 1),
                  onPressed: () async {
                    var message = Data.add(global.userId,
                        widget.toPostIdController, commentController.text);
                    await bloc.saveComment(message);
                    commentController.clear();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  await(Future<ConnectivityResult> checkConnectivity) {}
}
