import 'package:barber_front/core/rest_client/rest_client_response.dart';
 
class RestClientException implements Exception {
  String? message;
  int? statusCode;
  dynamic error;
  RestClientResponse response;

  RestClientException({
    this.message,
    this.statusCode,
    required this.error,
    required this.response,
  });

 @override
  String toString() {
    return 'RestClientException: $message\nStatus Code: $statusCode\nError: $error';
  }
}
