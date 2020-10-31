import 'dart:io';
import 'package:Storyteller/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:Storyteller/src/models/user_model.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../blocs/profile_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';

class EditUserForm extends StatefulWidget {
  @override
  StoryTellerEditProfile createState() => new StoryTellerEditProfile();
}

class StoryTellerEditProfile extends State<EditUserForm> {
  File _image;
  String name;
  String email;
  String bio;
  String link;
  bool isLoading = false;
  final GlobalKey<FormState> _formKey5 = GlobalKey<FormState>();

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
          bloc.fetchUser(0);
          bloc.userFetcherStatus.listen((onData) {}, onError: (_) {});
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
      key: _formKey5,
      child: Scaffold(
        body: StreamBuilder(
          stream: bloc.userDetail,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {}
            if (snapshot.hasData) {
              return new Stack(
                children: [
                  CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: <Widget>[
                      SliverAppBar(
                        leading: Container(
                        transform: Matrix4.translationValues(5.0, 0.0, 0.0),
                        padding: EdgeInsets.only(left: 10.0, bottom: 0),
                        child: BackButton(),
                      ),
                        elevation: 1.0,
                        expandedHeight: kToolbarHeight,
                        pinned: true,
                        backgroundColor: Colors.white,
                        floating: true,
                        centerTitle: true,
                        title: Text(
                          AppLocalizations.instance.text('editprofile'),
                          style: TextStyle(
                            fontFamily: 'SFProDisplayBold',
                            fontSize: 25.0,
                          ),
                        ),
                        
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            SizedBox(
                              height: 20.0,
                            ),
                            new Container(
                              width: screenSize.width,
                              child: new Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: _getImage,
                                      child: (_image != null)
                                          ? new Container(
                                              height: kToolbarHeight * 4,
                                              width: kToolbarHeight * 4,
                                              decoration: new BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(200.0),
                                                image: DecorationImage(
                                                  image: FileImage(_image),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : Stack(
                                              alignment: AlignmentDirectional
                                                  .topCenter,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          200.0),
                                                  child: Container(
                                                    height:
                                                        kToolbarHeight * 4,
                                                    width:
                                                        kToolbarHeight * 4,
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: snapshot
                                                          .data.user.avatar,
                                                    ),
                                                  ),
                                                ),
                                                ClipRRect(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          200.0),
                                                  child: Container(
                                                    height:
                                                        kToolbarHeight * 4,
                                                    width:
                                                        kToolbarHeight * 4,
                                                    color: Color.fromRGBO(
                                                            0, 0, 0, 1)
                                                        .withOpacity(0.2),
                                                  ),
                                                ),
                                                Container(
                                                  height: kToolbarHeight * 4,
                                                  width: kToolbarHeight * 4,
                                                  child: Center(
                                                    child: Icon(
                                                      LineIcons.upload,
                                                      color: Colors.white, size: 30,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              
              SizedBox(
                width: 8,
              ),
              snapshot.data.user.badge == 'true'
                  ? Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: new TextFormField(
                                style: TextStyle(color: Color.fromRGBO(145, 145, 145, 1)),
                                enabled: false,
                                maxLines: 1,
                                
                                keyboardType: TextInputType.text,
                                initialValue: snapshot.data.user.name,
                                autofocus: false,
                                onChanged: (text) {
                                  print("First text field: $text");
                                  setState(() {
                                    name = text;
                                  });
                                },
                                validator: Validators.compose([
                                  Validators.required('Display name is required'),
                                  Validators.minLength(5,
                                      'Display name cannot be less than 5 characters'),
                                  Validators.maxLength(120,
                                      'Display name cannot be greater than 120 characters'),
                                ]),
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.instance.text('displayname'),
                                  filled: true,
                                  fillColor: Theme.of(context).cardColor,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      15.0, 15.0, 15.0, 15.0),
                                ),
                                
                              ),

                            )



                  : Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: new TextFormField(
                                
                                maxLines: 1,
                                keyboardType: TextInputType.text,
                                initialValue: snapshot.data.user.name,
                                autofocus: false,
                                onChanged: (text) {
                                  print("First text field: $text");
                                  setState(() {
                                    name = text;
                                  });
                                },
                                validator: Validators.compose([
                                  Validators.required('Display name is required'),
                                  Validators.minLength(5,
                                      'Display name cannot be less than 5 characters'),
                                  Validators.maxLength(120,
                                      'Display name cannot be greater than 120 characters'),
                                ]),
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.instance.text('displayname'),
                                  filled: true,
                                  fillColor: Theme.of(context).cardColor,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      15.0, 15.0, 15.0, 15.0),
                                ),
                              ),
                            ),
            ],
          ),
                            SizedBox(
                              height: 15.0,
                            ),
                            new Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: new TextFormField(
                                initialValue: snapshot.data.user.email,
                                keyboardType: TextInputType.emailAddress,
                                maxLines: 1,
                                autofocus: false,
                                onChanged: (text) {
                                  print("First text field: $text");
                                  setState(() {
                                    email = text;
                                  });
                                },
                                validator: Validators.compose([
                                  Validators.required('Email is required'),
                                  Validators.email('Invalid email address'),
                                  Validators.minLength(5,
                                      'Email cannot be less than 5 characters'),
                                  Validators.maxLength(120,
                                      'Email cannot be greater than 120 characters'),
                                ]),
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  contentPadding: EdgeInsets.fromLTRB(
                                      15.0, 15.0, 15.0, 15.0),
                                  filled: true,
                                  fillColor: Theme.of(context).cardColor,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            new Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: new TextFormField(
                                initialValue: snapshot.data.user.bio,
                                keyboardType: TextInputType.text,
                                autofocus: false,
                                maxLines: null,
                                onChanged: (text) {
                                  print("First text field: $text");
                                  setState(() {
                                    bio = text;
                                  });
                                },
                                validator: Validators.compose([
                                  
                                  Validators.minLength(0,
                                      'Bio cannot be less than 5 characters'),
                                  Validators.maxLength(512,
                                      'Bio cannot be greater than 512 characters'),
                                ]),
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.instance.text('aboutme'),
                                  filled: true,
                                  fillColor: Theme.of(context).cardColor,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      15.0, 15.0, 15.0, 15.0),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 15.0,
                            ),
                            

                              snapshot.data.data.badge ==
                                  'true'
                                    ? new Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: new TextFormField(
                                initialValue: snapshot.data.user.link,
                                keyboardType: TextInputType.url,
                                autofocus: false,
                                maxLines: 1,
                                onChanged: (text) {
                                  print("First text field: $text");
                                  setState(() {
                                    link = text;
                                  });
                                },
                                validator: Validators.compose([
                                  
                                  Validators.minLength(0,
                                      'Link cannot be less than 2 characters'),
                                  Validators.maxLength(512,
                                      'Link cannot be greater than 35 characters'),
                                ]),
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.instance.text('promolink'),
                                  filled: true,
                                  fillColor: Theme.of(context).cardColor,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      15.0, 15.0, 15.0, 15.0),
                                ),
                              ),
                            )
                            : Container(),

                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: new EdgeInsets.only(left: 16.0),
                              constraints: new BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width - 84),
                              child:
                              Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                snapshot.data.data.badge ==
                                  'true'
                                    ? Container(
                                        
                                          padding: EdgeInsets.only(top: 6),
                                            decoration: BoxDecoration(
                                              shape:
                                              BoxShape.circle,
                                              color: Colors.transparent),
                                                  child:
                                                  Column(
                                                    children:<Widget>[
                                                  Row(
                                                   children: <Widget>[
                                                     
                                                     SvgPicture.network("https://teling.app/wp-content/uploads/2020/09/check.svg", width: 22, height: 22),
                                                     
                                                   Container(
                                                     padding: EdgeInsets.only(left: 10),
                                                     constraints: new BoxConstraints(
                                                       maxWidth: MediaQuery.of(context).size.width - 50),
                                                       child: 
                                                       
                                                       Text(
                                                         AppLocalizations.instance.text('verifiedmessage'),
                                                         style: TextStyle(color: Color.fromRGBO(148, 148, 148, 1), fontSize: 11.7,)
                                                             ),
                                                         
                                                       ),
                                                   ]
                                                              ),
                                                    ]
                                                  ),
                                                              )
                                                              : Container(),
                                                              ],
                                                            ),
                            ),

SizedBox(height: 25,),
                Stack(
                  alignment: Alignment.center,
                  children: [
                   
                Container(
                      margin: EdgeInsets.only(left: 0, right: 0),
                      width: screenSize.width - 25,
                      child:
                      
                ButtonTheme(
                  height: kToolbarHeight / 1.10,
                  minWidth: screenSize.width - 50,
                  
                  child: FlatButton(
                      color: Color.fromRGBO(0, 141, 252, 1),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      child: isLoading == false
                          ? new Text(
                              AppLocalizations.instance.text('save'),
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
                             onPressed: () async {
                              try {
                                if (_formKey5.currentState.validate() == true) {
                                  if (_image == null) {
                                    var userModel = User.editNoPhoto(
                                      (name != null)
                                          ? name
                                          : snapshot.data.user.name,
                                      (email != null)
                                          ? email
                                          : snapshot.data.user.email,
                                      (bio != null)
                                          ? bio
                                          : snapshot.data.user.bio,
                                      (link != null)
                                          ? link
                                          : snapshot.data.user.link,
                                         
                                    );
                                   setState(() {
                                   isLoading = true;
                                    });
                                    await bloc.editUser(userModel);
                                    savedShow();
                                    setState(() {
                                    isLoading = false;
                                    });
                                  } else {
                                    String base64Image =
                                        base64Encode(_image.readAsBytesSync());
                                    var userModel = User.edit(
                                      (name != null)
                                          ? name
                                          : snapshot.data.user.name,
                                      (email != null)
                                          ? email
                                          : snapshot.data.user.email,
                                      (bio != null)
                                          ? bio
                                          : snapshot.data.user.bio,
                                      (link != null)
                                          ? link
                                          : snapshot.data.user.link,

                                      base64Image,
                                      
                                    );
                                   setState(() {
                                   isLoading = true;
                                    });
                                    await bloc.editUser(userModel);
                                    setState(() {
                                   isLoading = true;
                                    });
                                    savedShow();
                                    setState(() {
                                    isLoading = false;
                                    });
                                  }
                                }
                              } catch (e) {
                                print(e);
                                
                              }
                            }
                      ),
                ),
                ),
                  ]
                ),




                          ],
                        ),
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
              );
            }
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            );
          },
        ),
      ),
    );
  }

  void savedShow() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        
        return AlertDialog(
          
          
          content: new Text(AppLocalizations.instance.text('saved'), textAlign: TextAlign.center,),
          
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Container( 
             padding: EdgeInsets.only(top: 40.0),
            child: 
             Icon(Icons.check_circle, size: 66, color: Color.fromRGBO(9, 214, 63, 1), ),),
          actions: <Widget>[
            new FlatButton(
              child: new Text(AppLocalizations.instance.text('close'),),
              onPressed: () {
                Navigator.pop(
                context);
              },
            ),
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
            title: new Text('From where?', style: TextStyle(
                fontFamily: 'SFProDisplayBold',
                fontSize: 23.5,
                fontWeight: FontWeight.bold,
              ),),
            content: new Text("Choose your favorite way."),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Gallery"),
                onPressed: () async {
                  var image1 = await ImagePicker.pickImage(
                      source: ImageSource.gallery, imageQuality: 50);
                  Navigator.pop(context);
                  setState(() {
                    _image = image1;
                  });
                },
              ),
              new FlatButton(
                child: new Text("Camera"),
                onPressed: () async {
                  var image2 = await ImagePicker.pickImage(
                      source: ImageSource.camera, imageQuality: 50);
                  Navigator.pop(context);
                  setState(() {
                    _image = image2;
                  });
                },
              ),
              new FlatButton(
                child: new Text(AppLocalizations.instance.text('close'),),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } catch (error) {}
  }
}
