import 'package:barber_front/core/local/local_storege/i_local_storege.dart';
import 'package:barber_front/core/rest_client/dio/auth_interceptor.dart';
import 'package:barber_front/core/rest_client/rest_client.dart';
import 'package:barber_front/core/rest_client/rest_client_exception.dart';
import 'package:barber_front/core/rest_client/rest_client_response.dart';
import 'package:dio/dio.dart';
 

import '../../di/di.dart';

class DioRestClient implements RestClient {
  late final Dio _dio;

  final _defaultOptions = BaseOptions(
    baseUrl: "http://192.168.1.100:5000",
    connectTimeout: const Duration(milliseconds: 5000),
    receiveTimeout: const Duration(milliseconds: 3000),
  );

  DioRestClient(
      {required ILocalSecureStorege localStorege, BaseOptions? baseOptions}) {
    _dio = Dio(baseOptions ?? _defaultOptions);
    _dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
      AuthInterceptor(localStorege: getIt())
    ]);
  }
  @override
  RestClient auth() {
    _defaultOptions.extra['auth_required'] = true;
    return this;
  }

  @override
  RestClient unauth() {
    _defaultOptions.extra['auth_required'] = false;
    return this;
  }

  @override
  Future<RestClientResponse<T>> delete<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? header}) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: header),
      );
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _throwRestClientException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? header,
  }) async {
    try {
      final response = await _dio.get(path,
          queryParameters: queryParameters,
          options: Options(
            headers: header,
          ));
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _throwRestClientException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> patch<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? header,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: header),
      );
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _throwRestClientException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> post<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? header}) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: header),
      );
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _throwRestClientException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> put<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? header}) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: header),
      );
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _throwRestClientException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> request<T>(
    String path, {
    required String method,
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? header,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: header, method: method),
      );
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _throwRestClientException(e);
    }
  }

  Future<RestClientResponse<T>> _dioResponseConverter<T>(
      Response<dynamic> response) async {
    return RestClientResponse<T>(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
    );
  }

  Never _throwRestClientException(DioException dioException) {
    final response = dioException.response;

    throw RestClientException(
      error: dioException.error,
      message: response?.statusMessage,
      statusCode: response?.statusCode,
      response: RestClientResponse(
        data: response?.data,
        statusMessage: response?.statusMessage,
        statusCode: response?.statusCode,
      ),
    );
  }
}
