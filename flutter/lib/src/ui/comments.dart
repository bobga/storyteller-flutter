import 'dart:async';
import 'package:Storyteller/src/ui/profile.dart';
import 'package:Storyteller/app_localizations.dart';
import 'package:Storyteller/src/models/comment_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:line_icons/line_icons.dart';
import '../blocs/comment_bloc.dart';
import 'globals.dart' as global;
import 'package:extended_text_field/extended_text_field.dart';

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
            leading: Container(
                        transform: Matrix4.translationValues(5.0, 0.0, 0.0),
                        padding: EdgeInsets.only(left: 10.0, bottom: 0),
                        child: BackButton(),
                      ),
            elevation: 0.6,
            title: Text(
              AppLocalizations.instance.text('comments'),
              style: TextStyle(
                fontFamily: "SFProDisplayBold",
                fontSize: 23.5,
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
    final screenSize = MediaQuery.of(context).size;
    print(snapshot.data.data.length);
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 0,
            bottom: 75.0,
            left: 10,
            right: 10,
          ),
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            reverse: false,
            itemCount: snapshot.data.data.length,
            itemBuilder: (BuildContext context, int index) {
              final screenSize = MediaQuery.of(context).size;
              return Container(
                margin: EdgeInsets.only(top: 5.0, bottom: 5),
                child: 
                Transform(
                transform: Matrix4.translationValues(-6, 0.0, 0.0),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: new BorderRadius.circular(30.0),
                    child: 
                    
                    GestureDetector(
                                    onTap: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              StorytellerProfile(
                                                  snapshot.data.data[index].from.user
                                                      .id,
                                                  false,
                                                  refresh),
                                        ),
                                      ),
                                    },
                                    child:
                    CachedNetworkImage(
                      height: kToolbarHeight / 1.3,
                      width: kToolbarHeight / 1.3,
                      fit: BoxFit.cover,
                      imageUrl: (snapshot.data.data[index].from.user.avatar),
                    ),
                    ),


                  ),
                  title: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[


                    Row(children: [
                      Container(
                        width: screenSize.width - 155,
                        
                        child:
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                               width: screenSize.width - 155,
                               child:
                               Container (
                                  alignment: Alignment.centerLeft,
                                   margin: const EdgeInsets.only(left:0.0, top: 0, bottom: 5, right: 0.0,),
                                   child: new Column (
                                     children: <Widget>[
                                       
                                       RichText(
                                         overflow: TextOverflow.ellipsis,
                                         softWrap: true,
                                         maxLines: 23,
                                         text: TextSpan(
                                           text: snapshot.data.data[index].from.user.name + ' ',
                                            style:
                                            TextStyle(fontFamily:"SFProDisplayBold",
                                            fontSize:14.6, color: Color.fromRGBO(28, 28, 28, 1),
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                 text: snapshot.data.data[index].comment,
                                                  style:
                                                  TextStyle(fontFamily:"SFProDisplayMedium",
                                                   fontSize:14.6, color: Color.fromRGBO(28, 28, 28, 1),
                                                   ),
                                                   ),
                                                   ],
                                                   ),
                                                   ),
                                               ],
                                          ),
                                        ),
                                      ),
                                    ]
                                  ),
                                ),

                  ]),


                  ]),
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
                            .replaceAll("moment", "few seconds")
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
                        width: 13.5,
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
                                  color: Color.fromRGBO(120, 120, 120, 1),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  trailing: Transform(
                transform: Matrix4.translationValues(6, 0.0, 0.0),
                child:
                  GestureDetector(
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

                ),
                ),
                padding: null,
              );
            },
          ),
        ),

  
Positioned(
          left: 0.0,
          bottom: 0.0,
          child:
           Container(
             decoration: BoxDecoration(
               color: Colors.white,
               border: Border(
                 top: BorderSide(
                   color: Color.fromRGBO(224, 224, 224, 1),
                   width: 1.0,
                   ),
               ),
             ),
             width: screenSize.width,
             height: 77,
           ),
        ),


        Positioned(
          left: 15.0,
          bottom: 14.0,
          child:
           CircleAvatar(
            radius: 23.5,
            backgroundImage: new CachedNetworkImageProvider(
              (global.avatar),
            ),
          ),
        ),
        Positioned(
          left: 70.0,
          bottom: 14.0,
          right: 15.0,
          child: 
          

          Container(
            //height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Theme.of(context).cardColor,
            ),
            child: 
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: TextField(
                      autofocus: true,
                      maxLines: null,
                      enableInteractiveSelection: true,
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
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Icon(LineIcons.paper_plane),
                  iconSize: 29.0,
                  color: Colors.blue,
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
