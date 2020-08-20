import 'package:AniTrack/api/graphql/models.dart';
import 'package:AniTrack/components/pages/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final String query = """
  {
    Viewer {
      id
    }
    Page(page: 1, perPage: 25) {
      activities(
        isFollowing: true, 
        hasRepliesOrTypeText: false, 
        type_in: [ANIME_LIST, MANGA_LIST], 
        sort: ID_DESC
      ) {
        ... on ListActivity {
          id
          type
          status
          progress
          createdAt
          user {
            name
            avatar {
              large
            }
          }
          media {
            title {
              userPreferred
            }
            coverImage {
              large
            }
          }
        }
      }
    }
  }
  """;

  final String headerQuery = """
  query Query(\$id: Int) {
    Page(page: 1, perPage: 25) {
      mediaList(userId: \$id, status_in: [CURRENT, REPEATING]) {
        media {
          episodes
          title {
            userPreferred
          }
          coverImage {
            large
          }
        }
        progress
      }
    }
  }
  """;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(documentNode: gql(query)),
      builder: (QueryResult result,
          {FetchMore fetchMore, VoidCallback refetch}) {
        if (result.loading || result.hasException) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
            child: Column(children: [
          Query(
              options: QueryOptions(
                  documentNode: gql(headerQuery),
                  variables: {"id": result.data['Viewer']['id']}),
              builder: (QueryResult result,
                  {FetchMore fetchMore, VoidCallback refetch}) {
                var media = result.loading
                    ? []
                    : AniListPage.fromJson(result.data['Page']).mediaList;
                media.sort((i, j) => i.progress.compareTo(j.progress));

                return Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Text("In Progress",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(color: Colors.grey.shade200))),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                SizedBox(width: 12),
                                for (AniListMediaList item in media)
                                  Container(
                                      constraints: BoxConstraints(
                                          maxHeight: 100, maxWidth: 200),
                                      child: FeedInProgress(media: item)),
                                if (media.length == 0 ||
                                    result.loading ||
                                    result.hasException)
                                  Container(
                                      constraints: BoxConstraints(
                                          maxHeight: 100, maxWidth: 200),
                                      child: LoadingFeed()),
                                SizedBox(width: 12),
                              ],
                            ),
                          )
                        ]));
              }),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: Text("Activity",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(color: Colors.grey.shade200))),
                    for (AniListListActivity activity
                        in AniListPage.fromJson(result.data['Page']).activities)
                      FeedItem(activity: activity)
                  ]))
        ]));
      },
    );
  }
}
