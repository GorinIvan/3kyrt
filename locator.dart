import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'interceptors/api_key_interceptor.dart';
import 'data/cart_service.dart';
import 'data/animal_repository.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<CartService>(() => CartService());

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://api.api-ninjas.com/v1',
    ));

    dio.interceptors.add(ApiKeyInterceptor('DAtj4CxssfTMurdqbs3Fe4KclqkECgatI9MaDDnR')); 
    
    dio.interceptors.add(PrettyDioLogger(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      compact: true,
    ));

    return dio;
  });

  getIt.registerLazySingleton<AnimalRepository>(
    () => AnimalRepository(getIt<Dio>()),
  );
}