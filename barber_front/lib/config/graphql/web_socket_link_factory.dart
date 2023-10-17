import 'package:barber_front/config/graphql/i_link_factory.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class WebSocketLinkFactory implements ILinkFactory {
  @override
  Link createLink() {
    final webSocketLink = WebSocketLink(
      'ws://dashing-drum-19.hasura.app/v1/graphql',
      config: const SocketClientConfig(
          autoReconnect: true,
          inactivityTimeout: Duration(seconds: 30),
          headers: {
            'x-hasura-admin-secret':
                'R2aWiqkU8S4QisDhm639ZlbOPdedfTlN0eN5BnSBWsKgJ8El7UiBbFODX2PZFV9y',
          }),
    );

    return webSocketLink;
  }
}
