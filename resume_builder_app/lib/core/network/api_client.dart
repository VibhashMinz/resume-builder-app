import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  ApiClient({required this.dio});

  Future<Response> post(String url, {Map<String, dynamic>? data}) async {
    return await dio.post(url, data: data);
  }
}
