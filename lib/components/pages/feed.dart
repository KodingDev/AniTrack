import 'package:AniTrack/api/graphql/models.dart';
import 'package:AniTrack/components/container.dart';
import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../image.dart';
import '../../util/text.dart';

class FeedActivityMedia extends StatelessWidget {
  final AniListListActivity activity;

  const FeedActivityMedia({Key key, @required this.activity})
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
                                      ' ago',
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
                                        text: '${activity.status.capitalize()} '
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

class FeedProgressHeader extends StatelessWidget {
  final List<AniListMediaList> media;

  const FeedProgressHeader({Key key, @required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    media.sort((i, j) => j.progress.compareTo(i.progress));

    return Container(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Text('In Progress',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: Colors.grey.shade200))),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: 10),
            for (AniListMediaList item in media)
              Container(
                  constraints: BoxConstraints(maxHeight: 100, maxWidth: 200),
                  child: FeedMediaProgress(media: item)),
            if (media.isEmpty)
              Container(
                  constraints: BoxConstraints(maxHeight: 100, maxWidth: 200),
                  child: FeedLoadingCard()),
            SizedBox(width: 10),
          ],
        ),
      )
    ]));
  }
}

class FeedMediaProgress extends StatelessWidget {
  final AniListMediaList media;

  const FeedMediaProgress({Key key, @required this.media})
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
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          Text(
                            'Progress: ${media.progress}/${media.media.episodes}',
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

class FeedLoadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: RoundedContainer(
            radius: BorderRadius.circular(3.0),
            child: Row(children: [
              // Cover image on the left
              Flexible(
                  flex: 2,
                  child: Center(
                      child: Image.asset('assets/logo.png',
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
                            'Uh oh!',
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
