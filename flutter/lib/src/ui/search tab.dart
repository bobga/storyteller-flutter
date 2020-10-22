import 'package:Storyteller/app_localizations.dart';
import 'package:Storyteller/src/ui/search%20tab%20photo.dart';
import 'package:Storyteller/src/ui/search%20tab%20video.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'search_content.dart';
import '../blocs/search_main_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:async';
import 'package:mime/mime.dart';
import 'package:flutter_icons/flutter_icons.dart';


class SearchPageTab extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
  
}

class _HomePageState extends State<SearchPageTab> with AutomaticKeepAliveClientMixin<SearchPageTab> {
  int _currentIndex = 0;
  @override
bool get wantKeepAlive => true;
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

   TabController _tabController ;

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
  
void _handleTabSelection() {
        setState(() {
         });
     }

void savedShow() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        super.build(context);
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
    super.build(context);
    return Stack(
      children: [
        
        Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Color.fromRGBO(61, 131, 255, 1),
              ),
              child: TextField(
                controller: controller,
                decoration: new InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                    suffixIcon: hasSearchEntry
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              controller.clear();
                              bloc.fetchPhoto(controller.text);
                              setState(
                                () {
                                  hasSearchEntry = false;
                                },
                              );
                            },
                          )
                        : SizedBox(),
                    hintText: AppLocalizations.instance.text('search'),),
                onChanged: onSearchTextChanged,
              ),
            ),
            actions: [
              hasSearchEntry
                  ? SizedBox()
                  : IconButton(
                      icon: Icon(LineIcons.group, size: 31.0),
                      padding: EdgeInsets.only(right: 20.0),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchContentPage(),
                          ),
                        );
                      },
                    ),
            ],
          ),
        
        body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.6,
            bottom: TabBar(
              unselectedLabelColor: Colors.black38, // UnSelected Tab Color
              labelColor: Colors.black, 
            
            
              tabs: <Tab> [
                
                Tab(
                  icon: Icon(Feather.camera,
                  ),
                  ),
                Tab(
                  icon: Icon(Feather.video,
                  ),
                  ),
                Tab(
                  icon: Icon(Feather.bar_chart_2,
                  ),
                  ),
              ],
            ),
          ),
          ),
        
          body: TabBarView(
            children: <Widget> [
              _currentIndex == 0 ? SearchTabPhoto() : SearchTabPhoto(),
              _currentIndex == 1 ? SearchTabVideo() : SearchTabVideo(),

Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: <Widget>[
    Icon(Feather.bar_chart_2, size: 42),
    SizedBox(height: 10),
              Center(
               child: Text(
                 AppLocalizations.instance.text('norank'),
                 textAlign: TextAlign.center,
        ),
      ),
    ]
  ),
          
            ],
          ),
        ),
      ),
      
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


  Future onSearchTextChanged(String value) async {
    bloc.fetchPhoto(value);
    setState(() {
      hasSearchEntry = value.isNotEmpty;
    });
  }
}
