import 'package:barber_front/core/local/local_storege/i_local_storege.dart';
import 'package:dio/dio.dart';
 
class AuthInterceptor extends Interceptor {
  final ILocalSecureStorege localStorege;

  AuthInterceptor({required this.localStorege});

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final authRequired = options.extra["auth_required"] ?? false;
    if (authRequired) {
      final token = await localStorege.read("token");
      if (token == null) {
        return handler.reject(DioException(
            requestOptions: options,
            error: "EXPIRED  TOKEN",
            type: DioExceptionType.cancel));
      }
      options.headers["Authorization"] = "Bearer $token";
    } else {
      options.headers.remove("Authorization");
    }

     handler.next(options);
  }


}
