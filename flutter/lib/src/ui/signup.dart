import 'package:Storyteller/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:Storyteller/src/models/user_model.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'bottomNavigation.dart';
import '../blocs/signup_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class SignupForm extends StatefulWidget {
  @override
  StoryTellerSignup createState() => new StoryTellerSignup();
}

class StoryTellerSignup extends State<SignupForm>
    with TickerProviderStateMixin {
  bool _value1 = false;
  void _value1Changed(bool value) => setState(() => _value1 = value);
  final _formKey1 = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordCheckController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool load = false;

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
  Widget build(BuildContext context) {
    check().then(
      (internet) {
        if (internet == false) {
        } else {
          bloc.getMessage.listen(
            (data) {
              if (data.message.message == "Created") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoryTellerBottom(),
                  ),
                );
              }
            },
          );
        }
      },
    );

    return Form(
      key: _formKey1,
      child: signupForm(context),
    );
  }

  Scaffold signupForm(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            elevation: 1.0,
            centerTitle: true,
            pinned: true,
            title: Text(
              AppLocalizations.instance.text('signup'),
              style: TextStyle(
                fontFamily: 'SFProDisplayBold',
                fontSize: 25.0,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  width: screenSize.width,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15.0,
                      ),
                      new Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: new Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: Color.fromRGBO(61, 131, 255, 1),
                          ),
                          child: TextFormField(
                            controller: nameController,
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            autofocus: false,
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
                              contentPadding:
                                  EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                              fillColor: Theme.of(context).cardColor,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      new Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: new Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: Color.fromRGBO(61, 131, 255, 1),
                          ),
                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            maxLines: 1,
                            autofocus: false,
                            validator: Validators.compose([
                              Validators.required('Email is required'),
                              Validators.email('Invalid email address'),
                              Validators.minLength(
                                  5, 'Email cannot be less than 5 characters'),
                              Validators.maxLength(120,
                                  'Email cannot be greater than 120 characters'),
                            ]),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.instance.text('email'),
                              filled: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                              fillColor: Theme.of(context).cardColor,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      new Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: new Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: Color.fromRGBO(61, 131, 255, 1),
                          ),
                          child: TextFormField(
                            controller: passwordController,
                            maxLines: 1,
                            autofocus: false,
                            obscureText: true,
                            validator: Validators.compose([
                              Validators.required('Password is required'),
                              Validators.minLength(8,
                                  'Password cannot be less than 8 characters'),
                              Validators.maxLength(120,
                                  'Password cannot be greater than 120 characters'),
                            ]),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.instance.text('password'),
                              filled: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                              fillColor: Theme.of(context).cardColor,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      new Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: new Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: Color.fromRGBO(61, 131, 255, 1),
                          ),
                          child: TextFormField(
                            controller: passwordCheckController,
                            maxLines: 1,
                            autofocus: false,
                            obscureText: true,
                            validator: Validators.compose([
                              Validators.required('Password is required'),
                              Validators.minLength(8,
                                  'Password cannot be less than 8 characters'),
                              Validators.maxLength(120,
                                  'Password cannot be greater than 120 characters'),
                            ]),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.instance.text('confpass'),
                              filled: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                              fillColor: Theme.of(context).cardColor,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),














Container(
  margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom:10),
  padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom:0),
  
  decoration: new BoxDecoration(
  color: Color.fromRGBO(243, 243, 243, 1),
  borderRadius: new BorderRadius.only(
              topLeft: const Radius
              .circular(20.0),
              topRight:const Radius
              .circular(20.0),
              bottomRight:const Radius
              .circular(20.0),
              bottomLeft:const Radius
              .circular(20.0),
              )),
  height: 340,
  child:
  
SingleChildScrollView(
	child: Column(
	children: <Widget>[
 Text(AppLocalizations.instance.text('acceptrules1'),),
Text(AppLocalizations.instance.text('acceptrules2'),),
 Text(AppLocalizations.instance.text('acceptrules3'),),
	],
  ),
 ),
),

















                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularCheckBox(
                            activeColor: Color.fromRGBO(10, 196, 19, 1),
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            value: _value1,
                            onChanged: _value1Changed,
                          ),
                          GestureDetector(
                            onTap: () async {
                              try {
                                await launch('');
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: new RichText(
                              text: new TextSpan(
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'SFProDisplaySemiBold',
                                  color: Color.fromRGBO(10, 196, 19, 1),
                                ),
                                children: <TextSpan>[
                                  
                                  
                                  new TextSpan(
                                    
                                    text: AppLocalizations.instance.text('acept'),
                                    style: new TextStyle(
                                      fontFamily: 'SFProDisplaySemiBold',
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                    ),
                                  ),
                                  ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      ButtonTheme(
                        height: kToolbarHeight / 1.20,
                        minWidth: MediaQuery.of(context).size.width / 1.3,
                        child: FlatButton(
                            color: Color.fromRGBO(0, 141, 252, 1),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            child: (load == false)
                                ? new Text(
                                    AppLocalizations.instance.text('signup'),
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
                              check().then(
                                (internet) async {
                                  if (internet == false) {
                                  } else {
                                    if (_formKey1.currentState.validate() ==
                                        true) {
                                      if (_value1 == false) {
                                      } else {
                                        if (passwordCheckController.text !=
                                            passwordController.text) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: new Text(
                                                    "Passwords don't match!"),
                                                content: new Text(
                                                    "Check them once more!"),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
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
                                        } else {
                                          setState(() {
                                            load = true;
                                          });
                                          var userModel = User.signup(
                                            nameController.text,
                                            emailController.text,
                                            passwordController.text,
                                          );
                                          await bloc.userSignup(userModel);
                                          setState(() {
                                            load = false;
                                          });
                                        }
                                      }
                                    }
                                  }
                                },
                              );
                            }),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
