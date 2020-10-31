import 'package:Storyteller/app_localizations.dart';
import 'package:Storyteller/src/ui/blocked%20users.dart';
import 'package:Storyteller/src/ui/edit_cover.dart';
import 'package:Storyteller/src/ui/privacy%20info.dart';
import 'package:Storyteller/src/ui/set%20messages.dart';
import 'package:Storyteller/src/ui/terms%20info.dart';
import 'package:flutter/material.dart';
import 'package:Storyteller/src/constant/httpService.dart';
import 'package:connectivity/connectivity.dart';
import '../blocs/profile_bloc.dart';
import 'login.dart';
import 'edit_profile.dart';
import 'globals.dart' as global;
import 'package:url_launcher/url_launcher.dart';
import 'package:line_icons/line_icons.dart';
import 'package:open_app_settings/open_app_settings.dart';

class SettingsForm extends StatefulWidget {
  @override
  StoryTellerSettings createState() => new StoryTellerSettings();
}

class StoryTellerSettings extends State<SettingsForm> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                elevation: 0.0,
                expandedHeight: kToolbarHeight,
                pinned: true,
                floating: true,
                title: Text(
                  AppLocalizations.instance.text('settings'),
                  style: TextStyle(
                    fontFamily: 'SFProDisplayBold',
                    fontSize: 23.5,
                  ),
                ),
                centerTitle: true,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(
                      height: 20,
                    ),
                    
                    
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text(
                                AppLocalizations.instance.text('logout'),
                                style: TextStyle(
                                  fontFamily: 'SFProDisplayBold',
                                  fontSize: 23.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: new Text(
                                AppLocalizations.instance.text('exitmessage'),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text(
                                    AppLocalizations.instance.text('no'),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                new FlatButton(
                                  child: new Text(
                                    AppLocalizations.instance.text('yes'),
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                  onPressed: () {
                                    check().then(
                                      (internet) async {
                                        if (internet == false) {
                                        } else {
                                          await HttpService().logout();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginForm(),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: new Align(
                        alignment: Alignment.center,
                        child: ListTile(
                          leading: Container(
                            height: kToolbarHeight / 1.30,
                            width: kToolbarHeight / 1.30,
                            child: Icon(LineIcons.sign_out, color: Colors.black),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              //borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          title: Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: Text(
                              AppLocalizations.instance.text('logout',
                              ),
                              style: TextStyle(
                                                       color: Colors.black,
                                                       fontSize: 16.3,
                                                       fontFamily: 'SFProDisplayMedium'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    const Divider(
                      color: Color.fromRGBO(224, 224, 224, 1),
                      height: 1,
                      thickness: 0,
                      indent: 20,
                      endIndent: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          await launch('https://teling.app/verified/');
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: new Align(
                        alignment: Alignment.center,
                        child: ListTile(
                          leading: Container(
                            height: kToolbarHeight / 1.30,
                            width: kToolbarHeight / 1.30,
                            child: Icon(LineIcons.check_circle, color: Colors.black),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            //  borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          title: Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: Text(
                              AppLocalizations.instance.text('verifiedprofile'),
                              style: TextStyle(
                                                       color: Colors.black,
                                                       fontSize: 16.3,
                                                       fontFamily: 'SFProDisplayMedium'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          await launch('https://teling.app/internal-rules/');
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: new Align(
                        alignment: Alignment.center,
                        child: ListTile(
                          leading: Container(
                            height: kToolbarHeight / 1.30,
                            width: kToolbarHeight / 1.30,
                            child: Icon(LineIcons.clone, color: Colors.black),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                             // borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          title: Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: Text(
                              AppLocalizations.instance.text('telingrules'),
                              style: TextStyle(
                                                       color: Colors.black,
                                                       fontSize: 16.3,
                                                       fontFamily: 'SFProDisplayMedium'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          await launch('https://teling.app/contact/');
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: new Align(
                        alignment: Alignment.center,
                        child: ListTile(
                          leading: Container(
                            height: kToolbarHeight / 1.30,
                            width: kToolbarHeight / 1.30,
                            child: Icon(LineIcons.at, color: Colors.black),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              //borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          title: Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: Text(
                              AppLocalizations.instance.text('contactus'),
                              style: TextStyle(
                                                       color: Colors.black,
                                                       fontSize: 16.3,
                                                       fontFamily: 'SFProDisplayMedium'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          await launch('https://teling.app/faq/');
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: new Align(
                        alignment: Alignment.center,
                        child: ListTile(
                          leading: Container(
                            height: kToolbarHeight / 1.30,
                            width: kToolbarHeight / 1.30,
                            child: Icon(LineIcons.question_circle, color: Colors.black),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                             // borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          title: Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: Text(
                              AppLocalizations.instance.text('faq'),
                              style: TextStyle(
                                                       color: Colors.black,
                                                       fontSize: 16.3,
                                                       fontFamily: 'SFProDisplayMedium'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Privacy(),
                          ),
                        );
                      },
                      child: new Align(
                        alignment: Alignment.center,
                        child: ListTile(
                          leading: Container(
                            height: kToolbarHeight / 1.30,
                            width: kToolbarHeight / 1.30,
                            child: Icon(LineIcons.shield, color: Colors.black),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                             // borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          title: Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: Text(
                              AppLocalizations.instance.text('privacy'),
                              style: TextStyle(
                                                       color: Colors.black,
                                                       fontSize: 16.3,
                                                       fontFamily: 'SFProDisplayMedium'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Terms(),
                          ),
                        );
                      },
                      child: new Align(
                        alignment: Alignment.center,
                        child: ListTile(
                          leading: Container(
                            height: kToolbarHeight / 1.30,
                            width: kToolbarHeight / 1.30,
                            child: Icon(LineIcons.balance_scale, color: Colors.black),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                             // borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          title: Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: Text(
                              AppLocalizations.instance.text('terms'),
                              style: TextStyle(
                                                       color: Colors.black,
                                                       fontSize: 16.3,
                                                       fontFamily: 'SFProDisplayMedium'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          await launch('https://teling.app/support/');
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: new Align(
                        alignment: Alignment.center,
                        child: ListTile(
                          leading: Container(
                            height: kToolbarHeight / 1.30,
                            width: kToolbarHeight / 1.30,
                            child: Icon(LineIcons.exclamation_circle, color: Colors.black),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                             // borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          title: Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: Text(
                              AppLocalizations.instance.text('support'),
                              style: TextStyle(
                                                       color: Colors.black,
                                                       fontSize: 16.3,
                                                       fontFamily: 'SFProDisplayMedium'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    const Divider(
                      color: Color.fromRGBO(224, 224, 224, 1),
                      height: 1,
                      thickness: 0,
                      indent: 20,
                      endIndent: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text(
                                AppLocalizations.instance.text('areyou'),
                                style: TextStyle(
                                  fontFamily: 'SFProDisplayBold',
                                  fontSize: 23.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: new Text(
                                AppLocalizations.instance.text('areyouline'),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text(
                                    AppLocalizations.instance.text('cancel'),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                new FlatButton(
                                  child: new Text(
                                    AppLocalizations.instance
                                        .text('deleteprofile'),
                                    style: TextStyle(
                                                       color: Colors.red,
                                                       ),
                                  ),
                                  onPressed: () {
                                    check().then(
                                      (internet) async {
                                        if (internet == false) {
                                        } else {
                                          print(global.userId);
                                          bloc.deleteaccount(global.userId);
                                          await HttpService().logout();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginForm(),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: new Align(
                        alignment: Alignment.center,
                        child: ListTile(
                          leading: Container(
                            height: kToolbarHeight / 1.30,
                            width: kToolbarHeight / 1.30,
                            child: Icon(
                              LineIcons.hand_stop_o, color: Colors.black45
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                             // borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          title: Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: Text(
                              AppLocalizations.instance.text('deleteprofile'),
                              style: TextStyle(
                                                       color: Colors.black45,
                                                       fontSize: 16.3,
                                                       fontFamily: 'SFProDisplayMedium'),
                              
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
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
      ),
    );
  }
}
