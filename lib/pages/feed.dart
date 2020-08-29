import 'package:AniTrack/api/graphql/models.dart';
import 'package:AniTrack/api/graphql/queries.dart';
import 'package:AniTrack/components/container.dart';
import 'package:AniTrack/components/pages/feed.dart';
import 'package:AniTrack/components/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_responsive/flutter_responsive.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

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
      build: (data, fetchMore, reload) {
        var activities = AniListPage.fromJson(data['Page']).activities;
        return RefreshIndicator(
            backgroundColor: Colors.transparent,
            onRefresh: () async {
              page = 1;
              return await reload();
            },
            child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notif) {
                  if (!fetching &&
                      notif.metrics.pixels >= notif.metrics.maxScrollExtent) {
                    page++;
                    fetching = true;
                    fetchMore();
                  }
                  return;
                },
                child: SingleChildScrollView(
                    child: OrientationBuilder(
                        builder: (context, orientation) => Container(
                            padding: orientation == Orientation.portrait &&
                                    MediaQuery.of(context).size.width < 500
                                ? EdgeInsetsResponsive.zero
                                : EdgeInsetsResponsive.only(
                                    top: 30, left: 40, right: 40),
                            child: SimpleColumn([
                              ResponsiveRow(children: [
                                ResponsiveCol(gridSizes: {
                                  'sm': 12,
                                  'lg': 8
                                }, children: [
                                  ContainerResponsive(
                                      padding: EdgeInsetsResponsive.symmetric(
                                          horizontal: 10),
                                      child: SimpleColumn(
                                        [
                                          ContainerResponsive(
                                              padding: EdgeInsetsResponsive
                                                  .symmetric(
                                                      horizontal: 3,
                                                      vertical: 5),
                                              child: SimpleColumn([
                                                SmallHeadingText('Activity'),
                                                SubtitleText(
                                                    'Let\'s see what everyone is watching!')
                                              ])),
                                          ResponsiveRow(
                                            children: List.generate(
                                                activities.length,
                                                (index) =>
                                                    ResponsiveCol(gridSizes: {
                                                      'sm': 12,
                                                      'md': 6,
                                                    }, children: [
                                                      FeedActivityMedia(
                                                          activity:
                                                              activities[index])
                                                    ])),
                                          )
                                        ],
                                      )),
                                ]),
                                ResponsiveCol(
                                  gridSizes: {
                                    'sm': 0,
                                    'lg': 4,
                                  },
                                  padding: EdgeInsetsResponsive.only(left: 20),
                                  children: [
                                    ContainerResponsive(
                                        child: GraphQLQuery(
                                      queryFile: 'media_list',
                                      variables: () =>
                                          {'id': data['Viewer']['id']},
                                      loading: () =>
                                          FeedProgressHeader(media: []),
                                      build: (data, fetchMore, reload) =>
                                          FeedProgressHeader(
                                              media: AniListPage.fromJson(
                                                      data['Page'])
                                                  .mediaList),
                                    )),
                                    ContainerResponsive(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: GraphQLQuery(
                                          queryFile: 'trending',
                                          variables: () =>
                                              {'id': data['Viewer']['id']},
                                          loading: () =>
                                              FeedTrendingHeader(media: []),
                                          build: (data, fetchMore, reload) =>
                                              FeedTrendingHeader(
                                                  media: AniListPage.fromJson(
                                                          data['Trending'])
                                                      .media),
                                        ))
                                  ],
                                ),
                                if (fetching)
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ContainerResponsive(
                                            padding:
                                                EdgeInsetsResponsive.all(30),
                                            width: 100,
                                            height: 100,
                                            child: CircularProgressIndicator())
                                      ])
                              ])
                            ]))))));
      },
    );
  }
}
