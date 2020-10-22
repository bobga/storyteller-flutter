import 'package:Storyteller/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'reset_confirm.dart';
import '../blocs/reset_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';

class StoryTellerReset extends StatefulWidget {
  @override
  _StoryTellerResetState createState() => _StoryTellerResetState();
}

class _StoryTellerResetState extends State<StoryTellerReset> {
  TextEditingController controller = TextEditingController();
  final _formKey2 = GlobalKey<FormState>();
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
          bloc.getMessage.listen((data) {
            print(data.message);
            if (data.message.status == true) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoryTellerConfirm(),
                ),
              );
            }
          });
        }
      },
    );

    return Form(
      key: _formKey2,
      child: Scaffold(
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 50,
              floating: true,
              elevation: 1.0,
              centerTitle: true,
              pinned: true,
              title: Text(
                AppLocalizations.instance.text('resetpassword'),
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
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(height: 70.0),
                        new Padding(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                AppLocalizations.instance.text('writeemail'),
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                AppLocalizations.instance.text('formareset'),
                                
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        new Padding(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: new Theme(
                            data: Theme.of(context).copyWith(
                              primaryColor: Color.fromRGBO(61, 131, 255, 1),
                            ),
                            child: TextFormField(
                              controller: controller,
                              keyboardType: TextInputType.emailAddress,
                              maxLines: 1,
                              autofocus: false,
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
                                contentPadding:
                                    EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                                filled: true,
                                fillColor: Theme.of(context).cardColor,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50.0),
                        ButtonTheme(
                          height: kToolbarHeight / 1.20,
                          minWidth: MediaQuery.of(context).size.width / 1.3,
                          child: FlatButton(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(15.0)),
                              child: (load == false)
                                  ? new Text(
                                      AppLocalizations.instance.text('reset'),
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
                                      if (_formKey2.currentState.validate() ==
                                          true) {
                                        setState(() {
                                          load = true;
                                        });
                                        await bloc.resetLogin(controller.text);
                                        setState(() {
                                          load = false;
                                        });
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
      ),
    );
  }
}
