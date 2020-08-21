class AniListPage {
  List<AniListActivity> activities;
  List<AniListMediaList> mediaList;

  AniListPage.fromJson(Map<String, dynamic> data)
      : activities = List<AniListActivity>.from(
            (data['activities'] ?? []).map((e) => AniListActivity.fromJson(e))),
        mediaList = List<AniListMediaList>.from(
            (data['mediaList'] ?? []).map((e) => AniListMediaList.fromJson(e)));
}

class AniListMediaList {
  AniListMedia media;
  int progress;

  AniListMediaList.fromJson(Map<String, dynamic> data)
      : media = AniListMedia.fromJson(data['media']),
        progress = data['progress'];
}

class AniListActivity {
  static AniListActivity fromJson(Map<String, dynamic> data) {
    switch (data['type']) {
      case 'ANIME_LIST':
      case 'MANGA_LIST':
        return AniListListActivity.fromJson(data);
      default:
        return AniListActivity();
    }
  }
}

class AniListListActivity extends AniListActivity {
  int id;
  String status;
  String progress;
  int createdAt;

  AniListUser user;
  AniListMedia media;

  AniListListActivity.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        status = data['status'],
        progress = data['progress'],
        createdAt = data['createdAt'],
        user = AniListUser.fromJson(data['user'] ?? {}),
        media = AniListMedia.fromJson(data['media'] ?? {});
}

class AniListMedia {
  AniListMediaTitle title;
  AniListMediaCoverImage coverImage;
  int episodes;

  AniListMedia.fromJson(Map<String, dynamic> data)
      : title = AniListMediaTitle.fromJson(data['title'] ?? {}),
        coverImage = AniListMediaCoverImage.fromJson(data['coverImage'] ?? {}),
        episodes = data['episodes'];
}

class AniListMediaTitle {
  String userPreferred;

  AniListMediaTitle.fromJson(Map<String, dynamic> data)
      : userPreferred = data['userPreferred'];
}

class AniListMediaCoverImage {
  String large;

  AniListMediaCoverImage.fromJson(Map<String, dynamic> data)
      : large = data['large'];
}

class AniListUser {
  String name;
  AniListUserAvatar avatar;
  AniListUserStatisticTypes statistics;

  AniListUser.fromJson(Map<String, dynamic> data)
      : name = data['name'],
        avatar = AniListUserAvatar.fromJson(data['avatar'] ?? {}),
        statistics =
            AniListUserStatisticTypes.fromJson(data['statistics'] ?? {});
}

class AniListUserAvatar {
  String large;

  AniListUserAvatar.fromJson(Map<String, dynamic> data) : large = data['large'];
}

class AniListUserStatisticTypes {
  AniListUserStatistics anime;

  AniListUserStatisticTypes.fromJson(Map<String, dynamic> data)
      : anime = AniListUserStatistics.fromJson(data['anime'] ?? {});
}

class AniListUserStatistics {
  int count;

  AniListUserStatistics.fromJson(Map<String, dynamic> data)
      : count = data['count'];
}
