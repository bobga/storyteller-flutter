import 'dart:ui';
import 'package:Storyteller/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:Storyteller/src/ui/edit_cover.dart';
import 'package:Storyteller/src/ui/video.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Storyteller/src/models/user_model.dart';
import 'package:Storyteller/src/ui/conversation_send.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'bottomNavigation.dart';
import 'settings.dart';
import 'package:line_icons/line_icons.dart';
import '../blocs/profile_bloc.dart';
import 'globals.dart' as global;
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'package:mime/mime.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_icons/flutter_icons.dart' as ico;
import 'dart:math' as math;
import 'package:Storyteller/src/ui/comments.dart';
import 'package:flutter_icons/flutter_icons.dart';

class StorytellerProfile extends StatefulWidget {
  final int idController;
  final bool searchContentPage;
  final Function() notifyParent;

  StorytellerProfile(
      this.idController, this.searchContentPage, this.notifyParent,
      {Key key})
      : super(key: key);

  @override
  MyTimelinePage createState() => new MyTimelinePage();
}

class MyTimelinePage extends State<StorytellerProfile> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int counterbus = 0;
  Color _colorforFollow = Color.fromRGBO(0, 141, 252, 1);
  Color _colorforUnfollow = Color.fromRGBO(212, 212, 212, 1);
  Color blue = Color.fromRGBO(0, 0, 0, 1);
  int likebus = 0;

  checkFileType(String url) {
    String mimeStr = lookupMimeType(url);
    var fileType = mimeStr.split('/');
    print(fileType[0]);
    return fileType[0];
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  void _onRefresh() async {
    // monitor network fetch
    // await bloc.fetchUser();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  bool auto = false;

  @override
  void initState() {
    super.initState();
    if (widget.idController != 0) {
      auto = true;
    }
    check().then(
      (internet) {
        if (internet == false) {
        } else {
          print(global.userId);
          if (widget.searchContentPage == true) {
            global.spin = true;
          } else {
            global.spin = false;
          }
          bloc.fetchUser(widget.idController);
          bloc.fetchUserPhotos(widget.idController);
          bloc.photoFetcherStatus.listen((onData) {
            if (likebus <= 0) {
              setState(() {
                likebus++;
              });
            }

            bloc.fetchUserPhotos(widget.idController);
          });
          bloc.userFetcherStatus.listen(
            (onData) {
              if (counterbus <= 0) {
                if (!mounted) return;
                setState(() {
                  counterbus++;
                });

                bloc.fetchUser(widget.idController);
              }
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  void savedShow() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text(
            AppLocalizations.instance.text('successreport'),
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Container(
            padding: EdgeInsets.only(top: 40.0),
            child: Icon(
              Icons.check_circle,
              size: 50,
              color: Color.fromRGBO(9, 214, 63, 1),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                AppLocalizations.instance.text('close'),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void blockuser(int block_id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text(
            AppLocalizations.instance.text('blockuser'),
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontSize: 13.6,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Container(
            padding: EdgeInsets.only(top: 30.0),
            child: Icon(Icons.block, size: 50, color: Colors.red),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                AppLocalizations.instance.text(
                  'block',
                ),
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                bloc.blockuser(block_id);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoryTellerBottom(),
                  ),
                );
              },
            ),
            new FlatButton(
              child: new Text(
                AppLocalizations.instance.text('close'),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  swipeDownRefresh() {}
  refresh() {}

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                elevation: 0.0,
                expandedHeight: kToolbarHeight,
                pinned: true,
                backgroundColor: Colors.white,
                floating: true,
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: StreamBuilder(
                  stream: bloc.userDetail,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          child: buildProfileTitle(
                              context, snapshot, widget.idController));
                    }

                    return SizedBox();
                  },
                ),
                leading: auto
                    ? Container(
                        transform: Matrix4.translationValues(5.0, 0.0, 0.0),
                        padding: EdgeInsets.only(left: 10.0, bottom: 0),
                        child: BackButton(),
                      )
                    : StreamBuilder(
                        stream: bloc.userDetail,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                                child: buildProfileAdd(
                                    context, snapshot, widget.idController));
                          }

                          return SizedBox();
                        },
                      ),
                actions: [
                  StreamBuilder(
                    stream: bloc.userDetail,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                            child: buildProfileSettings(
                                context, snapshot, widget.idController));
                      }

                      return SizedBox();
                    },
                  ),
                ],
              ),
              StreamBuilder(
                stream: bloc.userDetail,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        child: buildProfileHeader(
                            context, snapshot, widget.idController));
                  }

                  return SliverToBoxAdapter(
                    child: Container(
                      height: 0.0,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                        ),
                      ),
                    ),
                  );
                },
              ),
              StreamBuilder(
                stream: bloc.allPhotos,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.data.length == 0) {
                      return SliverToBoxAdapter(
                        child: Container(
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Sorry, but there is nothing to see.",
                              style: TextStyle(
                                fontFamily: "SFProDisplayBold",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Column(
                              children: <Widget>[
                                new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 15.0,
                                            right: 15.0,
                                            bottom: 10.0,
                                            top: 10.0),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0),
                                              child: CachedNetworkImage(
                                                height: kToolbarHeight / 1.1,
                                                width: kToolbarHeight / 1.1,
                                                fit: BoxFit.cover,
                                                placeholder: (c, d) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2.0,
                                                    ),
                                                  );
                                                },
                                                imageUrl: snapshot
                                                    .data
                                                    .data[index]
                                                    .user
                                                    .data
                                                    .avatar,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Row(
                                                      children: [
                                                        new Text(
                                                          snapshot
                                                              .data
                                                              .data[index]
                                                              .user
                                                              .data
                                                              .name,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "SFProDisplayBold",
                                                            fontSize: 17,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        snapshot
                                                                    .data
                                                                    .data[index]
                                                                    .user
                                                                    .data
                                                                    .badge ==
                                                                'true'
                                                            ? Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 1),
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .transparent),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(0),
                                                                  child: SvgPicture
                                                                      .network(
                                                                          "https://teling.app/wp-content/uploads/2020/09/check.svg",
                                                                          width:
                                                                              14,
                                                                          height:
                                                                              14),
                                                                ),
                                                              )
                                                            : Container(),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 2.0,
                                                    ),
                                                    new Text(
                                                      timeago.format(
                                                          DateTime.parse(snapshot
                                                                  .data
                                                                  .data[index]
                                                                  .createdat)
                                                              .toLocal(),
                                                          locale:
                                                              AppLocalizations
                                                                  .instance
                                                                  .mlangCode),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            "SFProDisplayRegular",
                                                        fontSize: 14,
                                                        color: Color.fromRGBO(
                                                            152, 152, 152, 1),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(children: [
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            (widget.idController == 0 ||
                                                    widget.idController ==
                                                        global.userId)
                                                ? MaterialButton(
                                                    height: 20.0,
                                                    minWidth: 65.0,
                                                    child: const Icon(
                                                        LineIcons.ellipsis_h),
                                                    onPressed: () {
                                                      showModalBottomSheet<
                                                          dynamic>(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        isScrollControlled:
                                                            true,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0)),
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Wrap(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  decoration: new BoxDecoration(
                                                                      color: Colors
                                                                          .transparent,
                                                                      borderRadius: new BorderRadius
                                                                              .only(
                                                                          topLeft: const Radius.circular(
                                                                              30.0),
                                                                          topRight:
                                                                              const Radius.circular(30.0))),
                                                                  child:
                                                                      Container(
                                                                    child:
                                                                        Column(
                                                                      children: <
                                                                          Widget>[
                                                                        new Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Container(
                                                                                  width: screenSize.width - 45,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                                    ButtonTheme(
                                                                                      minWidth: screenSize.width - 46,
                                                                                      height: 54.0,
                                                                                      child: FlatButton(
                                                                                        //splashColor: Colors.transparent,
                                                                                        //highlightColor: Colors.transparent,
                                                                                        child: Text(
                                                                                          AppLocalizations.instance.text('deletepost'),
                                                                                          style: TextStyle(color: Colors.red, fontSize: 15.0, fontFamily: 'SFProDisplayMedium'),
                                                                                        ),
                                                                                        color: Colors.transparent,
                                                                                        shape: new RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0))),
                                                                                        onPressed: () {
                                                                                          bloc.destroypost(snapshot.data.data[index].id);
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                    const Divider(
                                                                                      color: Color.fromRGBO(224, 224, 224, 1),
                                                                                      height: 1,
                                                                                      thickness: 0,
                                                                                      indent: 20,
                                                                                      endIndent: 20,
                                                                                    ),
                                                                                    ButtonTheme(
                                                                                      minWidth: screenSize.width - 46,
                                                                                      height: 54.0,
                                                                                      child: FlatButton(
                                                                                        // splashColor: Colors.transparent,
                                                                                        //  highlightColor: Colors.transparent,
                                                                                        child: Text(
                                                                                          AppLocalizations.instance.text('share'),
                                                                                          style: TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'SFProDisplayMedium'),
                                                                                        ),
                                                                                        color: Colors.transparent,
                                                                                        shape: new RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.0), bottomLeft: Radius.circular(10.0))),
                                                                                        onPressed: () {
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                  ]))
                                                                            ]),
                                                                        Container(
                                                                            height:
                                                                                10),
                                                                        ButtonTheme(
                                                                          minWidth:
                                                                              screenSize.width - 46,
                                                                          height:
                                                                              54.0,
                                                                          child: FlatButton(
                                                                              // splashColor: Colors.transparent,
                                                                              // highlightColor: Colors.transparent,
                                                                              child: Text(
                                                                                AppLocalizations.instance.text('cancel'),
                                                                                style: TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'SFProDisplayMedium'),
                                                                              ),
                                                                              color: Colors.white,
                                                                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              }),
                                                                        ),
                                                                        Container(
                                                                            height:
                                                                                40),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              ]);
                                                        },
                                                      );
                                                    },
                                                  )
                                                : MaterialButton(
                                                    height: 20.0,
                                                    minWidth: 65.0,
                                                    child: const Icon(
                                                        LineIcons.ellipsis_h),
                                                    onPressed: () {
                                                      showModalBottomSheet<
                                                          dynamic>(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        isScrollControlled:
                                                            true,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0)),
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Wrap(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  decoration: new BoxDecoration(
                                                                      color: Colors
                                                                          .transparent,
                                                                      borderRadius: new BorderRadius
                                                                              .only(
                                                                          topLeft: const Radius.circular(
                                                                              30.0),
                                                                          topRight:
                                                                              const Radius.circular(30.0))),
                                                                  child:
                                                                      Container(
                                                                    child:
                                                                        Column(
                                                                      children: <
                                                                          Widget>[
                                                                        new Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Container(
                                                                                  width: screenSize.width - 45,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                                    ButtonTheme(
                                                                                      minWidth: screenSize.width - 46,
                                                                                      height: 53.0,
                                                                                      child: FlatButton(
                                                                                        //splashColor: Colors.transparent,
                                                                                        // highlightColor: Colors.transparent,
                                                                                        child: Text(
                                                                                          AppLocalizations.instance.text('reportpost'),
                                                                                          style: TextStyle(color: Colors.red, fontSize: 15.0, fontFamily: 'SFProDisplayMedium'),
                                                                                        ),
                                                                                        color: Colors.transparent,
                                                                                        shape: new RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0))),
                                                                                        onPressed: () {
                                                                                          print(snapshot.data.data[index].id);
                                                                                          bloc.reportpost(snapshot.data.data[index].id);
                                                                                          Navigator.pop(context);
                                                                                          savedShow();
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                    const Divider(
                                                                                      color: Color.fromRGBO(224, 224, 224, 1),
                                                                                      height: 1,
                                                                                      thickness: 0,
                                                                                      indent: 20,
                                                                                      endIndent: 20,
                                                                                    ),
                                                                                    ButtonTheme(
                                                                                      minWidth: screenSize.width - 46,
                                                                                      height: 53.0,
                                                                                      child: FlatButton(
                                                                                        //splashColor: Colors.transparent,
                                                                                        // highlightColor: Colors.transparent,
                                                                                        child: Text(
                                                                                          AppLocalizations.instance.text('share'),
                                                                                          style: TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'SFProDisplayMedium'),
                                                                                        ),
                                                                                        color: Colors.transparent,
                                                                                        shape: new RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.0), bottomLeft: Radius.circular(10.0))),
                                                                                        onPressed: () {
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                  ]))
                                                                            ]),
                                                                        Container(
                                                                            height:
                                                                                10),
                                                                        ButtonTheme(
                                                                          minWidth:
                                                                              screenSize.width - 46,
                                                                          height:
                                                                              53.0,
                                                                          child: FlatButton(
                                                                              // splashColor: Colors.transparent,
                                                                              // highlightColor: Colors.transparent,
                                                                              child: Text(
                                                                                AppLocalizations.instance.text('cancel'),
                                                                                style: TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'SFProDisplayMedium'),
                                                                              ),
                                                                              color: Colors.white,
                                                                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              }),
                                                                        ),
                                                                        Container(
                                                                            height:
                                                                                40),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              ]);
                                                        },
                                                      );
                                                    },
                                                  ),
                                          ],
                                        ),
                                      ]),
                                    ]),
                                GestureDetector(
                                  onDoubleTap: () {
                                    (snapshot.data.data[index].like == "true")
                                        ? bloc.unlikepost(
                                            snapshot.data.data[index].id)
                                        : bloc.likepost(
                                            snapshot.data.data[index].id);
                                  },
                                  child: new Container(
                                    child: Stack(children: <Widget>[
                                      new Container(
                                        padding: EdgeInsets.only(
                                          left: 0,
                                          right: 0,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              new BorderRadius.circular(0.0),
                                          child: checkFileType(snapshot.data
                                                      .data[index].image) ==
                                                  "image"
                                              ? CachedNetworkImage(
                                                  width: screenSize.width,
                                                  placeholder: (c, d) {
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2.0,
                                                      ),
                                                    );
                                                  },
                                                  fit: BoxFit.cover,
                                                  imageUrl: snapshot
                                                      .data.data[index].image,
                                                )
                                              : VideoClip(
                                                  url: snapshot
                                                      .data.data[index].image,
                                                ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                                SizedBox(
                                  height: 0,
                                ),
                                Container(
                                  width: screenSize.width,
                                  child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: screenSize.width,
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.only(
                                              left: 16.0,
                                              top: 13,
                                              bottom: 13,
                                              right: 16.0,
                                            ),
                                            child: new Column(
                                              children: <Widget>[
                                                RichText(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  maxLines: 3,
                                                  text: TextSpan(
                                                    text: snapshot
                                                            .data
                                                            .data[index]
                                                            .user
                                                            .data
                                                            .name +
                                                        ' ',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          "SFProDisplayBold",
                                                      fontSize: 13.7,
                                                      color: Color.fromRGBO(
                                                          28, 28, 28, 1),
                                                    ),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: snapshot
                                                            .data
                                                            .data[index]
                                                            .description,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "SFProDisplayMedium",
                                                          fontSize: 13.7,
                                                          color: Color.fromRGBO(
                                                              28, 28, 28, 1),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                                Column(children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: const Divider(
                                      color: Color.fromRGBO(224, 224, 224, 1),
                                      height: 1,
                                      thickness: 0,
                                      indent: 16,
                                      endIndent: 16,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 0.0,
                                      bottom: 13,
                                      left: 20,
                                      right: 26,
                                    ),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            child: Row(children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  (snapshot.data.data[index]
                                                              .like ==
                                                          "true")
                                                      ? bloc.unlikepost(snapshot
                                                          .data.data[index].id)
                                                      : bloc.likepost(snapshot
                                                          .data.data[index].id);
                                                },
                                                child: (snapshot.data
                                                            .data[index].like ==
                                                        "true")
                                                    ? Icon(Icons.favorite,
                                                        color: Colors.red,
                                                        size: 23)
                                                    : Icon(
                                                        Icons.favorite_border,
                                                        size: 23,
                                                        color: Colors.black45,
                                                      ),
                                              ),
                                              SizedBox(
                                                width: 5.0,
                                              ),
                                              Text(
                                                snapshot.data.data[index]
                                                        .likecount
                                                        .toString() +
                                                    ' ' +
                                                    AppLocalizations.instance
                                                        .text('like'),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily:
                                                      "SFProDisplayMedium",
                                                  fontSize: 14.5,
                                                  color: Colors.black45,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ])),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Comments(
                                                    snapshot
                                                        .data.data[index].id),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Transform(
                                                    alignment: Alignment.center,
                                                    transform:
                                                        Matrix4.rotationY(
                                                            math.pi),
                                                    child: Icon(
                                                        Feather.message_circle,
                                                        color: Colors.black45,
                                                        size: 21.7),
                                                  ),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      AppLocalizations.instance
                                                          .text('comments'),
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            "SFProDisplayMedium",
                                                        fontSize: 14.5,
                                                        color: Colors.black45,
                                                      ),
                                                    ),
                                                  )
                                                ]),
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.bookmark_border,
                                                    color: Colors.black45,
                                                    size: 22.6),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Text(
                                                  AppLocalizations.instance
                                                      .text('save'),
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "SFProDisplayMedium",
                                                    fontSize: 14.5,
                                                    color: Colors.black45,
                                                  ),
                                                )
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: const Divider(
                                      color: Color.fromRGBO(224, 224, 224, 1),
                                      height: 1,
                                      thickness: 0,
                                      indent: 0,
                                      endIndent: 0,
                                    ),
                                  ),
                                ])
                              ],
                            );
                          },
                          childCount: snapshot.data.data.length,
                        ),
                      );
                    }
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
          ),
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

  Widget buildProfileAdd(
      context, AsyncSnapshot<UserModel> user, int userowner) {
    return user.data.user.badge == 'true'
        ? Container(
            child: IconButton(
            icon: Icon(LineIcons.plus, size: 31.0),
            padding: EdgeInsets.only(left: 15.0, bottom: 0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCover(),
                ),
              );
            },
          ))
        : Container(
            child: IconButton(
            icon: Icon(LineIcons.plus, size: 31.0),
            padding: EdgeInsets.only(left: 15.0, bottom: 0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCover(),
                ),
              );
            },
          ));
  }

  Widget buildProfileSettings(
      context, AsyncSnapshot<UserModel> user, int userowner) {
    return (widget.idController == 0 || widget.idController == global.userId)
        ? user.data.user.badge == 'true'
            ? Container(
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(
                    child: IconButton(
                  icon: Icon(LineIcons.bars, size: 30.0),
                  padding: EdgeInsets.only(right: 20.0, bottom: 2),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsForm(),
                      ),
                    );
                  },
                ))
              ]))
            : Row(children: [
                Container(
                    child: IconButton(
                  icon: Icon(LineIcons.bars, size: 30.0),
                  padding: EdgeInsets.only(right: 20.0, bottom: 2),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsForm(),
                      ),
                    );
                  },
                ))
              ])
        : Container(
            child: IconButton(
            icon: Icon(Feather.user_x, size: 26.0, color: Colors.black26),
            padding: EdgeInsets.only(right: 20.0, bottom: 1.3),
            onPressed: () {
              this.blockuser(user.data.user.id);
            },
          ));
  }

  Widget buildProfileTitle(
      context, AsyncSnapshot<UserModel> user, int userowner) {
    final screenSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          transform: Matrix4.translationValues(-6.0, -2.0, 0.0),
          child: new Text(
            user.data.user.name,
            style: new TextStyle(
              fontFamily: 'SFProDisplayBold',
              fontSize: 19.5,
            ),
          ),
        ),
        SizedBox(
          width: 0,
        ),
        user.data.user.badge == 'true'
            ? Container(
                transform: Matrix4.translationValues(-1.7, -1.0, 0.0),
                padding: EdgeInsets.only(top: 1.7),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.transparent),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: SvgPicture.network(
                      "https://teling.app/wp-content/uploads/2020/09/check.svg",
                      width: 15.5,
                      height: 15.5),
                ),
              )
            : Container(
                width: 0,
              ),
      ],
    );
  }

  Widget buildProfileHeader(
      context, AsyncSnapshot<UserModel> user, int userowner) {
    final screenSize = MediaQuery.of(context).size;
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            color: Colors.black12,
            width: double.infinity,
            height: 200,
            child: user.data.user.cover != null
                ? CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: user.data.user.cover,
                  )
                : Container(
                    height: kToolbarHeight * 3,
                    width: kToolbarHeight * 3,
                    child: (widget.idController == 0 ||
                            widget.idController == global.userId)
                        ? Container(
                            transform:
                                Matrix4.translationValues(0.0, -12.0, 0.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.instance
                                        .text('photocover'),
                                    style: new TextStyle(
                                      fontFamily: 'SFProDisplayMedium',
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.instance
                                        .text('photocover2'),
                                    style: new TextStyle(
                                      fontFamily: 'SFProDisplayMedium',
                                      fontSize: 16,
                                    ),
                                  )
                                ]))
                        : Container()),
          ),
          Container(
            transform: Matrix4.translationValues(0.0, -39.0, 0.0),
            child: Padding(
              padding: EdgeInsets.only(
                top: 0.0,
              ),
              child: new Align(
                alignment: Alignment.center,
                child: Container(
                  height: kToolbarHeight * 3.05,
                  width: kToolbarHeight * 3.05,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(200.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: user.data.user.avatar,
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200.0),
                      color: Theme.of(context).canvasColor,
                      border: Border.all(
                        color: Colors.white,
                        width: 5,
                      )),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 0.0,
          ),
          Container(
            transform: Matrix4.translationValues(0.0, -32.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 0),
                  transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                  child: new Text(
                    user.data.user.name,
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      fontFamily: 'SFProDisplayBold',
                      fontSize: 24.5,
                    ),
                  ),
                ),
                SizedBox(
                  width: 0,
                ),
                user.data.user.badge == 'true'
                    ? Container(
                        transform: Matrix4.translationValues(8.0, 0.0, 0.0),
                        padding: EdgeInsets.only(top: 3),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.transparent),
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: SvgPicture.network(
                              "https://teling.app/wp-content/uploads/2020/09/check.svg",
                              width: 18,
                              height: 18),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          new Column(
            children: <Widget>[
              (user.data.user.bio == null)
                  ? Container(
                      width: 15,
                    )
                  : Container(
                      transform: Matrix4.translationValues(0.0, -31.5, 0.0),
                      margin:
                          EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Theme.of(context).cardColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 18.0, right: 18, bottom: 18, top: 16),
                        child: new Text(
                          user.data.user.bio,
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontFamily: 'SFProDisplaySemiBold',
                            fontSize: 14.5,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          user.data.user.badge == 'true'
              ? new Column(children: <Widget>[
                  (user.data.user.link == null)
                      ? Container(height: 5)
                      : GestureDetector(
                          onTap: () async {
                            try {
                              await launch('https://' + user.data.user.link);
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Container(
                            transform:
                                Matrix4.translationValues(0.0, -33.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LineIcons.globe,
                                  size: 20,
                                  color: Color.fromRGBO(156, 156, 156, 1),
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    try {
                                      await launch(
                                          'https://' + user.data.user.link);
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: user.data.user.badge == 'true'
                                      ? new Column(
                                          children: <Widget>[
                                            (user.data.user.link == null)
                                                ? Container()
                                                : Container(
                                                    margin: EdgeInsets.only(
                                                        left: 0.0,
                                                        right: 8.0,
                                                        top: 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      color: Colors.transparent,
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 2.0,
                                                          right: 0,
                                                          bottom: 15,
                                                          top: 4),
                                                      child: new Text(
                                                        user.data.user.link,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: new TextStyle(
                                                          fontFamily:
                                                              'SFProDisplaySemiBold',
                                                          fontSize: 14.2,
                                                          color: Color.fromRGBO(
                                                              156, 156, 156, 1),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        )
                                      : Container(),
                                ),
                              ],
                            ),
                          ),
                        )
                ])
              : Container(),
          new Column(
            children: <Widget>[
              new Container(
                transform: Matrix4.translationValues(0.0, -18.0, 0.0),
                width: screenSize.width,
                margin: EdgeInsets.only(top: 0.0),
                child: new Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            //                   <--- left side
                            color: Color.fromRGBO(224, 224, 224, 1),
                            width: 1.0,
                          ),
                        ),
                      ),
                      width: screenSize.width / 3,
                      child: new Column(
                        children: <Widget>[
                          new Text(
                            user.data.user.follower.toString(),
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              fontFamily: 'SFProDisplaySemiBold',
                              fontSize: 17.0,
                            ),
                          ),
                          new Text(
                            AppLocalizations.instance.text('followers'),
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontFamily: 'SFProDisplayRegular',
                                fontSize: 13.0,
                                color: Color.fromRGBO(152, 152, 152, 1)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: screenSize.width / 3,
                      child: new Column(
                        children: <Widget>[
                          new Text(
                            user.data.user.following.toString(),
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              fontFamily: 'SFProDisplaySemiBold',
                              fontSize: 17.0,
                            ),
                          ),
                          new Text(
                            AppLocalizations.instance.text('following'),
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontFamily: 'SFProDisplayRegular',
                                fontSize: 13.0,
                                color: Color.fromRGBO(152, 152, 152, 1)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            //                   <--- left side
                            color: Color.fromRGBO(224, 224, 224, 1),
                            width: 1.0,
                          ),
                        ),
                      ),
                      width: screenSize.width / 3,
                      child: new Column(
                        children: <Widget>[
                          new Text(
                            user.data.user.photocount.toString(),
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              fontFamily: 'SFProDisplaySemiBold',
                              fontSize: 17.0,
                            ),
                          ),
                          new Text(
                            AppLocalizations.instance.text('post'),
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontFamily: 'SFProDisplayRegular',
                                fontSize: 13.0,
                                color: Color.fromRGBO(152, 152, 152, 1)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 0,
              ),
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              (userowner == 0 || userowner == global.userId)
                  ? Container()
                  : Container(
                      transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                      margin: const EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ButtonTheme(
                            height: kToolbarHeight / 1.4,
                            minWidth: MediaQuery.of(context).size.width / 2.3,
                            child: FlatButton(
                              color: (user.data.user.follow == "true")
                                  ? _colorforUnfollow
                                  : _colorforFollow,
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(7.5)),
                              child: (user.data.user.follow == "true")
                                  ? Text(
                                      AppLocalizations.instance
                                          .text('unfollow'),
                                      style: new TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.white,
                                          fontFamily: 'SFProDisplayRegular'),
                                    )
                                  : Text(
                                      AppLocalizations.instance.text('follow'),
                                      style: new TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.white,
                                          fontFamily: 'SFProDisplayRegular'),
                                    ),
                              onPressed: () {
                                setState(() {
                                  counterbus = 0;
                                });
                                (user.data.user.follow == "true")
                                    ? check().then(
                                        (internet) async {
                                          if (internet == false) {
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: new Text(
                                                    'Are you sure?',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'SFProDisplayBold',
                                                      fontSize: 23.5,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  content: new Text(
                                                      "You won't be following this person anymore!"),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                  actions: <Widget>[
                                                    new FlatButton(
                                                      child: new Text("No"),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    new FlatButton(
                                                      child: new Text("Yes"),
                                                      onPressed: () async {
                                                        await bloc.unfollowuser(
                                                            userowner);
                                                        widget.notifyParent();
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                      )
                                    : check().then(
                                        (internet) async {
                                          if (internet == false) {
                                          } else {
                                            bloc.followuser(userowner);
                                          }
                                        },
                                      );
                                widget.notifyParent();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          ButtonTheme(
                            height: kToolbarHeight / 1.4,
                            minWidth: MediaQuery.of(context).size.width / 2.3,
                            child: FlatButton(
                              color: Color.fromRGBO(0, 141, 252, 1),
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(7.5)),
                              child: new Text(
                                AppLocalizations.instance.text('message'),
                                style: new TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontFamily: 'SFProDisplayRegular'),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ConversationSendForm(userowner),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
          SizedBox(
            height: 7.0,
          ),
          const Divider(
            color: Color.fromRGBO(224, 224, 224, 1),
            height: 1,
            thickness: 0,
            indent: 20,
            endIndent: 20,
          ),
          SizedBox(
            height: 9.0,
          ),
        ],
      ),
    );
  }
}
