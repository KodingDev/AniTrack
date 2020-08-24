import 'package:AniTrack/api/graphql/models.dart';
import 'package:AniTrack/api/graphql/queries.dart';
import 'package:AniTrack/components/pages/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_grid/responsive_grid.dart';

class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return GraphQLQuery(
      queryFile: 'feed',
      build: (data) {
        var activities = AniListPage.fromJson(data['Page']).activities;
        return ListView(children: [
          GraphQLQuery(
            queryFile: 'media_list',
            variables: {'id': data['Viewer']['id']},
            loading: () => FeedProgressHeader(media: []),
            build: (data) => FeedProgressHeader(
                media: AniListPage.fromJson(data['Page']).mediaList),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Text('Activity',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(color: Colors.grey.shade200))),
                ResponsiveGridRow(
                  children: List.generate(
                      activities.length,
                      (index) => ResponsiveGridCol(
                          sm: 12,
                          md: 6,
                          lg: 4,
                          child:
                              FeedActivityMedia(activity: activities[index]))),
                )
              ],
            ),
          )
        ]);
      },
    );
  }
}
