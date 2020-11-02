import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:image_cropper/image_cropper.dart';
import 'package:Storyteller/app_localizations.dart';
import 'package:Storyteller/src/constant/httpService.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:Storyteller/src/constant/utils.dart';
import 'package:video_player/video_player.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import '../blocs/photos_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:line_icons/line_icons.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';

class PhotoForm extends StatefulWidget {
  @override
  StoryTellerAddPhoto createState() => new StoryTellerAddPhoto();
}

class StoryTellerAddPhoto extends State<PhotoForm> {
  final baseUrl = "${NetworkUtils.urlBase}${NetworkUtils.serverApi}";

  File _media;
  bool isVideo = false;
  bool isLoading = false;
  VideoPlayerController _controller;
  CameraController _controlleri;

  TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  bool up = false;
  List<String> main = List();

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
    check().then(
      (internet) {
        if (internet == false) {
        } else {
          bloc.photoFetcherStatus.listen((onData) {});
        }
      },
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    _controlleri.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey3,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.6,
            backgroundColor: Colors.white,
            centerTitle: false,
            title: Text(
              ' Post',
              style: TextStyle(
                fontFamily: 'SFProDisplayBold',
                fontSize: 33.0,
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(bottom: 13.0, top: 13.0),
                    child: ButtonTheme(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      height: kToolbarHeight / 1.10,
                      minWidth: 60,
                      child: FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          color: _media == null ? Colors.black12 : Colors.blue,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(6.0)),
                          child: isLoading == false
                              ? new Text(
                                  AppLocalizations.instance.text('publish'),
                                  style: new TextStyle(
                                      color: _media == null ? Colors.white : Colors.white,
                                      fontSize: 15.0,
                                      fontFamily: 'SFProDisplayMedium'),
                                )
                              : Center(
                                child:
                                Container(
                                  width: 10, 
                                  height: 10, 
                                  child:
                                CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                                ),
                              ),
                          onPressed: () {
                            check().then((internet) async {
                              if (internet == false) {
                              } else {
                                if (_formKey3.currentState.validate() == true) {
                                  if (_media == null) return;
                                  setState(() {
                                    isLoading = true;
                                  });
                                }
                              }
                            });
                            if (_media != null) {
                              sendUploadFile(descriptionController.text);
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  elevation: 0,
                                  backgroundColor: Colors.black,
                                  content: Text(
                                    "Your post will be visible in a couple of seconds.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "SFProDisplayBold",
                                      fontSize: 13,
                                    ),
                                  ),
                                  duration: Duration(seconds: 10),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          }),
                    ),
                  ),
                ),
              )
            ]),
        body: Padding(
          padding: EdgeInsets.only(top: 0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 0.0,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 0, right: 0),
                      width: screenSize.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        color: Colors.transparent,
                      ),
                      child: _media == null
                          ? Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 150),
                                          child: Center(
                                            child: Container(
                                              height: kToolbarHeight * 1.80,
                                              width: kToolbarHeight * 1.80,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0),
                                                ),
                                                color: Theme.of(context)
                                                    .canvasColor,
                                              ),
                                              child: new Material(
                                                color: Theme.of(context).cardColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0),
                                                ),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(50.0),
                                                  ),
                                                  onTap: () async {
                                                    PickedFile pickedFile =
                                                        await ImagePicker()
                                                            .getImage(
                                                      source:
                                                          ImageSource.camera,
                                                      maxWidth: 1800,
                                                      maxHeight: 1800,
                                                    );
                                                    _cropImage(pickedFile.path);
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Feather.camera,
                                                      size:
                                                          kToolbarHeight * 0.65,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 25),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 150),
                                          child: Center(
                                            child: Container(
                                              height: kToolbarHeight * 1.80,
                                              width: kToolbarHeight * 1.80,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0),
                                                ),
                                                color: Theme.of(context)
                                                    .canvasColor,
                                              ),
                                              child: new Material(
                                                color: Theme.of(context).cardColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0),
                                                ),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(50.0),
                                                  ),
                                                  onTap: () async {
                                                    isVideo = true;
                                                    Future<File> video2 =
                                                        ImagePicker.pickVideo(
                                                            source: ImageSource
                                                                .camera);

                                                    video2.then((file) async {
                                                      setState(() {
                                                        _media = file;
                                                        _controller =
                                                            VideoPlayerController
                                                                .file(_media)
                                                              ..initialize()
                                                                  .then(
                                                                (_) {
                                                                  setState(
                                                                      () {});
                                                                  _controller
                                                                      .setLooping(
                                                                          true);
                                                                },
                                                              );
                                                      });
                                                    });
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Feather.video,
                                                      color: Colors.black,
                                                      size:
                                                          kToolbarHeight * 0.65,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 30),
                                          child: Center(
                                            child: Container(
                                              height: kToolbarHeight * 1.80,
                                              width: kToolbarHeight * 1.80,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0),
                                                ),
                                                color: Theme.of(context)
                                                    .canvasColor,
                                              ),
                                              child: new Material(
                                                color:
                                                    Theme.of(context).cardColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0),
                                                ),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(50.0),
                                                  ),
                                                  onTap: () async {
                                                    PickedFile pickedFile =
                                                        await ImagePicker()
                                                            .getImage(
                                                      source:
                                                          ImageSource.gallery,
                                                      maxWidth: 1800,
                                                      maxHeight: 1800,
                                                    );
                                                    _cropImage(pickedFile.path);
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Feather.image,
                                                      size:
                                                          kToolbarHeight * 0.65,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 25),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 30),
                                          child: Center(
                                            child: Container(
                                              height: kToolbarHeight * 1.80,
                                              width: kToolbarHeight * 1.80,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0),
                                                ),
                                                color: Theme.of(context)
                                                    .canvasColor,
                                              ),
                                              child: new Material(
                                                color:
                                                    Theme.of(context).cardColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0),
                                                ),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(50.0),
                                                  ),
                                                  onTap: () async {
                                                    isVideo = true;
                                                    Future<File> video1 =
                                                        ImagePicker.pickVideo(
                                                            source: ImageSource
                                                                .gallery);

                                                    video1.then((file) async {
                                                      setState(() {
                                                        _media = file;
                                                        _controller =
                                                            VideoPlayerController
                                                                .file(_media)
                                                              ..initialize()
                                                                  .then(
                                                                (_) {
                                                                  setState(
                                                                      () {});
                                                                  _controller
                                                                      .setLooping(
                                                                          true);
                                                                  _controller
                                                                      .play();
                                                                  _controller
                                                                      .setVolume(
                                                                          0);
                                                                },
                                                              );
                                                      });
                                                    });
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Feather.upload,
                                                      size:
                                                          kToolbarHeight * 0.65,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ])
                                      
                                ]))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: isVideo == false
                                  ? Image.file(
                                      _media,
                                      fit: BoxFit.cover,
                                    )
                                  : _controller.value.initialized
                                      ? AspectRatio(
                                          aspectRatio:
                                              _controller.value.aspectRatio,
                                          child: VideoPlayer(_controller),
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(),
                                        ),
                            ),
                    ),
                    isVideo == true
                        ? GestureDetector(
                            child: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outline,
                              size: 50,
                              color: Colors.white,
                            ),
                            onTap: () {
                              setState(() {
                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                } else {
                                  _controller.play();
                                  _controller.setVolume(1);
                                }
                              });
                            },
                          )
                        : Container(),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                _media == null
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextFormField(
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(200),
                          ],
                          controller: descriptionController,
                          keyboardType: TextInputType.text,
                          minLines: 3,
                          maxLines: null,
                          autofocus: false,
                          validator: Validators.compose([
                            Validators.required('Description is required'),
                            Validators.minLength(1,
                                'Description cannot be less than 10 characters'),
                            Validators.maxLength(200,
                                'Description cannot be greater than 200 characters'),
                          ]),
                          decoration: InputDecoration(
                            hintText:
                                AppLocalizations.instance.text('writehere'),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            contentPadding:
                                EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void savedShow() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Icon(LineIcons.check_circle_o, size: 90),
          content: new Text(
            "Your Post is posted!",
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void checkMediaType() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            AppLocalizations.instance.text('fromwhere'),
            style: TextStyle(
              fontFamily: 'SFProDisplayBold',
              fontSize: 23.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: new Text(
            AppLocalizations.instance.text('selectfile'),
            textAlign: TextAlign.left,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.pop(context);
                isVideo = false;
                _getImage();
              },
              child: new Text(
                AppLocalizations.instance.text('image'),
              ),
            ),
            new FlatButton(
              onPressed: () {
                Navigator.pop(context);
                isVideo = true;
                _getVideo();
              },
              child: new Text(
                AppLocalizations.instance.text('video'),
              ),
            )
          ],
        );
      },
    );
  }

  Future _getImage() async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              AppLocalizations.instance.text('image'),
              style: TextStyle(
                fontFamily: 'SFProDisplayBold',
                fontSize: 23.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: new Text(
              AppLocalizations.instance.text('camerachoose'),
              style: TextStyle(
                fontFamily: 'SFProDisplayRegular',
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            actions: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new FlatButton(
                      child: new Text(
                        AppLocalizations.instance.text('gallery'),
                        style: TextStyle(
                          fontFamily: 'SFProDisplayMedium',
                          color: Color.fromRGBO(0, 141, 252, 1),
                        ),
                      ),
                      onPressed: () async {
                        PickedFile pickedFile = await ImagePicker().getImage(
                          source: ImageSource.gallery,
                          maxWidth: 1800,
                          maxHeight: 1800,
                        );
                        _cropImage(pickedFile.path);
                      },
                    ),
                    new FlatButton(
                      child: new Text(
                        AppLocalizations.instance.text('camera'),
                        style: TextStyle(
                          fontFamily: 'SFProDisplayMedium',
                          color: Color.fromRGBO(0, 141, 252, 1),
                        ),
                      ),
                      onPressed: () async {
                        PickedFile pickedFile = await ImagePicker().getImage(
                          source: ImageSource.camera,
                          maxWidth: 1800,
                          maxHeight: 1800,
                        );
                        _cropImage(pickedFile.path);
                      },
                    ),
                    new FlatButton(
                      child: new Text(
                        AppLocalizations.instance.text('cancel'),
                        style: TextStyle(
                          fontFamily: 'SFProDisplayMedium',
                          color: Color.fromRGBO(0, 141, 252, 1),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ]),
            ],
          );
        },
      );
    } catch (error) {}
  }

  Future _getVideo() async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              AppLocalizations.instance.text('video'),
              style: TextStyle(
                fontFamily: 'SFProDisplayBold',
                fontSize: 23.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: new Text(
              "Now open the gallery, choose your video and upload it to teling.",
              style: TextStyle(
                fontFamily: 'SFProDisplayRegular',
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            actions: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new FlatButton(
                      child: new Text(
                        AppLocalizations.instance.text('gallery'),
                        style: TextStyle(
                          fontFamily: 'SFProDisplayMedium',
                          color: Color.fromRGBO(0, 141, 252, 1),
                        ),
                      ),
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
                                  _controller.setLooping(true);
                                  _controller.play();
                                  _controller.setVolume(0);
                                },
                              );
                          });
                          Navigator.pop(context);
                        });
                      },
                    ),
                    FlatButton(
                      child: new Text(
                        "Camera",
                        style: TextStyle(
                          fontFamily: 'SFProDisplayMedium',
                          color: Color.fromRGBO(0, 141, 252, 1),
                        ),
                      ),
                      onPressed: () async {
                        Future<File> video2 =
                            ImagePicker.pickVideo(source: ImageSource.camera);

                        video2.then((file) async {
                          setState(() {
                            _media = file;
                            _controller = VideoPlayerController.file(_media)
                              ..initialize().then(
                                (_) {
                                  setState(() {});
                                  _controller.setLooping(true);
                                },
                              );
                          });
                          Navigator.pop(context);
                        });
                      },
                    ),
                    new FlatButton(
                      child: new Text(
                        AppLocalizations.instance.text('cancel'),
                        style: TextStyle(
                          fontFamily: 'SFProDisplayMedium',
                          color: Color.fromRGBO(0, 141, 252, 1),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ]),
            ],
          );
        },
      );
    } catch (error) {}
  }

  _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: filePath,
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                //CropAspectRatioPreset.ratio3x2,
                //CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                // CropAspectRatioPreset.ratio16x9
              ]
            : [
                // CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                // CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                // CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,

                //CropAspectRatioPreset.ratio7x5,
                // CropAspectRatioPreset.ratio16x9
              ],
        iosUiSettings: IOSUiSettings(
          //title: 'Crop Image',
          cancelButtonTitle: 'Cancel',
          doneButtonTitle: 'Done',
          rectX: 1,
          rectY: 1,
          rectWidth: 19080,
          rectHeight: 19080,
          hidesNavigationBar: true,
          resetButtonHidden: true,
          minimumAspectRatio: 1.0,
          // rotateClockwiseButtonHidden: true,
        ));
    if (croppedImage != null) {
      _media = croppedImage;
      setState(() {});
    }
  }

  Future<String> fetchToken() async {
    var client = await HttpService().getClient();
    return client.credentials.accessToken.toString();
  }

  void sendUploadFile(String description) async {
    final String url = "${NetworkUtils.urlBase}${NetworkUtils.serverApi}posts";

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
        'image', stream_video, length_video,
        filename: path.basename(_media.path));

    request.files.add(multipartFile);
    request.fields['id'] = "1";
    request.fields['user_id'] = "1";
    request.fields['likes'] = "1";
    request.fields['description'] = description;

    request.headers.addAll(headers);
    var response = await request.send();
    print(response.statusCode);
    setState(() {
      isLoading = false;
    });

    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }
}
