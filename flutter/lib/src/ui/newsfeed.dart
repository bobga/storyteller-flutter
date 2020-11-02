import 'package:Storyteller/app_localizations.dart';
import 'package:Storyteller/src/ui/stories.dart';
import 'package:Storyteller/src/ui/video.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:Storyteller/src/models/image_model.dart';
import 'package:Storyteller/src/models/user_model.dart';
import 'package:Storyteller/src/ui/profile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'conversation_list.dart';
import 'package:line_icons/line_icons.dart';
import '../blocs/photos_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:Storyteller/src/constant/utils.dart';
import 'package:mime/mime.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'globals.dart' as global;
import 'package:flutter_icons/flutter_icons.dart' as ico;
import 'dart:math' as math;
import 'package:Storyteller/src/ui/comments.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:page_transition/page_transition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:async/async.dart';
import 'package:Storyteller/src/constant/httpService.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class PhotoFeed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewsFeedState();
  }
}

class NewsFeedState extends State<PhotoFeed> {
  File _media;
  bool isVideo = false;

  VideoPlayerController _controller;
  Duration _duration;
  StreamSubscription connectivitySubscription;
  Timer _timer, timer;
  final FlareControls flareControls = FlareControls();
  bool isLiked = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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
          bloc.fetchAllPhoto();
          bloc.photoFetcherStatus.listen((onData) {
            bloc.fetchAllPhoto();
          });
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
              bloc.fetchStoryList();
              bloc.dispose();
            }
          },
        );
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

  void _onRefresh() async {
    // monitor network fetch
    await bloc.fetchAllPhoto();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  refresh() {}

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
            style: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Container(
            padding: EdgeInsets.only(top: 40.0),
            child: Icon(
              Icons.check_circle,
              size: 66,
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

  void likeShow() {
    showDialog(
        barrierColor: Colors.black.withOpacity(0.30),
        barrierDismissible: false,
        context: context,
        builder: (BuildContext builderContext) {
          _timer = Timer(Duration(milliseconds: 400), () {
            Navigator.of(context).pop();
          });

          return Container(
              height: 190,
              width: 190,
              color: Colors.transparent,
              child: AlertDialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(900.0),
                ),
                title: Container(
                  height: 190,
                  width: 190,
                  // padding: EdgeInsets.only(top: 40.0, bottom: 40),
                  child: HeartbeatProgressIndicator(
                    child: Icon(
                      Icons.favorite,
                      size: 80,
                      color: Color.fromRGBO(255, 255, 255, 0.85),
                    ),
                  ),
                ),
              ));
        }).then((val) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }

  void sendUploadFile() async {
    final String url =
        "${NetworkUtils.urlBase}${NetworkUtils.serverApi}stories";

    var request = new http.MultipartRequest("POST", Uri.parse(url));
    print(url);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + await fetchToken(),
    };

    var stream_video =
        new http.ByteStream(DelegatingStream.typed(_media.openRead()));
    var length_video = await _media.length();

    print(path.basename(_media.path));
    print(length_video);

    var multipartFile = new http.MultipartFile(
        'media', stream_video, length_video,
        filename: path.basename(_media.path));

    request.files.add(multipartFile);
    if (isVideo == true) {
      request.fields['duration'] = _duration.toString();
      request.fields['type'] = 'video';
    } else {
      request.fields['duration'] = '5';
      request.fields['type'] = 'image';
    }

    request.headers.addAll(headers);
    var response = await request.send();
    print(response.statusCode);

    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  Future<String> fetchToken() async {
    var client = await HttpService().getClient();
    return client.credentials.accessToken.toString();
  }

  checkFileType(String url) {
    String mimeStr = lookupMimeType(url);
    var fileType = mimeStr.split('/');
    print(fileType[0]);
    return fileType[0];
  }

  _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedImage != null) {
      _media = croppedImage;
      Navigator.pop(context);
      setState(() {});
      sendUploadFile();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          margin: EdgeInsets.only(bottom: 38, left: 30, right: 30),
          elevation: 0,
          backgroundColor: Colors.black,
          content: Text(
            "Your story will appear shortly",
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void checkMediaType() {
    final screenSize = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Column(children: <Widget>[
              Image.network(
                'https://images.emojiterra.com/mozilla/512px/1f389.png',
                width: 80,
                height: 80,
              ),
              SizedBox(height: 15),
              Text(
                'Upload Story',
                style: TextStyle(
                  fontFamily: 'SFProDisplayBold',
                  fontSize: 20.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
          ),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Select the file type to upload, then you \ncan choose from the gallery or camera.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontFamily: 'SFProDisplayMedium',
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 30),
                const Divider(
                  color: Color.fromRGBO(224, 224, 224, 1),
                  height: 1,
                  thickness: 0,
                  indent: 0,
                  endIndent: 0,
                ),
                ButtonTheme(
                  minWidth: screenSize.width,
                  height: 45.0,
                  child: FlatButton(
                    //splashColor: Colors.transparent,
                    //highlightColor: Colors.transparent,
                    child: Text(
                      AppLocalizations.instance.text('image'),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.3,
                          fontFamily: 'SFProDisplayMedium'),
                    ),
                    color: Colors.transparent,
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(0.0),
                            topLeft: Radius.circular(0.0))),
                    onPressed: () {
                      Navigator.pop(context);
                      isVideo = false;
                      _getImage();
                    },
                  ),
                ),
                const Divider(
                  color: Color.fromRGBO(224, 224, 224, 1),
                  height: 1,
                  thickness: 0,
                  indent: 0,
                  endIndent: 0,
                ),
                ButtonTheme(
                  minWidth: screenSize.width,
                  height: 45.0,
                  child: FlatButton(
                    //splashColor: Colors.transparent,
                    //highlightColor: Colors.transparent,
                    child: Text(
                      AppLocalizations.instance.text('video'),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.3,
                          fontFamily: 'SFProDisplayMedium'),
                    ),
                    color: Colors.transparent,
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(0.0),
                            topLeft: Radius.circular(0.0))),
                    onPressed: () {
                      Navigator.pop(context);
                      isVideo = true;
                      _getVideo();
                    },
                  ),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        );
      },
    );
  }

  Future _getImage() async {
    final screenSize = MediaQuery.of(context).size;
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                'Image Story',
                style: TextStyle(
                  fontFamily: 'SFProDisplayBold',
                  fontSize: 20.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'You can upload a photo or take a new one.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.5,
                      fontFamily: 'SFProDisplayMedium',
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 30),
                  const Divider(
                    color: Color.fromRGBO(224, 224, 224, 1),
                    height: 1,
                    thickness: 0,
                    indent: 0,
                    endIndent: 0,
                  ),
                  ButtonTheme(
                    minWidth: screenSize.width - 45.8,
                    height: 45.0,
                    child: FlatButton(
                      //splashColor: Colors.transparent,
                      //highlightColor: Colors.transparent,
                      child: Text(
                        AppLocalizations.instance.text('gallery'),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.3,
                            fontFamily: 'SFProDisplayMedium'),
                      ),
                      color: Colors.transparent,
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0))),
                      onPressed: () async {
                        PickedFile pickedFile = await ImagePicker().getImage(
                          source: ImageSource.gallery,
                          maxWidth: 1800,
                          maxHeight: 1800,
                        );

                        _cropImage(pickedFile.path);
                      },
                    ),
                  ),
                  const Divider(
                    color: Color.fromRGBO(224, 224, 224, 1),
                    height: 1,
                    thickness: 0,
                    indent: 0,
                    endIndent: 0,
                  ),
                  ButtonTheme(
                    minWidth: screenSize.width - 45.8,
                    height: 45.0,
                    child: FlatButton(
                      //splashColor: Colors.transparent,
                      //highlightColor: Colors.transparent,
                      child: Text(
                        AppLocalizations.instance.text('camera'),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.3,
                            fontFamily: 'SFProDisplayMedium'),
                      ),
                      color: Colors.transparent,
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0))),
                      onPressed: () async {
                        PickedFile pickedFile = await ImagePicker().getImage(
                          source: ImageSource.camera,
                          maxWidth: 1800,
                          maxHeight: 1800,
                        );
                        _cropImage(pickedFile.path);
                      },
                    ),
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          );
        },
      );
    } catch (error) {}
  }

  Future _getVideo() async {
    final screenSize = MediaQuery.of(context).size;
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                'Video Story',
                style: TextStyle(
                  fontFamily: 'SFProDisplayBold',
                  fontSize: 20.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'You can upload a video or take a new one.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.5,
                      fontFamily: 'SFProDisplayMedium',
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 30),
                  const Divider(
                    color: Color.fromRGBO(224, 224, 224, 1),
                    height: 1,
                    thickness: 0,
                    indent: 0,
                    endIndent: 0,
                  ),
                  ButtonTheme(
                    minWidth: screenSize.width - 45.8,
                    height: 45.0,
                    child: FlatButton(
                      //splashColor: Colors.transparent,
                      //highlightColor: Colors.transparent,
                      child: Text(
                        AppLocalizations.instance.text('gallery'),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.3,
                            fontFamily: 'SFProDisplayMedium'),
                      ),
                      color: Colors.transparent,
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0))),
                      onPressed: () async {
                        Future<File> video1 =
                            ImagePicker.pickVideo(source: ImageSource.gallery);

                        video1.then((file) async {
                          setState(() {
                            _media = file;
                            _controller = VideoPlayerController.file(_media)
                              ..initialize().then(
                                (_) {
                                  setState(() {});
                                  _duration = _controller.value.duration;
                                  sendUploadFile();
                                },
                              );
                          });
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ),
                  const Divider(
                    color: Color.fromRGBO(224, 224, 224, 1),
                    height: 1,
                    thickness: 0,
                    indent: 0,
                    endIndent: 0,
                  ),
                  ButtonTheme(
                    minWidth: screenSize.width - 45.8,
                    height: 45.0,
                    child: FlatButton(
                      //splashColor: Colors.transparent,
                      //highlightColor: Colors.transparent,
                      child: Text(
                        AppLocalizations.instance.text('camera'),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.3,
                            fontFamily: 'SFProDisplayMedium'),
                      ),
                      color: Colors.transparent,
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0))),
                      onPressed: () async {
                        Future<File> video2 = ImagePicker.pickVideo(
                            source: ImageSource.camera,
                            maxDuration: Duration(seconds: 30));

                        video2.then((file) async {
                          setState(() {
                            _media = file;
                            _controller = VideoPlayerController.file(_media)
                              ..initialize().then(
                                (_) {
                                  setState(() {});
                                  _duration = _controller.value.duration;
                                  sendUploadFile();
                                },
                              );
                          });
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          );
        },
      );
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            actions: [
              Container(
                  child: Row(children: <Widget>[
                GestureDetector(
                  onTap: () {
                    checkMediaType();
                  },
                  child: Icon(Feather.plus_circle, size: 29),
                ),
                SizedBox(width: 18),
                IconButton(
                  icon: Icon(Feather.message_circle, size: 30),
                  padding: EdgeInsets.only(right: 20.0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConversationListForm(0),
                      ),
                    );
                  },
                )
              ])),
            ],
            title: Text(
              'teling',
              style: TextStyle(
                fontFamily: "SFProDisplayBold",
                fontSize: 37.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            elevation: 0.0,
          ),
          body: Scaffold(
            body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 70,
                      elevation: 0.6,
                      centerTitle: false,
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      bottom: PreferredSize(
                        preferredSize: Size(0.0, 48.0),
                        child: Column(children: [
                          Container(
                            padding: const EdgeInsets.only(
                              top: 0.0,
                              bottom: 6.0,
                              left: 10,
                              right: 10,
                            ),
                            child: SizedBox(
                              height: 90.0,
                              child: StreamBuilder(
                                stream: bloc.allStories,
                                builder: (
                                  context,
                                  AsyncSnapshot<UserModel> snapshot,
                                ) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data.datas.length == 0) {
                                      return Center(
                                        child: Text("No Stories"),
                                      );
                                    } else {
                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data.datas.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return (isBlock(snapshot.data
                                                          .datas[index].id) ==
                                                      true) ||
                                                  (isBlocked(snapshot
                                                          .data
                                                          .datas[index]
                                                          .block) ==
                                                      true)
                                              ? Container()
                                              : Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10.0,
                                                              left: 8.0),
                                                      child: Column(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .circular(
                                                                    100.0),
                                                            child:
                                                                GestureDetector(
                                                              child:
                                                                  CachedNetworkImage(
                                                                height:
                                                                    kToolbarHeight /
                                                                        0.83,
                                                                width:
                                                                    kToolbarHeight /
                                                                        0.83,
                                                                fit: BoxFit
                                                                    .cover,
                                                                placeholder:
                                                                    (c, d) {
                                                                  return Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      strokeWidth:
                                                                          2.0,
                                                                    ),
                                                                  );
                                                                },
                                                                imageUrl: snapshot
                                                                    .data
                                                                    .datas[
                                                                        index]
                                                                    .avatar,
                                                              ),
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    PageTransition(
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              1),
                                                                      type: PageTransitionType
                                                                          .fade,
                                                                      child:
                                                                          Stories(
                                                                        snapshot
                                                                            .data
                                                                            .datas[index]
                                                                            .id,
                                                                        snapshot
                                                                            .data
                                                                            .datas[index]
                                                                            .name,
                                                                        snapshot
                                                                            .data
                                                                            .datas[index]
                                                                            .avatar,
                                                                        snapshot
                                                                            .data
                                                                            .datas[index]
                                                                            .badge,
                                                                      ),
                                                                    ));
                                                              },
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 4.0),
                                                            child: SizedBox(
                                                              child: Text(
                                                                snapshot
                                                                    .data
                                                                    .datas[
                                                                        index]
                                                                    .name,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "SFProDisplayMedium",
                                                                    fontSize:
                                                                        13),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                        },
                                      );
                                    }
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text(snapshot.error.toString()),
                                    );
                                  }

                                  return Center(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 10),
                                          LinearProgressIndicator(
                                            backgroundColor: Color.fromRGBO(
                                                255, 255, 255, 0.85),
                                            minHeight: 2,
                                          ),
                                        ]),
                                  );
                                },
                              ),
                            ),
                          ),
                          Divider(
                            color: Color.fromRGBO(207, 207, 207, 0.60),
                            height: 1,
                            thickness: 0,
                            indent: 0,
                            endIndent: 0,
                          ),
                        ]),
                      ),
                      floating: false,
                      pinned: false,
                    ),
                  ];
                },
                body: buildList()),
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

  swipeDownRefresh() {}

  Widget buildList() {
    final screenSize = MediaQuery.of(context).size;
    String mlangCode = AppLocalizations.instance.mlangCode;
    print("mlangCode = $mlangCode");

    return StreamBuilder(
      stream: bloc.allPhotos,
      builder: (context, AsyncSnapshot<ImageModel> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.datas.length == 0) {
            return Center(
              child: Text("No Posts"),
            );
          } else {
            return SmartRefresher(
              enablePullDown: true,
              header: ClassicHeader(),
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return (isBlock(snapshot.data.data[index].user.data.id) ==
                              true) ||
                          (isBlocked(
                                  snapshot.data.data[index].user.data.block) ==
                              true)
                      ? Container()
                      : Column(
                          children: <Widget>[
                            new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  new GestureDetector(
                                    onTap: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              StorytellerProfile(
                                                  snapshot.data.data[index].user
                                                      .data.id,
                                                  false,
                                                  refresh),
                                        ),
                                      ),
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                          bottom: 10.0,
                                          top: 15.0),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                new BorderRadius.circular(30.0),
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
                                              imageUrl: snapshot.data
                                                  .data[index].user.data.avatar,
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
                                                  Row(children: [
                                                    new Text(
                                                      snapshot.data.data[index]
                                                          .user.data.name,
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
                                                            padding:
                                                                EdgeInsets.only(
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
                                                                      width: 14,
                                                                      height:
                                                                          14),
                                                            ),
                                                          )
                                                        : Container(),
                                                  ]),
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
                                                        locale: AppLocalizations
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
                                  ),
                                  MaterialButton(
                                    height: 20.0,
                                    minWidth: 65.0,
                                    child: const Icon(LineIcons.ellipsis_h),
                                    onPressed: () {
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
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                              width: screenSize
                                                                      .width -
                                                                  45,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    ButtonTheme(
                                                                      minWidth:
                                                                          screenSize.width -
                                                                              45.8,
                                                                      height:
                                                                          56.0,
                                                                      child:
                                                                          FlatButton(
                                                                        // splashColor: Colors.transparent,
                                                                        // highlightColor: Colors.transparent,
                                                                        child:
                                                                            Text(
                                                                          AppLocalizations
                                                                              .instance
                                                                              .text('reportpost'),
                                                                          style: TextStyle(
                                                                              color: Colors.red,
                                                                              fontSize: 16.3,
                                                                              fontFamily: 'SFProDisplayMedium'),
                                                                        ),
                                                                        color: Colors
                                                                            .transparent,
                                                                        shape: new RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0))),
                                                                        onPressed:
                                                                            () {
                                                                          print(snapshot
                                                                              .data
                                                                              .data[index]
                                                                              .id);
                                                                          bloc.reportpost(snapshot
                                                                              .data
                                                                              .data[index]
                                                                              .id);
                                                                          Navigator.pop(
                                                                              context);
                                                                          savedShow();
                                                                        },
                                                                      ),
                                                                    ),
                                                                    const Divider(
                                                                      color: Color.fromRGBO(
                                                                          224,
                                                                          224,
                                                                          224,
                                                                          1),
                                                                      height: 1,
                                                                      thickness:
                                                                          0,
                                                                      indent: 0,
                                                                      endIndent:
                                                                          0,
                                                                    ),
                                                                    ButtonTheme(
                                                                      minWidth:
                                                                          screenSize.width -
                                                                              45.8,
                                                                      height:
                                                                          56.0,
                                                                      child:
                                                                          FlatButton(
                                                                        //splashColor: Colors.transparent,
                                                                        // highlightColor: Colors.transparent,
                                                                        child:
                                                                            Text(
                                                                          AppLocalizations
                                                                              .instance
                                                                              .text('visitprofile'),
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 16.3,
                                                                              fontFamily: 'SFProDisplayMedium'),
                                                                        ),
                                                                        color: Colors
                                                                            .transparent,
                                                                        shape: new RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                new BorderRadius.circular(0.0)),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => StorytellerProfile(snapshot.data.data[index].user.data.id, false, refresh),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                    const Divider(
                                                                      color: Color.fromRGBO(
                                                                          224,
                                                                          224,
                                                                          224,
                                                                          1),
                                                                      height: 1,
                                                                      thickness:
                                                                          0,
                                                                      indent: 0,
                                                                      endIndent:
                                                                          0,
                                                                    ),
                                                                    ButtonTheme(
                                                                      minWidth:
                                                                          screenSize.width -
                                                                              45.8,
                                                                      height:
                                                                          56.0,
                                                                      child:
                                                                          FlatButton(
                                                                        //splashColor: Colors.transparent,
                                                                        // highlightColor: Colors.transparent,
                                                                        child:
                                                                            Text(
                                                                          AppLocalizations
                                                                              .instance
                                                                              .text('share'),
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 16.3,
                                                                              fontFamily: 'SFProDisplayMedium'),
                                                                        ),
                                                                        color: Colors
                                                                            .transparent,
                                                                        shape: new RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.only(bottomRight: Radius.circular(10.0), bottomLeft: Radius.circular(10.0))),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ]))
                                                        ]),
                                                    Container(height: 10),
                                                    ButtonTheme(
                                                      minWidth:
                                                          screenSize.width -
                                                              45.8,
                                                      height: 56.0,
                                                      child: FlatButton(
                                                          child: Text(
                                                            AppLocalizations
                                                                .instance
                                                                .text('cancel'),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16.3,
                                                                fontFamily:
                                                                    'SFProDisplayMedium'),
                                                          ),
                                                          color: Colors.white,
                                                          shape: new RoundedRectangleBorder(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .circular(
                                                                      10.0)),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
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
                                  ),
                                ]),
                            GestureDetector(
                                onDoubleTap: () {
                                  (snapshot.data.data[index].like == "true")
                                      ? bloc.unlikepost(
                                          snapshot.data.data[index].id)
                                      : bloc.likepost(
                                          snapshot.data.data[index].id);
                                  Vibrate.feedback(FeedbackType.medium);
                                  likeShow();
                                },
                                child: Stack(children: <Widget>[
                                  Container(
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
                                              ? PinchZoomImage(
                                                  image: CachedNetworkImage(
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
                                                  ),
                                                  zoomedBackgroundColor:
                                                      Color.fromRGBO(
                                                          240, 240, 240, 0.50),
                                                )
                                              : Container(
                                                  width: screenSize.width,
                                                  child: VideoClip(
                                                    url: snapshot
                                                        .data.data[index].image,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ])),
                            SizedBox(
                              height: 0.0,
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
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              maxLines: 3,
                                              text: TextSpan(
                                                text: snapshot.data.data[index]
                                                        .user.data.name +
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
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: const Divider(
                                  color: Color.fromRGBO(207, 207, 207, 1),
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
                                  left: 22,
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
                                              (snapshot.data.data[index].like ==
                                                      "true")
                                                  ? bloc.unlikepost(snapshot
                                                      .data.data[index].id)
                                                  : bloc.likepost(snapshot
                                                      .data.data[index].id);
                                              flareControls.play("like");
                                            },
                                            child: (snapshot.data.data[index]
                                                        .like ==
                                                    "true")
                                                ? Icon(Icons.favorite,
                                                    color: Colors.red, size: 23)
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
                                            snapshot.data.data[index].likecount
                                                    .toString() +
                                                ' ' +
                                                AppLocalizations.instance
                                                    .text('like'),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontFamily: "SFProDisplayMedium",
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
                                                snapshot.data.data[index].id),
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
                                                    Matrix4.rotationY(math.pi),
                                                child: Icon(
                                                    ico.Feather.message_circle,
                                                    color: Colors.black45,
                                                    size: 21.7),
                                              ),
                                              SizedBox(
                                                width: 5.0,
                                              ),
                                              Center(
                                                child: Text(
                                                  snapshot.data.data[index]
                                                          .commentcount
                                                          .toString() +
                                                      ' ' +
                                                      AppLocalizations.instance
                                                          .text('comments'),
                                                  textAlign: TextAlign.start,
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
                                    GestureDetector(
                                      onTap: () {
                                        (snapshot.data.data[index].saved ==
                                                "true")
                                            ? bloc.removePost(
                                                snapshot.data.data[index].id)
                                            : bloc.savePost(
                                                snapshot.data.data[index].id);
                                      },
                                      child: Container(
                                        child: snapshot
                                                    .data.data[index].saved !=
                                                "true"
                                            ? Row(
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
                                                              .text('save') +
                                                          "   ",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            "SFProDisplayMedium",
                                                        fontSize: 14.5,
                                                        color: Colors.black45,
                                                      ),
                                                    ),
                                                  ])
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                    Icon(Icons.bookmark,
                                                        color: Colors.black,
                                                        size: 22.6),
                                                    SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Text(
                                                      'Saved',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            "SFProDisplayMedium",
                                                        fontSize: 14.5,
                                                        color: Colors.black45,
                                                      ),
                                                    ),
                                                  ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: const Divider(
                                  color: Color.fromRGBO(207, 207, 207, 1),
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
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
        );
      },
    );
  }
}

String getBannerAdUnitId() {
  if (Platform.isIOS) {
    return NetworkUtils.BannerAdUnitIdAndroid;
  } else if (Platform.isAndroid) {
    return NetworkUtils.BannerAdUnitIdIOS;
  }
  return null;
}
