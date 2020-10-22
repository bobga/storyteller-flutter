import 'package:Storyteller/app_localizations.dart';
import 'package:Storyteller/src/ui/signup.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'bottomNavigation.dart';
import 'reset.dart';
import '../blocs/login_bloc.dart';
import 'globals.dart' as global;
import 'dart:async';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => new _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
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
          bloc.getUser.listen(
            (data) {
              if (data.user.id != null) {
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
      key: _formKey,
      child: loginForm(context),
    );
  }

  Scaffold loginForm(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.all(0),
                ),
                Container(
                  margin: EdgeInsets.only(top: 100),
                  child: Image.asset(
                    'assets/icon/logoicon.png',
                    width: 111,
                    height: 111,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Center(
                    child: Text(
                      'teling',
                      style: TextStyle(
                          fontFamily: 'SFProDisplayBold',
                          fontSize: 35.0,
                          color: Colors.black26),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Container(
                  width: screenSize.width,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 27.0,
                      ),
                      new Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: new Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: Color.fromRGBO(0, 0, 0, 1),
                          ),
                          child: TextFormField(
                            controller: usernameController,
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
                      SizedBox(height: 30.0),
                      ButtonTheme(
                        height: kToolbarHeight / 1.20,
                        minWidth: MediaQuery.of(context).size.width / 1.3,
                        child: FlatButton(
                            color: Color.fromRGBO(0, 141, 252, 1),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            child: (load == false)
                                ? new Text(
                                    AppLocalizations.instance.text('login'),
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
                                  if (_formKey.currentState.validate() ==
                                      true) {
                                    setState(() {
                                      load = true;
                                    });
                                    await bloc.loginUserLogin(
                                        usernameController.text,
                                        passwordController.text);
                                    setState(() {
                                      load = false;
                                    });
                                  }
                                }
                              });
                            }),
                      ),
                      SizedBox(height: 15.0),
                      InkWell(
                        borderRadius: new BorderRadius.circular(15.0),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupForm(),
                            ),
                          );
                        },
                        child: Container(
                          height: kToolbarHeight / 1.20,
                          width: MediaQuery.of(context).size.width / 1.3,
                          child: new Align(
                            alignment: Alignment.center,
                            child: new RichText(
                              text: new TextSpan(
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'SFProDisplaySemiBold',
                                  color: Color.fromRGBO(61, 131, 255, 1),
                                ),
                                children: <TextSpan>[
                                  new TextSpan(
                                    text: AppLocalizations.instance.text('donthave'),
                                    style: new TextStyle(
                                      fontFamily: 'SFProDisplaySemiBold',
                                      color: Color.fromRGBO(154, 154, 154, 1),
                                    ),
                                  ),
                                  new TextSpan(
                                    text: AppLocalizations.instance.text('signup'),
                                    style: new TextStyle(
                                      fontFamily: 'SFProDisplaySemiBold',
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      InkWell(
                        borderRadius: new BorderRadius.circular(15.0),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoryTellerReset(),
                            ),
                          );
                        },
                        child: Container(
                          height: kToolbarHeight / 1.20,
                          width: MediaQuery.of(context).size.width / 1.3,
                          child: new Align(
                            alignment: Alignment.center,
                            child: new Text(
                              AppLocalizations.instance.text('forgot'),
                              style: new TextStyle(
                                fontFamily: 'SFProDisplaySemiBold',
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
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
