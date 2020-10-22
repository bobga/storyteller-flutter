import 'package:flutter/material.dart';
import 'login.dart';

class StoryTellerConfirm extends StatefulWidget {
  @override
  _StoryTellerConfirmState createState() => _StoryTellerConfirmState();
}

class _StoryTellerConfirmState extends State<StoryTellerConfirm> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: true,
            floating: true,
            pinned: true,
            title: Text(
              'Reset Confirm',
              style: TextStyle(
                fontFamily: 'SFProDisplayRegular',
                fontSize: 20.0,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 70.0),
                Column(
                  children: <Widget>[
                    Text(
                      'Great! Check your Email!',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'We’ve send you a special form to reset your password!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: ButtonTheme(
                    minWidth: screenSize.width,
                    height: screenSize.height / 15,
                    child: RaisedButton(
                      color: Color.fromRGBO(61, 131, 255, 1),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(15.0)),
                      child: new Text(
                        "Go To Login Page",
                        style: new TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            fontFamily: 'SFProDisplayRegular'),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginForm(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
