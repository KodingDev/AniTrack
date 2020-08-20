import 'package:AniTrack/api/oauth/oauth_client.dart';
import 'package:AniTrack/pages/main.dart';
import 'package:flutter/material.dart';

import 'package:oauth2_client/oauth2_helper.dart';

void main() {
  runApp(AniTrack());
}

class AniTrack extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AniTrackState();
}

class _AniTrackState extends State<AniTrack> {
  OAuth2Helper oauth;

  @override
  void initState() {
    super.initState();
    oauth = createHelper();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AniTrack',
      theme: ThemeData(
          accentColor: Color(0xFF222435),
          appBarTheme: AppBarTheme(color: Color(0xFF222435)),
          cardColor: Color(0xFF1a1c1e),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              backgroundColor: Color(0xFF11161d),
              type: BottomNavigationBarType.fixed),
          brightness: Brightness.dark),
      home: MainPage(oauth: oauth),
      debugShowCheckedModeBanner: false,
    );
  }
}
