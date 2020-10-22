import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:Storyteller/app_localizations.dart';
import 'package:Storyteller/src/constant/httpService.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Storyteller/src/models/image_model.dart';
import 'package:Storyteller/src/constant/utils.dart';
import 'package:video_player/video_player.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import '../blocs/photos_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:line_icons/line_icons.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey3,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
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
                          ? Container(
                            margin:
                                                        const EdgeInsets.only(
                                                            top: 200),
                              child: Center(
                                child: Container(
                                  height: kToolbarHeight * 1.80,
                                  width: kToolbarHeight * 1.80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                    color: Theme.of(context).canvasColor,
                                  ),
                                  child: new Material(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                      onTap: () => {
                                        checkMediaType(),
                                        // _getImage(),
                                      },
                                      child: Center(
                                        child: Icon(
                                          LineIcons.upload,
                                          size: kToolbarHeight * 0.65,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
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
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
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
                      Validators.minLength(
                          10, 'Description cannot be less than 10 characters'),
                      Validators.maxLength(200,
                          'Description cannot be greater than 200 characters'),
                    ]),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.instance.text('writehere'),
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
                Container(
                  margin: EdgeInsets.only(top:10, right: 15),
                  child:
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text('200', textAlign: TextAlign.right, 
                  style:TextStyle(color: Colors.black38,
                    fontFamily:"SFProDisplayBold",fontSize:13,),)
                ),
                ),


                SizedBox(
                  height: 20.0,
                ),
                ButtonTheme(
                  height: kToolbarHeight / 1.10,
                  minWidth: screenSize.width - 80,
                  
                  child: FlatButton(
                      color: Color.fromRGBO(0, 141, 252, 1),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      child: isLoading == false
                          ? new Text(
                              AppLocalizations.instance.text('publish'),
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontFamily: 'SFProDisplayBold'),
                            )
                          : CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.white),
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
                              sendUploadFile(descriptionController.text);

                              // String base64Image =
                              //     base64Encode(_media.readAsBytesSync());
                              // var image = Data.add(
                              //   1,
                              //   base64Image,
                              //   1,
                              //   1,
                              //   descriptionController.text,
                              // );
                              // bloc.saveImage(image);
                              // savedShow();
                            }
                          }
                        });
                      }),
                ),
                SizedBox(
                  height: 20.0,
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
          title: new Text(AppLocalizations.instance.text('fromwhere'), style: TextStyle(
                fontFamily: 'SFProDisplayBold',
                fontSize: 23.5,
                fontWeight: FontWeight.bold,
              ),),
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
              child: new Text(AppLocalizations.instance.text('image'),),
            ),
            new FlatButton(
              onPressed: () {
                Navigator.pop(context);
                isVideo = true;
                _getVideo();
              },
              child: new Text(AppLocalizations.instance.text('video'),),
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
                        var image1 = await ImagePicker.pickImage(
                            source: ImageSource.gallery, imageQuality: 100);
                        Navigator.pop(context);
                        setState(() {
                          _media = image1;
                        });
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
                        var image2 = await ImagePicker.pickImage(
                            source: ImageSource.camera, imageQuality: 100);
                        Navigator.pop(context);
                        setState(() {
                          _media = image2;
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
