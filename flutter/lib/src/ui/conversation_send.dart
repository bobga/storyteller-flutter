import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:Storyteller/src/models/conversation_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bubble/bubble.dart';
import '../blocs/conversation_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'profile.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConversationSendForm extends StatefulWidget {
  final int toUsernameController;
  ConversationSendForm(this.toUsernameController, {Key key10})
      : super(key: key10);

  @override
  StoryTellerConversationSend createState() =>
      new StoryTellerConversationSend();
}

class StoryTellerConversationSend extends State<ConversationSendForm> {
  TextEditingController messageController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
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
              print(widget.toUsernameController);
              bloc.fetchUserConversation(widget.toUsernameController);
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
            elevation: 1.0,
            centerTitle: false,
            title: StreamBuilder(
              stream: bloc.conversationFetcher,
              builder: (context, AsyncSnapshot<ConversationModel> snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StorytellerProfile(
                                snapshot.data.user.data.id,
                                false,
                                refresh,
                              ),
                            ),
                          ),
                        },
                        child: new CircleAvatar(
                          radius: 20.0,
                          backgroundImage: new CachedNetworkImageProvider(
                            (snapshot.data.user.data.avatar),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StorytellerProfile(
                                    snapshot.data.user.data.id,
                                    false,
                                    refresh,
                                  ),
                                ),
                              ),
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: new Text(
                                    snapshot.data.user.data.name,
                                    style: TextStyle(
                                      fontFamily: "SFProDisplayBold",
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                snapshot.data.user.data.badge == 'true'
                                    ? Container(
                                        padding: EdgeInsets.only(top: 1),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.transparent),
                                        child: Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: SvgPicture.network(
                                              "https://teling.app/wp-content/uploads/2020/09/check.svg",
                                              width: 14,
                                              height: 14),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                          // new Text(
                          //   snapshot.data.user.data.email,
                          //    style: TextStyle(
                          //    fontFamily: "SFProDisplayRegular",
                          //    fontSize: 14,
                          //    color: Color.fromRGBO(152, 152, 152, 1),
                          //  ),
                          // ),
                        ],
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return CircularProgressIndicator(
                  strokeWidth: 2.0,
                );
              },
            ),
          ),
          body: StreamBuilder(
            stream: bloc.conversationFetcher,
            builder: (context, AsyncSnapshot<ConversationModel> snapshot) {
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

  Widget buildList(AsyncSnapshot<ConversationModel> snapshot) {
    print(snapshot.data.data.length);
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            bottom: 85.0,
            left: 10,
            right: 10,
          ),
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            reverse: true,
            itemCount: snapshot.data.data.length,
            itemBuilder: (BuildContext context, int index) {
              int myIndex = snapshot.data.data.length - index - 1;
              return Container(
                child: snapshot.data.data[myIndex].to.user.id !=
                        widget.toUsernameController
                    ? Bubble(
                        margin: BubbleEdges.only(top: 4, right: 50, bottom: 8),
                        alignment: Alignment.topLeft,
                        elevation: 0.0,
                        color: Theme.of(context).cardColor,
                        radius: Radius.circular(10),
                        //  nip: BubbleNip.leftTop,
                        child: Text(snapshot.data.data[myIndex].message,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'SFProDisplayMedium',
                                fontSize: 17.8)),
                      )
                    : Bubble(
                        margin: BubbleEdges.only(top: 4, left: 50, bottom: 8),
                        alignment: Alignment.topRight,
                        //  nip: BubbleNip.rightTop,
                        color: Color.fromRGBO(0, 141, 252, 1),
                        elevation: 0.0,
                        radius: Radius.circular(10),
                        child: Text(
                          snapshot.data.data[myIndex].message,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontFamily: 'SFProDisplayRegular',
                              fontSize: 17,
                              color: Colors.white),
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
                      autofocus:true,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) {},
                      controller: messageController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Send a message...',
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
                    var message = Data.add(
                        0, widget.toUsernameController, messageController.text);
                    await bloc.saveConversation(message);
                    messageController.clear();
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
