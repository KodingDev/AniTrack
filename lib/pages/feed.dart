import 'package:AniTrack/api/graphql/models.dart';
import 'package:AniTrack/api/graphql/queries.dart';
import 'package:AniTrack/components/pages/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:responsive_grid/responsive_grid.dart';

class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool fetching = false;
  int page = 1;

  @override
  Widget build(BuildContext context) {
    return GraphQLQuery(
      queryFile: 'feed',
      variables: () => {'page': page},
      createFetchOptions: (query, variables) => FetchMoreOptions(
          variables: variables,
          updateQuery: (previousResultData, fetchMoreResultData) {
            fetching = false;
            fetchMoreResultData['Page']['activities'] = <dynamic>[
              ...previousResultData['Page']['activities'],
              ...fetchMoreResultData['Page']['activities']
            ];
            return fetchMoreResultData;
          }),
      build: (data, fetchMore) {
        var activities = AniListPage.fromJson(data['Page']).activities;
        return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notif) {
              if (!fetching &&
                  notif.metrics.pixels >= notif.metrics.maxScrollExtent) {
                page++;
                fetching = true;
                fetchMore();
              }
              return;
            },
            child: ListView(children: [
              GraphQLQuery(
                queryFile: 'media_list',
                variables: () => {'id': data['Viewer']['id']},
                loading: () => FeedProgressHeader(media: []),
                build: (data, _) => FeedProgressHeader(
                    media: AniListPage.fromJson(data['Page']).mediaList),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                              child: FeedActivityMedia(
                                  activity: activities[index]))),
                    ),
                    if (fetching)
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator())
                          ])
                  ],
                ),
              )
            ]));
      },
    );
  }
}
