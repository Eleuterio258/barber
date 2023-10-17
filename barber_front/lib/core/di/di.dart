import 'package:barber_front/domain/repositories/firestore/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../config/graphql/graphql_setup.dart';
import '../../config/graphql/http_link_factory.dart';
import '../../config/graphql/i_link_factory.dart';
import '../../config/graphql/web_socket_link_factory.dart';
import '../../domain/repositories/firestore/i_file_storage.dart';
 import '../push_notification/firebase_messaging_service.dart';
import '../rest_client/dio/dio_rest_client.dart';
import '../rest_client/rest_client.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  //REGISTER BLOC

  // getIt.registerFactory(() => AuthCubit(authRepository: getIt()));

  getIt.registerSingleton<RestClient>(DioRestClient(localStorege: getIt()));

  getIt.registerSingleton<ILinkFactory>(HttpLinkFactory(),
      instanceName: 'http');
  getIt.registerSingleton<ILinkFactory>(WebSocketLinkFactory(),
      instanceName: 'websocket');
  getIt.registerSingleton<GraphQLSetup>(GraphQLSetup());
  getIt.registerSingleton<GraphQLClient>(GraphQLSetup.getClient());

  //EXTERNAL
  final messaging = FirebaseMessaging.instance;
  final firebase = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;

  getIt.registerSingleton(messaging);
  getIt.registerSingleton(firebase);
  getIt.registerSingleton(firebaseStorage);
 

  getIt.registerSingleton<FirebaseMessagingService>(
      FirebaseMessagingService(getIt()));

  getIt.registerSingleton<IFileStorage>(FirebaseStorageService(
    firebaseStorage: getIt(),
  ));
}
