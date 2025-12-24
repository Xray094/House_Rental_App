import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:house_rental_app/core/config/di.dart';

class ApiService extends GetxService {
  late Dio dio;

  @override
  void onInit() {
    super.onInit();
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
        },
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final box = GetStorage();
          final String? token = box.read('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            print("Unauthorized: Token might be expired.");
          }
          return handler.next(e);
        },
      ),
    );
    dio.interceptors.add(LoggingInterceptor());
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("🚀 REQUEST: ${options.method} ${options.uri}");
    if (options.data != null) print("📄 Data: ${options.data}");
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}");
    String dataStr = response.data.toString();
    print(
      "📊 Data: ${dataStr.length > 2000 ? '${dataStr.substring(0, 2000)}...' : dataStr}",
    );
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
      "❌ ERROR: ${err.type} ${err.response?.statusCode} ${err.requestOptions.uri}",
    );
    print("🚫 Message: ${err.message}");
    return handler.next(err);
  }
}
