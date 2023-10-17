 

import 'package:barber_front/core/di/di.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'i_link_factory.dart';

class GraphQLSetup {
  
  static GraphQLClient getClient() {
    final httpLinkFactory =getIt<ILinkFactory>(instanceName: 'http');
    final webSocketLinkFactory =
        getIt<ILinkFactory>(instanceName: 'websocket');

    final httpLink = httpLinkFactory.createLink();
    final webSocketLink = webSocketLinkFactory.createLink();

    Link link = Link.split(
        (request) => request.isSubscription, webSocketLink, httpLink);

    return GraphQLClient(cache: GraphQLCache(), link: link);
  }
}
