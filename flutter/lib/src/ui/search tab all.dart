import 'package:Storyteller/app_localizations.dart';
import 'package:Storyteller/src/ui/video.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'search_content.dart';
import '../blocs/search_main_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/image_model.dart';
import 'package:Storyteller/src/ui/profile.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:line_icons/line_icons.dart';
import 'dart:async';
import 'package:mime/mime.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SearchTabAll extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<SearchTabAll> {
  
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
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
          bloc.fetchPhoto(controller.text);
          bloc.photoFetcherStatusSearch.listen((onData) {
            bloc.fetchPhoto(controller.text);
          });
        }
      },
    );
  }

void savedShow() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        
        return AlertDialog(
          
          
          content: new Text(AppLocalizations.instance.text('seccessreport'), textAlign: TextAlign.center,),
          
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

  void _onRefresh() async {
    // monitor network fetch
    await bloc.fetchPhoto(controller.text);
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  refresh() {}

  refreshFilter() {
    setState(() {});
  }

  TextEditingController controller = new TextEditingController();
  bool hasSearchEntry = false;

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  checkFileType(String url) {
    String mimeStr = lookupMimeType(url);
    var fileType = mimeStr.split('/');
    print(fileType[0]);
    return fileType[0];
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: [
        Scaffold(
          
          body: buildMyList(),
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

  Widget buildMyList() {
    final screenSize = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: bloc.allPhotos,
      builder: (context, AsyncSnapshot<ImageModel> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.datas.length == 0) {
            return Center(
              child: Text("No Posts"),
            );
          } else {
            return SmartRefresher(
              enablePullDown: true,
              header: ClassicHeader(),
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StorytellerProfile(
                                        snapshot.data.data[index].user.data.id,
                                        false,
                                        refresh),
                                  ),
                                ),
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                    bottom: 15.0,
                                    top: 13.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                      child: CachedNetworkImage(
                                        height: kToolbarHeight / 1.1,
                                        width: kToolbarHeight / 1.1,
                                        fit: BoxFit.cover,
                                        placeholder: (c, d) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                            ),
                                          );
                                        },
                                        imageUrl: snapshot
                                            .data.data[index].user.data.avatar,
                                      ),
                                    ),
                                    
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                new Text(
                                                  snapshot.data.data[index].user
                                                      .data.name,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "SFProDisplayBold",
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                snapshot.data.data[index].user
                                                            .data.badge ==
                                                        'true'
                                                    ? Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 1),
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors
                                                                .transparent),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          child: SvgPicture.network(
                                                              "https://teling.app/wp-content/uploads/2020/09/check.svg",
                                                              width: 14,
                                                              height: 14),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 2.0,
                                            ),
                                            new Text(
                                              timeago.format(
                                                DateTime.parse(snapshot.data
                                                        .data[index].createdat)
                                                    .toLocal(),
                                                locale: AppLocalizations.instance.mlangCode
                                              ),
                                              style: TextStyle(
                                                fontFamily:
                                                    "SFProDisplayRegular",
                                                fontSize: 14,
                                                color: Color.fromRGBO(
                                                    152, 152, 152, 1),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            MaterialButton(
                              height: 20.0,
                              minWidth: 65.0,
                              child: const Icon(LineIcons.ellipsis_h),
                              onPressed: () {
                                
                                showModalBottomSheet<dynamic>(
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                           BorderRadius.circular(15.0)),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Wrap(
                                    children: <Widget>[
                                     Container(
                                      decoration: new BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: new BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(30.0),
                                              topRight:
                                                  const Radius.circular(30.0))),
                                      
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 20, top: 22),
                                              child: Text(
                                                AppLocalizations.instance
                                                    .text('reportpost'),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20.0,
                                                    fontFamily:
                                                        'SFProDisplayBold'),
                                              ),
                                            ),
                                            const Divider(
                                              color: Color.fromRGBO(
                                                  224, 224, 224, 1),
                                              height: 1,
                                              thickness: 0,
                                              indent: 20,
                                              endIndent: 20,
                                            ),
                                            SizedBox(
                                              height: 27,
                                            ),
                                            Row(children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 20, left: 25),
                                                child: Text(
                                                  AppLocalizations.instance
                                                      .text('beforereport'),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16.0,
                                                      fontFamily:
                                                          'SFProDisplayBold'),
                                                ),
                                              )
                                            ]),
                                            Container(
                                              margin: EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                bottom: 35,
                                              ),
                                              child: Text(
                                                AppLocalizations.instance
                                                    .text('Reportline1'),
                                              ),
                                            ),
                                            Container(
                                              child: new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ButtonTheme(
                                                      minWidth:
                                                          screenSize.width - 50,
                                                      height: 46.0,
                                                      child: FlatButton(
                                                        child: Text(
                                                          AppLocalizations
                                                              .instance
                                                              .text(
                                                                  'presstoreport'),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15.0,
                                                              fontFamily:
                                                                  'SFProDisplayMedium'),
                                                        ),
                                                        color: Color.fromRGBO(
                                                            230, 5, 5, 1),
                                                        shape: new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .circular(
                                                                    10.0)),
                                                        onPressed: () {
                                                          print(snapshot.data
                                                              .data[index].id);
                                                          bloc.reportpost(
                                                              snapshot
                                                                  .data
                                                                  .data[index]
                                                                  .id);
                                                          Navigator.pop(
                                                              context);
                                                          savedShow();
                                                        },
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                            SizedBox(height: 10),
                                            ButtonTheme(
                                              minWidth: screenSize.width - 50,
                                              height: 46.0,
                                              child: FlatButton(
                                                  child: Text(
                                                    AppLocalizations.instance
                                                        .text('cancel'),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15.0,
                                                        fontFamily:
                                                            'SFProDisplayMedium'),
                                                  ),
                                                  color: Color.fromRGBO(
                                                      0, 141, 252, 1),
                                                  shape:
                                                      new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  10.0)),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  }),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                bottom: 35,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                     )
                                    ]
                                    );
                                  },
                                );
                              },
                            ),
                          ]),
                         
                      GestureDetector(
                        onDoubleTap: () {
                          (snapshot.data.data[index].like == "true")
                              ? bloc.unlikepost(snapshot.data.data[index].id)
                              : bloc.likepost(snapshot.data.data[index].id);
                         
                        },
                        child: new Container(
                          child: Stack(children: <Widget>[
                            new Container(
                              padding: EdgeInsets.only(
                                left: 0,
                                right: 0,
                              ),
                              child: ClipRRect(
                                borderRadius: new BorderRadius.circular(0.0),
                                child: checkFileType(
                                            snapshot.data.data[index].image) ==
                                        "image"
                                    ? CachedNetworkImage(
                                        width: screenSize.width,
                                        placeholder: (c, d) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                            ),
                                          );
                                        },
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            snapshot.data.data[index].image,
                                      )
                                    : VideoClip(
                                        url: snapshot.data.data[index].image,
                                      ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                      SizedBox(
                        height: 0.0,
                      ),

Container(
  color: Color.fromRGBO(224, 224, 224, 0.15),
child:
new Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [

    

SizedBox(
      width: 335,
      child:
    Container (
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left:16.0, top: 13, bottom: 13, right: 19,),
      child: new Column (
        children: <Widget>[
          RichText(
           overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 2,
             text: TextSpan(
              text: snapshot.data.data[index].user.data.name + ' ',
               style:
                TextStyle(fontFamily:"SFProDisplayBold",
                     fontSize:13.7, color: Color.fromRGBO(28, 28, 28, 1),
                     ),
    children: <TextSpan>[
      TextSpan(
        text: snapshot.data.data[index].description,
        style:
                TextStyle(fontFamily:"SFProDisplayMedium",
                     fontSize:13.7, color: Color.fromRGBO(28, 28, 28, 1),
                     ),  
      ),
    ],
  ),
),
        ],
      ),
    ),
),

    Container (
      padding: const EdgeInsets.only(top:13.0, bottom: 13, right: 16 ),
      child:
    Row(
       children: [
           GestureDetector(
             onTap: () {(snapshot.data.data[index].like == "true")
                ? bloc.unlikepost(snapshot.data.data[index].id)
                : bloc.likepost(snapshot.data.data[index].id);
                },
                child: (snapshot.data.data[index].like == "true")
                 ? Icon(
                   Icons
                   .favorite,
                   color: Colors.red, size: 23)
                 : Icon(
                   Icons
                   .favorite_border, size: 23),
                 ),
                   SizedBox(
                   width: 5.0,
                   ),
                 
                 Text(
                   snapshot
                   .data
                   .data[index]
                   .likecount
                   .toString() + '',
                   textAlign:
                   TextAlign.start,
                   style: TextStyle(
                   fontFamily:
                   "SFProDisplayBold",
                    fontSize: 14.5,
                   ),
                  ),
                  ],
                 ),
    ),
  ]
),
),
Container (
      padding: const EdgeInsets.only(bottom:10.0),
      child:
const Divider(
            color: Color.fromRGBO(224, 224, 224, 1),
            height: 1,
            thickness: 0,
            indent: 0,
            endIndent: 0,
          ),
),

                    ],
                  );
                },
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
        );
      },
    );
  }

  Future onSearchTextChanged(String value) async {
    bloc.fetchPhoto(value);
    setState(() {
      hasSearchEntry = value.isNotEmpty;
    });
  }
}
