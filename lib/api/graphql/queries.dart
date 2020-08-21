import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLQuery extends StatefulWidget {
  final String queryFile;
  final Widget Function(dynamic) build;
  final Map<String, dynamic> variables;
  final Widget Function() loading;

  const GraphQLQuery(
      {Key key,
      @required this.queryFile,
      @required this.build,
      this.variables = const {},
      this.loading})
      : assert(queryFile != null),
        assert(build != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _GraphQLQueryState(queryFile, build, variables, loading);
}

class _GraphQLQueryState extends State<GraphQLQuery> {
  final String queryFile;
  final Widget Function(dynamic) createWidget;
  final Map<String, dynamic> variables;
  final Widget Function() loading;

  String query;

  _GraphQLQueryState(this.queryFile, this.createWidget, this.variables, this.loading);

  @override
  void initState() {
    super.initState();

    rootBundle
        .loadString('assets/graphql/$queryFile.graphql')
        .then((value) => setState(() => query = value));
  }

  @override
  Widget build(BuildContext context) {
    if (query == null) {
      return loading == null ? Center(child: CircularProgressIndicator()) : loading();
    }

    return Query(
        options: QueryOptions(documentNode: gql(query), variables: variables),
        builder: (QueryResult result,
            {FetchMore fetchMore, VoidCallback refetch}) {
          if (result.loading || result.hasException) {
            return loading == null ? Center(child: CircularProgressIndicator()) : loading();
          }

          return createWidget(result.data);
        });
  }
}
