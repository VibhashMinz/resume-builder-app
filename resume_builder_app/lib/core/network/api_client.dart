import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient({required this.dio}) {
    dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }

  Future<Response> get(String url, {Map<String, dynamic>? queryParams}) async {
    try {
      return await dio.get(url, queryParameters: queryParams);
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  Future<Response> post(
    String url, {
    Map<String, dynamic>? data,
    String? token, // For Authorization
  }) async {
    try {
      return await dio.post(
        url,
        data: data,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : {},
        ),
      );
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }
}
