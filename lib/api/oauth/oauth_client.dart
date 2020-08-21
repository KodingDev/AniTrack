import 'package:flutter/material.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

class AniListClient extends OAuth2Client {
  AniListClient(
      {@required String redirectUri, @required String customUriScheme})
      : super(
            authorizeUrl: 'https://anilist.co/api/v2/oauth/authorize',
            tokenUrl: 'https://anilist.co/api/v2/oauth/token',
            redirectUri: redirectUri,
            customUriScheme: customUriScheme);
}

OAuth2Helper createHelper() {
  var client = AniListClient(
      customUriScheme: 'anitrack', redirectUri: 'anitrack://oauth2');
  return OAuth2Helper(
    client,
    grantType: OAuth2Helper.IMPLICIT_GRANT,
    clientId: '3942',
  );
}
