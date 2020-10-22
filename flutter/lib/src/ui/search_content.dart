import 'package:Storyteller/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../blocs/search_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:Storyteller/src/ui/profile.dart';
import 'dart:async';
import 'package:Storyteller/src/models/user_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchContentPage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<SearchContentPage> {
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
          bloc.fetchAllUsers(controller.text);
          bloc.userFetcherStatus.listen(
            (onData) {
              bloc.fetchAllUsers(controller.text);
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  refresh() {
    check().then(
      (internet) {
        if (internet == false) {
        } else {
          bloc.fetchAllUsers(controller.text);
        }
      },
    );
  }

  TextEditingController controller = new TextEditingController();
  Color _colorforFollow = Color.fromRGBO(0, 141, 252, 1);
  Color _colorforUnfollow = Color.fromRGBO(212, 212, 212, 1);
  bool hasSearchEntry = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: [
          buildList(),
          Container(
            height: MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildList() {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          elevation: 0.0,
          expandedHeight: kToolbarHeight + 10,
          leading: Container(
            padding: EdgeInsets.only(left: 13.0, bottom: 0),
            child: BackButton(),
          ),
          pinned: true,
          floating: true,
          title: Theme(
            data: Theme.of(context).copyWith(
              primaryColor: Color.fromRGBO(61, 131, 255, 1),
            ),
            child: TextField(
              controller: controller,
              decoration: new InputDecoration(
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                suffixIcon: hasSearchEntry
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          controller.clear();
                          bloc.fetchAllUsers(controller.text);
                          setState(
                            () {
                              hasSearchEntry = false;
                            },
                          );
                        },
                      )
                    : SizedBox(),
                hintText: AppLocalizations.instance.text('searchuser'),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onChanged: onSearchTextChanged,
            ),
          ),
        ),
        StreamBuilder(
          stream: bloc.allUsers,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.datas.length == 0) {
                return SliverToBoxAdapter(
                  child: Container(
                    height: 50.0,
                    child: Center(
                      child: Text("No Users"),
                    ),
                  ),
                );
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return new InkWell(
                        onTap: () => {
                          navigateToUser(snapshot.data.datas[index].id),
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 10.0,
                            bottom: 10.0,
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: new BorderRadius.circular(30.0),
                              child: CachedNetworkImage(
                                height: kToolbarHeight / 1,
                                width: kToolbarHeight / 1,
                                fit: BoxFit.cover,
                                imageUrl: snapshot.data.datas[index].avatar,
                              ),
                            ),
                            title: Row(
                              children: [
                                Container(
                                  child: new Text(
                                    snapshot.data.datas[index].name,
                                    style: TextStyle(
                                      fontFamily: "SFProDisplayBold",
                                      fontSize: 16.6,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                snapshot.data.datas[index].badge == 'true'
                                    ? Container(
                                        padding: EdgeInsets.only(top: 1),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.transparent),
                                        child: Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: SvgPicture.network(
                                              "https://teling.app/wp-content/uploads/2020/09/check.svg",
                                              width: 14,
                                              height: 14),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                            trailing: ButtonTheme(
                              height: kToolbarHeight / 1.7,
                              minWidth: MediaQuery.of(context).size.width / 4,
                              child: FlatButton(
                                color: (snapshot.data.datas[index].follow ==
                                        "true")
                                    ? _colorforUnfollow
                                    : _colorforFollow,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(7.0)),
                                child: (snapshot.data.datas[index].follow ==
                                        "true")
                                    ? Text(
                                        AppLocalizations.instance
                                            .text('unfollow'),
                                        style: new TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white,
                                            fontFamily: 'SFProDisplayRegular'),
                                      )
                                    : Text(
                                        AppLocalizations.instance
                                            .text('follow'),
                                        style: new TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white,
                                            fontFamily: 'SFProDisplayRegular'),
                                      ),
                                onPressed: () {
                                  (snapshot.data.datas[index].follow == "true")
                                      ? check().then(
                                          (internet) async {
                                            if (internet == false) {
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: new Text(
                                                      'Are you sure?',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'SFProDisplayBold',
                                                        fontSize: 23.5,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    content: new Text(
                                                        "You won't be following this person anymore!"),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    actions: <Widget>[
                                                      new FlatButton(
                                                        child: new Text("No"),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                      new FlatButton(
                                                        child: new Text("Yes"),
                                                        onPressed: () async {
                                                          await bloc
                                                              .unFollowUser(
                                                                  snapshot
                                                                      .data
                                                                      .datas[
                                                                          index]
                                                                      .id);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        )
                                      : check().then(
                                          (internet) async {
                                            if (internet == false) {
                                            } else {
                                              bloc.followUser(snapshot
                                                  .data.datas[index].id);
                                            }
                                          },
                                        );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: snapshot.data.datas.length,
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return SliverToBoxAdapter(
                child: Container(
                  height: 90.0,
                  child: Center(
                    child: Text(snapshot.error.toString()),
                  ),
                ),
              );
            }

            return SliverToBoxAdapter(
              child: Container(
                height: 90.0,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void navigateToUser(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StorytellerProfile(
          id,
          true,
          refresh,
        ),
      ),
    );
  }

  Future onSearchTextChanged(String value) async {
    bloc.fetchAllUsers(value);
    setState(() {
      hasSearchEntry = value.isNotEmpty;
    });
  }
}
