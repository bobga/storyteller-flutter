import 'package:Storyteller/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Storyteller/src/blocs/conversation_list_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:Storyteller/src/models/conversation_model.dart';
import 'dart:async';
import 'conversation_send.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConversationListForm extends StatefulWidget {
  final int toUsernameController;
  ConversationListForm(this.toUsernameController);

  @override
  StoryTellerConversationList createState() =>
      new StoryTellerConversationList(toUsernameController);
}

class StoryTellerConversationList extends State<ConversationListForm> {
  
  TextEditingController messageController = TextEditingController();

  final int toUsernameController;

  StoryTellerConversationList(this.toUsernameController);
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
              blocList.fetchUserConversationList(toUsernameController);
              blocList.dispose();
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();

    blocList.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildList(),
          Container(
            height: MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          ),
        ],
      ),
    );
  }

  Widget buildList() {
    final screenSize = MediaQuery.of(context).size;
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          leading: Container(
                        transform: Matrix4.translationValues(5.0, 0.0, 0.0),
                        padding: EdgeInsets.only(left: 10.0, bottom: 0),
                        child: BackButton(),
                      ),
          elevation: 1.0,
          expandedHeight: kToolbarHeight,
          pinned: true,
          floating: true,
          title: Text(
            AppLocalizations.instance.text('messages'),
            style: TextStyle(
              fontFamily: 'SFProDisplayBold',
              fontSize: 23.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        StreamBuilder(
          stream: blocList.conversationFetcher,
          builder: (context, AsyncSnapshot<ConversationModel> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.datas.length == 0) {
                return SliverToBoxAdapter(
                  child: Container(
                    height: 50.0,
                    child: Center(
                      child: Text("No Conversations"),
                    ),
                  ),
                );
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return new Padding(
                        padding:
                            EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Material(
                            color: Theme.of(context).cardColor,
                            borderRadius: new BorderRadius.circular(20.0),
                            child: InkWell(
                              borderRadius: new BorderRadius.circular(20.0),
                              onTap: () {
                                navigateToConversation(
                                    snapshot.data.datas[index].to.user.id);
                              },
                              child: new 
                              GestureDetector(
                                onLongPress: () {
                                      showModalBottomSheet<dynamic>(
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                        context: context,
                                        builder: (BuildContext context) {
                                          
                                          return Wrap(children: <Widget>[
                                            Container(
                                              
                                              decoration: new BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      new BorderRadius.only(
                                                          topLeft: const Radius
                                                              .circular(30.0),
                                                          topRight: const Radius
                                                              .circular(30.0))),
                                              child: Container(
                                                
                                                child: Column(
                                                  children: <Widget>[
                                                    new Column(
                                                      mainAxisAlignment:
                                                       MainAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                           // width: screenSize.width - 45,
                                                            decoration: BoxDecoration(
                                                               borderRadius: BorderRadius.circular(10),
                                                            color: Colors.white,),
                                                            child:
                                                            Column(
                                                      mainAxisAlignment:
                                                       MainAxisAlignment.center,
                                                        children: [
                                                          ButtonTheme(
                                                     minWidth: screenSize.width - 45.8,
                                                      height: 56.0,
                                                       child: FlatButton(
                                                       child: Text(
                                                       'Delete message',
                                                       style: TextStyle(
                                                       color: Colors.red,
                                                       fontSize: 16.3,
                                                       fontFamily: 'SFProDisplayMedium'),
                                                       ),
                                                        color: Colors.white,
                                                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                                                        onPressed: () {
                                                         Navigator.pop(context);
                                                         }),
                                                        ),
                                                        ]
                                                            )
                                                            )

                                                       ]),

                                                     Container(height: 10),
                                                     ButtonTheme(
                                                     minWidth: screenSize.width - 45.8,
                                                      height: 56.0,
                                                       child: FlatButton(
                                                       child: Text(
                                                       AppLocalizations.instance.text('cancel'),
                                                       style: TextStyle(
                                                       color: Colors.black,
                                                       fontSize: 16.3,
                                                       fontFamily: 'SFProDisplayMedium'),
                                                       ),
                                                        color: Colors.white,
                                                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                                                        onPressed: () {
                                                         Navigator.pop(context);
                                                         }),
                                                        ),
                                                        Container(height: 40),



                                                  ],
                                                ),
                                              ),
                                            )
                                          ]);
                                        },
                                      );
                                    },
                                child:
                              ListTile(
                                leading: ClipRRect(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  child: CachedNetworkImage(
                                    height: kToolbarHeight / 1.0,
                                    width: kToolbarHeight / 1.0,
                                    fit: BoxFit.cover,
                                    imageUrl: snapshot
                                        .data.datas[index].to.user.avatar,
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Container(
                                      child: new Text(
                                        snapshot.data.datas[index].to.user.name,
                                        style: TextStyle(
                                          fontFamily: "SFProDisplayBold",
                                          fontSize: 16.6,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    snapshot.data.datas[index].to.user.badge ==
                                            'true'
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
                                subtitle: new Text(
                                  snapshot.data.datas[index].message,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            
                              ),
                              



                            ),
                          ),
                        ),
                      );
                    },
                    childCount: snapshot.data.data.length,
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

  void navigateToConversation(int id) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ConversationSendForm(id)));
  }
}
