import 'package:dio/dio.dart';
import 'models/animal.dart';

class AnimalRepository {
  final Dio _dio;
  AnimalRepository(this._dio);

  Future<List<Animal>> searchAnimals(String query) async {
    if (query.isEmpty) return [];

    final response = await _dio.get(
      '/animals',
      queryParameters: {'name': query.toLowerCase()},
    );

    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((item) => Animal.fromJson(item as Map<String, dynamic>)).toList();
  }
}