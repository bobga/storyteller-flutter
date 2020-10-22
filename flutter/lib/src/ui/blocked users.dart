import 'package:Storyteller/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import '../blocs/blocklist_bloc.dart';

class BlockedUsers extends StatefulWidget {
  @override
  _BlockedUsers createState() => new _BlockedUsers();
}

class _BlockedUsers extends State<BlockedUsers> {
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  bool user = true;
  @override
  void initState() {
    super.initState();
    check().then(
      (internet) {
        if (internet == false) {
        } else {
          bloc.fetchBlockedUser();
        }
      },
    );
  }

  void refresh() {
    bloc.fetchBlockedUser();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
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
                  AppLocalizations.instance.text('blockedusers'),
                  style: TextStyle(
                    fontFamily: 'SFProDisplayBold',
                    fontSize: 25.0,
                  ),
                ),
                centerTitle: true,
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
                            child: Text("Still nothing",
                                style: TextStyle(
                                  color: Color.fromRGBO(148, 148, 148, 1),
                                  fontSize: 11.7,
                                )),
                          ),
                        ),
                      );
                    } else {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: new BorderRadius.circular(30.0),
                                child: CachedNetworkImage(
                                  height: kToolbarHeight / 1.1,
                                  width: kToolbarHeight / 1.1,
                                  fit: BoxFit.cover,
                                  imageUrl: snapshot.data.datas[index].avatar,
                                ),
                              ),
                              title: new Text(
                                snapshot.data.datas[index].name,
                                style: TextStyle(
                                  fontFamily: 'SFProDisplayBold',
                                ),
                              ),
                              subtitle: new Text("blocked"),
                              trailing: ButtonTheme(
                                height: kToolbarHeight / 1.7,
                                minWidth:
                                    MediaQuery.of(context).size.width / 3.7,
                                child: FlatButton(
                                  color: Color.fromRGBO(0, 141, 252, 1),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0)),
                                  child: new Text(
                                    "Unblock",
                                    style: new TextStyle(
                                        fontSize: 16.5,
                                        color: Colors.white,
                                        fontFamily: 'SFProDisplayRegular'),
                                  ),
                                  onPressed: () {
                                    bloc.unBlockuser(
                                        snapshot.data.datas[index].id);
                                    refresh();
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BlockedUsers(),
                                      ),
                                    );
                                  },
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
