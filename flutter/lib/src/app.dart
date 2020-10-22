import 'package:Storyteller/app_localizations.dart';
import 'package:Storyteller/src/dymmy.dart';
import 'package:flutter/material.dart';
import 'ui/bottomNavigation.dart';
import 'package:flutter/services.dart';
import 'blocs/login_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_splash_screen/flutter_splash_screen.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  String _platformVersion = 'Unknown';
  @override
  void initState() {
    super.initState();
    bloc.fetchUserLogin();
    hideScreen();
    initPlatformState();
  }

Future<void> hideScreen() async {
    Future.delayed(Duration(milliseconds: 1), () {
      FlutterSplashScreen.hide();
    });
  }

Future<void> initPlatformState() async {
    String platformVersion;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return MaterialApp(
      supportedLocales: [
        Locale('en', ''),
        Locale('es', ''),
        Locale('fr', ''),
        Locale('it', ''),
        Locale('zh', ''),
        Locale('ru', ''),
        
      ],
      localizationsDelegates: [
         const AppLocalizationsDelegate(),
        RefreshLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode ||
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cardColor: Colors.grey[100],
        brightness: Brightness.light,
        accentColor: Colors.black,
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        canvasColor: Colors.white,
        primaryIconTheme: IconThemeData(
          color: Colors.black,
        ),
        primaryTextTheme: TextTheme(
          headline6:
              TextStyle(color: Colors.black, fontFamily: "SFProDisplayRegular"),
        ),
        textTheme: TextTheme(
          headline6: TextStyle(color: Colors.black),
        ),
      ),
      
      home: Scaffold(
        body: StreamBuilder(
          stream: bloc.getUser,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print("App snapshot == ${snapshot.toString()}");
            if (snapshot.hasError) {
              print("App snapshot.hasError");
              return DummyPage();
            }else if (snapshot.hasData) {
              print("App snapshot.hasData");
              return StoryTellerBottom();
            }else{
              print("App snapshot.hasError");
              return DummyPage();
            }
            // return Center(
            //   child: CircularProgressIndicator(
            //     strokeWidth: 2.0,
            //   ),
            // );
          },
        ),
      ),
    );
  }
}
