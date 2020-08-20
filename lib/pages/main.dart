import 'package:AniTrack/api/graphql/graphql.dart';
import 'package:AniTrack/components/appbar.dart';
import 'package:AniTrack/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:oauth2_client/oauth2_helper.dart';

import 'feed.dart';

class _NavigationEntry {
  final String label;
  final IconData icon;
  final Widget widget;

  _NavigationEntry(
      {@required this.label, @required this.icon, @required this.widget})
      : assert(label != null),
        assert(icon != null),
        assert(widget != null);
}

class MainPage extends StatefulWidget {
  final OAuth2Helper oauth;

  const MainPage({Key key, @required this.oauth})
      : assert(oauth != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState(this.oauth);
}

class _MainPageState extends State<MainPage> {
  int _index = 0;
  final List<_NavigationEntry> _entries = [
    _NavigationEntry(label: "Feed", icon: Icons.list, widget: FeedPage()),
    _NavigationEntry(label: "Home", icon: Icons.house, widget: FeedPage()),
  ];

  final OAuth2Helper oauth;

  ValueNotifier client;
  Widget body;
  bool needsLogin = false;

  void initState() {
    super.initState();
    oauth.getTokenFromStorage().then((v) {
      setState(() {
        if (v == null) {
          needsLogin = true;
          return;
        }

        client = createClient(oauth);
        body = _entries[_index].widget;
      });
    });
  }

  _MainPageState(this.oauth);

  @override
  Widget build(BuildContext context) {
    if (needsLogin) {
      return Scaffold(
          body: LoginPage(
              helper: oauth,
              callback: () {
                setState(() {
                  needsLogin = false;
                  client = createClient(oauth);
                  body = _entries[_index].widget;
                });
              }));
    }

    if (body == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return GraphQLProvider(
        client: client,
        child: Scaffold(
          appBar: body != null
              ? PreferredSize(
                  child: AniTrackAppBar(), preferredSize: Size.fromHeight(50))
              : null,
          body: body ?? CircularProgressIndicator(),
          bottomNavigationBar: body != null
              ? BottomNavigationBar(
                  selectedFontSize: 12,
                  selectedItemColor: Colors.blue,
                  unselectedItemColor: Colors.white,
                  items: _entries
                      .map((e) => BottomNavigationBarItem(
                          label: e.label, icon: Icon(e.icon)))
                      .toList(),
                  currentIndex: _index,
                  onTap: (value) => setState(() => _index = value),
                )
              : null,
        ));
  }
}
