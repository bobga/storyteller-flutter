import 'package:Storyteller/src/ui/search%20tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../blocs/nav_bloc.dart';
import 'package:Storyteller/src/ui/add_photo.dart';
import 'package:Storyteller/src/ui/newsfeed.dart';
import 'package:Storyteller/src/ui/notifications.dart';
import 'package:Storyteller/src/ui/profile.dart';
import 'package:line_icons/line_icons.dart';
import 'globals.dart' as global;
import '../blocs/profile_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class StoryTellerBottom extends StatefulWidget {
  @override
  MyBottomNavigationBar createState() => MyBottomNavigationBar();
}

class MyBottomNavigationBar extends State<StoryTellerBottom> {
  BottomNavBarBloc _bottomNavBarBloc;

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
    _bottomNavBarBloc = BottomNavBarBloc();
  }

  @override
  void dispose() {
    _bottomNavBarBloc.close();
    bloc.dispose();
    super.dispose();
  }

  refresh() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<NavBarItem>(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          switch (snapshot.data) {
            case NavBarItem.HOME:
              return PhotoFeed();
            case NavBarItem.SEARCH:
              return SearchPageTab();
            case NavBarItem.ADD:
              return PhotoForm();
            case NavBarItem.ALERT:
              return StoryTellerNotification();
            case NavBarItem.PROFILE:
              return StorytellerProfile(0, false, refresh);
          }

          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          );
        },
      ),
      bottomNavigationBar: StreamBuilder(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          return BottomNavigationBar(
            fixedColor: Color.fromRGBO(0, 0, 0, 1),
            unselectedItemColor: Color.fromRGBO(152, 152, 152, 1),
            type: BottomNavigationBarType.fixed,
            currentIndex: snapshot.data.index,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: _bottomNavBarBloc.pickItem,
            items: [
              BottomNavigationBarItem(
                title: new Text("Discover",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11.0,
                    )),
                // activeIcon: new Image.asset('assets/baricon/h1.png', width: 25, height: 25, ),
                activeIcon: Column(
                  children: [
                    Container(
                      transform: Matrix4.translationValues(0.0, 2.0, 0.0),
                      child: Icon(LineIcons.home, size: 27.5),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      transform: Matrix4.translationValues(0.0, 4.0, 0.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 5,
                      height: 5,
                    ),
                  ],
                ),

                icon: Column(
                  children: [
                    Container(
                      transform: Matrix4.translationValues(0.0, 2.0, 0.0),
                      child: Icon(LineIcons.home, size: 27.5),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      transform: Matrix4.translationValues(0.0, 4.0, 0.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 5,
                      height: 5,
                    ),
                  ],
                ),
              ),
              BottomNavigationBarItem(
                title: new Text("Search",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11.0,
                    )),
                activeIcon: Column(
                  children: [
                    Container(
                      transform: Matrix4.translationValues(0.0, 2.0, 0.0),
                      child: Icon(LineIcons.search, size: 27.5),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      transform: Matrix4.translationValues(0.0, 4.0, 0.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 5,
                      height: 5,
                    ),
                  ],
                ),
                icon: Column(
                  children: [
                    Container(
                      transform: Matrix4.translationValues(0.0, 2.0, 0.0),
                      child: Icon(LineIcons.search, size: 27.5),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      transform: Matrix4.translationValues(0.0, 4.0, 0.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 5,
                      height: 5,
                    ),
                  ],
                ),
              ),
              BottomNavigationBarItem(
                title: new Text("Post",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11.0,
                    )),
                activeIcon: Column(
                  children: [
                    Container(
                      transform: Matrix4.translationValues(0.0, 2.0, 0.0),
                      child: Icon(LineIcons.plus_circle, size: 27.5),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      transform: Matrix4.translationValues(0.0, 4.0, 0.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 5,
                      height: 5,
                    ),
                  ],
                ),
                icon: Column(
                  children: [
                    Container(
                      transform: Matrix4.translationValues(0.0, 2.0, 0.0),
                      child: Icon(LineIcons.plus_circle, size: 27.5),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      transform: Matrix4.translationValues(0.0, 4.0, 0.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 5,
                      height: 5,
                    ),
                  ],
                ),
              ),
              BottomNavigationBarItem(
                title: new Text("Activity",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11.0,
                    )),
                activeIcon: Column(
                  children: [
                    Container(
                      transform: Matrix4.translationValues(0.0, 2.0, 0.0),
                      child: Icon(LineIcons.heart_o, size: 27.5),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      transform: Matrix4.translationValues(0.0, 4.0, 0.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 5,
                      height: 5,
                    ),
                  ],
                ),
                icon: Column(
                  children: [
                    Container(
                      transform: Matrix4.translationValues(0.0, 2.0, 0.0),
                      child: Icon(LineIcons.heart_o, size: 27.5),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      transform: Matrix4.translationValues(0.0, 4.0, 0.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 5,
                      height: 5,
                    ),
                  ],
                ),
              ),
              BottomNavigationBarItem(
                title: new Text("Profile",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11.0,
                    )),
                activeIcon: Column(
                  children: [
                    Container(
                      transform: Matrix4.translationValues(0.0, 2.0, 0.0),
                      child: Icon(LineIcons.user, size: 27.5),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      transform: Matrix4.translationValues(0.0, 4.0, 0.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 5,
                      height: 5,
                    ),
                  ],
                ),
                icon: Column(
                  children: [
                    Container(
                      transform: Matrix4.translationValues(0.0, 2.0, 0.0),
                      child: Icon(LineIcons.user, size: 27.5),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      transform: Matrix4.translationValues(0.0, 4.0, 0.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 5,
                      height: 5,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
