import 'package:dio/dio.dart';
import '../models/post.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
  }

  // Метод для получения данных с API
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await _dio.get('/posts?_limit=20');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Обработка ошибок HTTP-запроса
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Превышено время ожидания ответа от сервера');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Нет подключения к интернету');
      } else if (e.response != null) {
        throw Exception('Ошибка сервера: ${e.response?.statusCode}');
      } else {
        throw Exception('Произошла ошибка: ${e.message}');
      }
    } catch (e) {
      throw Exception('Неизвестная ошибка: $e');
    }
  }
}
