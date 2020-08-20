import 'package:AniTrack/components/avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AniTrackAppBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AniTrackAppBarState();
}

class _AniTrackAppBarState extends State<AniTrackAppBar> {
  @override
  Widget build(BuildContext context) {
    String query = """
    {
      Viewer {
        name
        statistics {
          anime {
            count
          }
        }
        avatar {
          large
        }
      }
    }
    """;

    return Query(
        options: QueryOptions(documentNode: gql(query)),
        builder: (QueryResult result,
            {FetchMore fetchMore, VoidCallback refetch}) {
          return AppBar(
              title: Image.asset('lib/assets/logo.png', height: 40),
              actions: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    children: [
                      if (result.loading || result.hasException)
                        CircularProgressIndicator()
                      else ...[
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(result.data['Viewer']['name']),
                              Text(
                                "Watched ${result.data['Viewer']['statistics']['anime']['count']}",
                                style: Theme.of(context).textTheme.caption,
                              )
                            ]),
                        SizedBox(width: 5),
                        Avatar(
                          image: Image.network(
                              result.data['Viewer']['avatar']['large'],
                              width: 30),
                        )
                      ]
                    ],
                  ),
                )
              ]);
        });
  }
}
