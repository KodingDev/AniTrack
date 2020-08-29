import 'package:AniTrack/api/graphql/graphql.dart';
import 'package:AniTrack/components/navigation.dart';
import 'package:AniTrack/pages/login.dart';
import 'package:AniTrack/util/storage.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

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
  State<StatefulWidget> createState() => _MainPageState(oauth);
}

class _MainPageState extends State<MainPage> {
  int _index = 0;
  final List<_NavigationEntry> _entries = [
    _NavigationEntry(label: 'Feed', icon: Icons.list, widget: FeedPage()),
    _NavigationEntry(label: 'Home', icon: Icons.house, widget: FeedPage()),
  ];

  final OAuth2Helper oauth;

  ValueNotifier client;
  bool needsLogin = false;

  @override
  void initState() {
    super.initState();
    clearSecureStorageOnReinstall().then((_) {
      oauth.getTokenFromStorage().then((v) {
        setState(() {
          if (v == null) {
            needsLogin = true;
            return;
          }

          client = createClient(oauth);
        });
      });
    });
  }

  _MainPageState(this.oauth);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height / 1.18;
    final width = size.width / 1.18;

    ResponsiveWidgets.init(context,
        width: width, height: height, allowFontScaling: true);

    if (needsLogin) {
      return ResponsiveWidgets.builder(
          height: height,
          width: width,
          allowFontScaling: true,
          child: Scaffold(
              body: LoginPage(
                  helper: oauth,
                  callback: () {
                    setState(() {
                      needsLogin = false;
                      client = createClient(oauth);
                    });
                  })));
    }

    if (client == null) {
      return ResponsiveWidgets.builder(
          height: height,
          width: width,
          allowFontScaling: true,
          child: Scaffold(body: Center(child: CircularProgressIndicator())));
    }

    return ResponsiveWidgets.builder(
        height: height,
        width: width,
        allowFontScaling: true,
        child: GraphQLProvider(
            client: client,
            child: Scaffold(
              appBar: PreferredSize(
                  child: AniTrackAppBar(), preferredSize: Size.fromHeight(50)),
              body: _entries[_index].widget,
              bottomNavigationBar: BottomNavigationBar(
                selectedFontSize: 12,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.white,
                items: _entries
                    .map((e) => BottomNavigationBarItem(
                        title: Text(e.label), icon: Icon(e.icon)))
                    .toList(),
                currentIndex: _index,
                onTap: (value) => setState(() => _index = value),
              ),
            )));
  }
}
