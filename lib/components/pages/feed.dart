import 'package:AniTrack/api/graphql/models.dart';
import 'package:AniTrack/components/container.dart';
import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:transparent_image/transparent_image.dart';

import '../image.dart';
import '../../util/text.dart';
import '../text.dart';

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
                  flex: 3,
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: activity.media.coverImage.large,
                    fit: BoxFit.cover,
                    width: 85,
                    height: 120,
                  )),

              // Spacer
              SizedBoxResponsive(width: 5),

              // Right content
              Expanded(
                  flex: 8,
                  child: ContainerResponsive(
                      padding: EdgeInsetsResponsive.symmetric(horizontal: 5),
                      child: SimpleColumn(
                        [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Avatar(
                                  image: ContainerResponsive(
                                      height: 20,
                                      width: 20,
                                      child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: activity.user.avatar.large,
                                          fit: BoxFit.cover,
                                          width: 20,
                                          height: 20))),
                              SizedBoxResponsive(width: 5),
                              TextResponsive(
                                activity.user.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(color: Color(0xFF27b3fd)),
                              ),
                              SizedBoxResponsive(width: 5),
                              TextResponsive(
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
                          SizedBoxResponsive(height: 5),
                          RichText(
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textScaleFactor:
                                  MediaQuery.textScaleFactorOf(context).sp,
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

    return ContainerResponsive(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ContainerResponsive(
          padding: EdgeInsetsResponsive.symmetric(horizontal: 13, vertical: 7),
          child: SimpleColumn([
            SmallHeadingText('In Progress'),
            SubtitleText('Shows you\'re currently loving!')
          ])),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBoxResponsive(width: 10),
            for (AniListMediaList item in media)
              ContainerResponsive(
                  height: 100,
                  width: 200,
                  child: FeedMediaProgress(media: item)),
            if (media.isEmpty)
              ContainerResponsive(
                  height: 100,
                  width: 200,
                  child: FeedLoadingCard(
                    heading: 'Uh oh!',
                    subtitle: 'Looks like you\'re not watching any anime!',
                  )),
            SizedBoxResponsive(width: 10),
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
                  flex: 3,
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: media.media.coverImage.large,
                    fit: BoxFit.cover,
                    width: 85,
                    height: 130,
                  )),

              // Spacer
              SizedBoxResponsive(width: 5),

              // Right content
              Expanded(
                  flex: 3,
                  child: ContainerResponsive(
                      padding: EdgeInsetsResponsive.all(7),
                      child: SimpleColumn(
                        [
                          TextResponsive(
                            media.media.title.userPreferred,
                            style: Theme.of(context).textTheme.button.copyWith(
                                color: Colors.grey.shade300, fontSize: 14),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          TextResponsive(
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
  final String heading;
  final String subtitle;

  const FeedLoadingCard(
      {Key key, @required this.heading, @required this.subtitle})
      : assert(heading != null),
        assert(subtitle != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: RoundedContainer(
            radius: BorderRadius.circular(3.0),
            child: Row(children: [
              Flexible(
                  flex: 3,
                  child: Container(
                      padding: EdgeInsetsResponsive.symmetric(horizontal: 10),
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.contain,
                        width: 65,
                        height: 120,
                      ))),
              // Cover image on the left
              // Flexible(
              //     flex: 3,
              //     child: Center(
              //         child:
              //             Image.asset('assets/logo.png', fit: BoxFit.contain))),

              // Spacer
              SizedBoxResponsive(width: 5),

              // Right content
              Expanded(
                  flex: 3,
                  child: ContainerResponsive(
                      padding: EdgeInsetsResponsive.only(right: 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Spacer(),
                          TextResponsive(
                            heading,
                            style: Theme.of(context).textTheme.button.copyWith(
                                color: Colors.grey.shade300, fontSize: 14),
                          ),
                          TextResponsive(
                            subtitle,
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

class FeedTrendingHeader extends StatelessWidget {
  final List<AniListMedia> media;

  const FeedTrendingHeader({Key key, @required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContainerResponsive(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ContainerResponsive(
          padding: EdgeInsetsResponsive.symmetric(horizontal: 3, vertical: 7),
          child: SimpleColumn([
            SmallHeadingText('Trending'),
            SubtitleText('Most popular media across the platform!')
          ])),
      if (media.isEmpty)
        ContainerResponsive(
            height: 100,
            width: 200,
            child: FeedLoadingCard(
              heading: 'Hey!',
              subtitle: 'We\'re fetching the trending data. Hold on!',
            )),
      ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: media.length,
        itemBuilder: (context, index) => ContainerResponsive(
            height: 100,
            width: 200,
            child: FeedMediaTrending(media: media[index])),
      )
    ]));
  }
}

class FeedMediaTrending extends StatelessWidget {
  final AniListMedia media;

  const FeedMediaTrending({Key key, @required this.media})
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
                  flex: 3,
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: media.coverImage.large,
                    fit: BoxFit.cover,
                    width: 85,
                    height: 130,
                  )),

              // Spacer
              SizedBoxResponsive(width: 5),

              // Right content
              Expanded(
                  flex: 8,
                  child: ContainerResponsive(
                      padding: EdgeInsetsResponsive.all(7),
                      child: SimpleColumn(
                        [
                          TextResponsive(
                            '${media.trending} recently watched',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                    color: Color(0xFF27b3fd), fontSize: 12),
                          ),
                          TextResponsive(
                            media.title.userPreferred,
                            style: Theme.of(context).textTheme.button.copyWith(
                                color: Colors.grey.shade300, fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          TextResponsive(
                            '${media.format} | ${media.status.replaceAll("_", " ").toLowerCase().capitalize()}',
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
