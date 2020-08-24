import 'package:AniTrack/api/graphql/models.dart';
import 'package:AniTrack/api/graphql/queries.dart';
import 'package:AniTrack/components/image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AniTrackAppBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AniTrackAppBarState();
}

class _AniTrackAppBarState extends State<AniTrackAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(title: Image.asset('assets/logo.png', height: 40), actions: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: GraphQLQuery(
          queryFile: 'appbar',
          loading: () => CircularProgressIndicator(),
          build: (data, _) {
            var user = AniListUser.fromJson(data['Viewer']);
            return Row(
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(user.name),
                      Text(
                        'Watched ${user.statistics.anime.count}',
                        style: Theme.of(context).textTheme.caption,
                      )
                    ]),
                SizedBox(width: 5),
                Avatar(
                  image: Image.network(user.avatar.large, width: 30),
                )
              ],
            );
          },
        ),
      )
    ]);
  }
}
