import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLQuery extends StatefulWidget {
  final String queryFile;
  final Widget Function(dynamic data, Function() fetchMore, Refetch reload)
      build;
  final Map<String, dynamic> Function() variables;
  final Widget Function() loading;
  final FetchMoreOptions Function(String query, Map<String, dynamic> variables)
      createFetchOptions;

  const GraphQLQuery(
      {Key key,
      @required this.queryFile,
      @required this.build,
      this.variables,
      this.loading,
      this.createFetchOptions})
      : assert(queryFile != null),
        assert(build != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _GraphQLQueryState(
      queryFile, build, variables, loading, createFetchOptions);
}

class _GraphQLQueryState extends State<GraphQLQuery> {
  final String queryFile;
  final Function(dynamic data, Function() fetchMore, Refetch reload)
      createWidget;
  final Map<String, dynamic> Function() variables;
  final Widget Function() loading;
  final FetchMoreOptions Function(String query, Map<String, dynamic> variables)
      createFetchOptions;

  String query;

  _GraphQLQueryState(this.queryFile, this.createWidget, this.variables,
      this.loading, this.createFetchOptions);

  @override
  void initState() {
    super.initState();

    rootBundle
        .loadString('assets/graphql/$queryFile.graphql')
        .then((value) => setState(() => query = value));
  }

  Map<String, dynamic> get variable =>
      Map<String, dynamic>.from(variables?.call() ?? {});

  @override
  Widget build(BuildContext context) {
    if (query == null) {
      return loading == null
          ? Center(child: CircularProgressIndicator())
          : loading();
    }

    return Query(
        options: QueryOptions(documentNode: gql(query), variables: variable),
        builder: (QueryResult result, {FetchMore fetchMore, Refetch refetch}) {
          if (result.data == null || result.hasException) {
            return loading == null
                ? Center(child: CircularProgressIndicator())
                : loading();
          }

          return createWidget(result.data, () {
            fetchMore(createFetchOptions?.call(query, variable) ??
                FetchMoreOptions(
                    updateQuery: (i, j) => j, variables: variable));
          }, refetch);
        });
  }
}
