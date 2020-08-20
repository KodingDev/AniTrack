import 'package:AniTrack/api/graphql/models.dart';
import 'package:AniTrack/components/container.dart';
import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../avatar.dart';
import '../../util/text.dart';

class FeedItem extends StatelessWidget {
  final AniListListActivity activity;

  const FeedItem({Key key, @required this.activity})
      : assert(activity != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: RoundedContainer(
            radius: BorderRadius.circular(3.0),
            child: Row(children: [
              // Cover image on the left
              Flexible(
                  flex: 2,
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: activity.media.coverImage.large,
                    fit: BoxFit.cover,
                    height: 100,
                    width: 80,
                  )),
              // Spacer
              SizedBox(width: 5),

              // Right content
              Expanded(
                  flex: 8,
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Avatar(
                                  image: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: activity.user.avatar.large,
                                fit: BoxFit.cover,
                                height: 20,
                                width: 20,
                              )),
                              SizedBox(width: 5),
                              Text(
                                activity.user.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(color: Color(0xFF27b3fd)),
                              ),
                              SizedBox(width: 5),
                              Text(
                                  prettyDuration(
                                          Duration(
                                              seconds: DateTime.now()
                                                          .millisecondsSinceEpoch ~/
                                                      1000 -
                                                  activity.createdAt),
                                          tersity: DurationTersity.all,
                                          first: true) +
                                      " ago",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          color: Colors.grey.shade300,
                                          fontSize: 11))
                            ],
                          ),
                          SizedBox(height: 5),
                          RichText(
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          color: Colors.grey.shade300,
                                          fontSize: 12),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "${activity.status.capitalize()} " +
                                            "${activity.progress == null ? "" : "${activity.progress} of "}"),
                                    TextSpan(
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                color: Color(0xFF27b3fd),
                                                fontSize: 12),
                                        text:
                                            activity.media.title.userPreferred),
                                  ]))
                        ],
                      )))
            ])));
  }
}

class FeedInProgress extends StatelessWidget {
  final AniListMediaList media;

  const FeedInProgress({Key key, @required this.media})
      : assert(media != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: RoundedContainer(
            radius: BorderRadius.circular(3.0),
            child: Row(children: [
              // Cover image on the left
              Flexible(
                  flex: 2,
                  child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: media.media.coverImage.large,
                      fit: BoxFit.cover,
                      width: 65,
                      height: 110)),

              // Spacer
              SizedBox(width: 5),

              // Right content
              Expanded(
                  flex: 3,
                  child: Container(
                      padding: EdgeInsets.all(7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            media.media.title.userPreferred,
                            style: Theme.of(context).textTheme.button.copyWith(
                                color: Colors.grey.shade300, fontSize: 14),
                          ),
                          Spacer(),
                          Text(
                            "Progress: ${media.progress}/${media.media.episodes}",
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: Colors.grey),
                          )
                        ],
                      )))
            ])));
  }
}

class LoadingFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: RoundedContainer(
            radius: BorderRadius.circular(3.0),
            child: Row(children: [
              // Cover image on the left
              Flexible(
                  flex: 2,
                  child: Center(child: Image.asset("lib/assets/logo.png",
                      fit: BoxFit.contain, width: 60))),

              // Spacer
              SizedBox(width: 5),

              // Right content
              Expanded(
                  flex: 3,
                  child: Container(
                      padding: EdgeInsets.only(right: 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Spacer(),
                          Text(
                            "Uh oh!",
                            style: Theme.of(context).textTheme.button.copyWith(
                                color: Colors.grey.shade300, fontSize: 14),
                          ),
                          Text(
                            "Looks like you're not watching any anime!",
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: Colors.grey),
                          ),
                          Spacer()
                        ],
                      )))
            ])));
  }
}
