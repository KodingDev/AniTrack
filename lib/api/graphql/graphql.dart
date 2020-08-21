import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:oauth2_client/oauth2_helper.dart';

ValueNotifier<GraphQLClient> createClient(OAuth2Helper helper) {
  final httpLink = HttpLink(uri: 'https://graphql.anilist.co');
  final authLink = AuthLink(
    getToken: () async => 'Bearer ${(await helper.getToken()).accessToken}',
  );
  final link = authLink.concat(httpLink);

  return ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    ),
  );
}
