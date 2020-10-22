import 'package:Storyteller/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_svg/flutter_svg.dart';

class SetMessages extends StatefulWidget {
  @override
  _SetMessages createState() => new _SetMessages();
}

class _SetMessages extends State<SetMessages> {
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
                elevation: 1.0,
                expandedHeight: kToolbarHeight,
                pinned: true,
                floating: true,
                title: Text(
                  AppLocalizations.instance.text('messagessettings'),
                  style: TextStyle(
                    fontFamily: 'SFProDisplayBold',
                    fontSize: 25.0,
                  ),
                ),
                centerTitle: true,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    
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
