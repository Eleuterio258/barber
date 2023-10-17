import 'package:graphql_flutter/graphql_flutter.dart';

var notifications = gql(
  r''' 

subscription notifications {
  Notifications {
     id
    message
    phone_number
    role
    status
    email
    created_at
    horas_do_registro
  }
}''',
);
