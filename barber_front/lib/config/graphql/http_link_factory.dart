 

import 'package:graphql_flutter/graphql_flutter.dart';

import 'i_link_factory.dart';

class HttpLinkFactory implements ILinkFactory {
  @override
  Link createLink() {
    return HttpLink("https://dashing-drum-19.hasura.app/v1/graphql");
  }
}
