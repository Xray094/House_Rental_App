// import 'dart:io';
// import 'package:dio/dio.dart' as DioPackage;
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:house_rental_app/core/config/di.dart';

// /// Enhanced API Service with sophisticated error handling and retry logic
// class EnhancedApiService extends GetxService {
//   late DioPackage.Dio dio;
//   static const int maxRetries = 3;
//   static const Duration retryDelay = Duration(seconds: 2);

//   @override
//   void onInit() {
//     super.onInit();
//     dio = DioPackage.Dio(
//       DioPackage.BaseOptions(
//         baseUrl: baseUrl,
//         connectTimeout: const Duration(seconds: 30),
//         receiveTimeout: const Duration(seconds: 30),
//         sendTimeout: const Duration(seconds: 30),
//         headers: {
//           'accept': 'application/json',
//           'content-type': 'application/json',
//         },
//       ),
//     );

//     // Add interceptors for enhanced functionality
//     dio.interceptors.addAll([
//       _AuthInterceptor(),
//       _ErrorInterceptor(),
//       _RetryInterceptor(),
//       _LoggingInterceptor(),
//     ]);
//   }

//   /// Generic method for making API requests with retry logic
//   Future<DioPackage.Response<T>> requestWithRetry<T>(
//     String method,
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     DioPackage.Options? options,
//     DioPackage.CancelToken? cancelToken,
//   }) async {
//     int attempt = 0;

//     while (attempt < maxRetries) {
//       try {
//         final response = await dio.request<T>(
//           path,
//           data: data,
//           queryParameters: queryParameters,
//           options: DioPackage.Options(
//             method: method,
//             headers: options?.headers,
//           ),
//           cancelToken: cancelToken,
//         );
//         return response;
//       } on DioPackage.DioException catch (e) {
//         attempt++;

//         // Don't retry on client errors (4xx) except 408, 429
//         if (e.response?.statusCode != null &&
//             e.response!.statusCode! >= 400 &&
//             e.response!.statusCode! < 500 &&
//             ![408, 429].contains(e.response!.statusCode)) {
//           rethrow;
//         }

//         // Don't retry on the last attempt
//         if (attempt >= maxRetries) {
//           rethrow;
//         }

//         // Wait before retrying
//         await Future.delayed(retryDelay * attempt);
//       } on NoNetworkException {
//         rethrow;
//       } catch (e) {
//         attempt++;
//         if (attempt >= maxRetries) {
//           rethrow;
//         }
//         await Future.delayed(retryDelay * attempt);
//       }
//     }

//     throw Exception("Max retry attempts reached");
//   }

//   /// GET request with retry logic
//   Future<DioPackage.Response> get(
//     String path, {
//     Map<String, dynamic>? queryParameters,
//     DioPackage.Options? options,
//     DioPackage.CancelToken? cancelToken,
//   }) {
//     return requestWithRetry(
//       'GET',
//       path,
//       queryParameters: queryParameters,
//       options: options,
//       cancelToken: cancelToken,
//     );
//   }

//   /// POST request with retry logic
//   Future<DioPackage.Response> post(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     DioPackage.Options? options,
//     DioPackage.CancelToken? cancelToken,
//   }) {
//     return requestWithRetry(
//       'POST',
//       path,
//       data: data,
//       queryParameters: queryParameters,
//       options: options,
//       cancelToken: cancelToken,
//     );
//   }

//   /// PUT request with retry logic
//   Future<DioPackage.Response> put(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     DioPackage.Options? options,
//     DioPackage.CancelToken? cancelToken,
//   }) {
//     return requestWithRetry(
//       'PUT',
//       path,
//       data: data,
//       queryParameters: queryParameters,
//       options: options,
//       cancelToken: cancelToken,
//     );
//   }

//   /// DELETE request with retry logic
//   Future<DioPackage.Response> delete(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     DioPackage.Options? options,
//     DioPackage.CancelToken? cancelToken,
//   }) {
//     return requestWithRetry(
//       'DELETE',
//       path,
//       data: data,
//       queryParameters: queryParameters,
//       options: options,
//       cancelToken: cancelToken,
//     );
//   }
// }

// /// Authentication interceptor
// class _AuthInterceptor extends DioPackage.Interceptor {
//   @override
//   void onRequest(
//     DioPackage.RequestOptions options,
//     DioPackage.RequestInterceptorHandler handler,
//   ) {
//     final box = GetStorage();
//     final String? token = box.read('token');

//     if (token != null) {
//       options.headers['Authorization'] = 'Bearer $token';
//     }

//     handler.next(options);
//   }

//   @override
//   void onError(
//     DioPackage.DioException err,
//     DioPackage.ErrorInterceptorHandler handler,
//   ) async {
//     if (err.response?.statusCode == 401) {
//       // Token expired, attempt refresh
//       final box = GetStorage();
//       final String? refreshToken = box.read('refresh_token');

//       if (refreshToken != null) {
//         try {
//           // Implement token refresh logic here
//           // For now, just clear the token
//           await box.remove('token');
//           await box.remove('refresh_token');

//           // Navigate to login page
//           Get.offAllNamed('/login');
//         } catch (e) {
//           // Refresh failed, clear tokens and redirect to login
//           await box.remove('token');
//           await box.remove('refresh_token');
//           Get.offAllNamed('/login');
//         }
//       } else {
//         // No refresh token, redirect to login
//         Get.offAllNamed('/login');
//       }
//     }

//     handler.next(err);
//   }
// }

// /// Enhanced error interceptor with better error types
// class _ErrorInterceptor extends DioPackage.Interceptor {
//   @override
//   void onError(
//     DioPackage.DioException err,
//     DioPackage.ErrorInterceptorHandler handler,
//   ) async {
//     String errorMessage;

//     switch (err.type) {
//       case DioPackage.DioExceptionType.connectionTimeout:
//       case DioPackage.DioExceptionType.sendTimeout:
//       case DioPackage.DioExceptionType.receiveTimeout:
//         errorMessage =
//             "Connection timeout. Please check your internet connection.";
//         break;
//       case DioPackage.DioExceptionType.connectionError:
//         // Check if it's a network connectivity issue
//         final isConnected = await NetworkUtils.isConnected();
//         if (!isConnected) {
//           errorMessage =
//               "No internet connection. Please check your network settings.";
//         } else {
//           errorMessage =
//               "Cannot connect to server. Please check your internet connection.";
//         }
//         break;
//       case DioPackage.DioExceptionType.badResponse:
//         final statusCode = err.response?.statusCode;
//         switch (statusCode) {
//           case 400:
//             errorMessage = "Bad request. Please check your input.";
//             break;
//           case 401:
//             errorMessage = "Unauthorized. Please log in again.";
//             break;
//           case 403:
//             errorMessage = "Access forbidden. You don't have permission.";
//             break;
//           case 404:
//             errorMessage = "Resource not found.";
//             break;
//           case 422:
//             errorMessage = "Validation error. Please check your input.";
//             break;
//           case 429:
//             errorMessage = "Too many requests. Please try again later.";
//             break;
//           case 500:
//           case 502:
//           case 503:
//           case 504:
//             errorMessage = "Server error. Please try again later.";
//             break;
//           default:
//             errorMessage = "An error occurred (${statusCode ?? 'Unknown'}).";
//         }
//         break;
//       case DioPackage.DioExceptionType.cancel:
//         errorMessage = "Request was cancelled.";
//         break;
//       case DioPackage.DioExceptionType.unknown:
//         // Enhanced handling for unknown errors
//         final isConnected = await NetworkUtils.isConnected();
//         final baseUrl = err.requestOptions.uri.toString();
//         final isServerReachable = await NetworkUtils.isServerReachable(baseUrl);

//         if (!isConnected) {
//           errorMessage =
//               "No internet connection. Please check your network settings.";
//         } else if (!isServerReachable) {
//           errorMessage =
//               "Cannot reach the server. Please check your internet connection or try again later.";
//         } else {
//           errorMessage =
//               "An unexpected network error occurred. Please try again.";
//         }
//         break;
//       default:
//         errorMessage = "An unexpected error occurred.";
//     }

//     // Create a custom error with better information
//     final customError = AppException(errorMessage, err.type);

//     // Create a new DioException with the custom error
//     final enhancedError = DioPackage.DioException(
//       requestOptions: err.requestOptions,
//       error: customError,
//       response: err.response,
//       type: err.type,
//     );

//     handler.next(enhancedError);
//   }
// }

// /// Retry interceptor for automatic retries
// class _RetryInterceptor extends DioPackage.Interceptor {
//   @override
//   void onError(
//     DioPackage.DioException err,
//     DioPackage.ErrorInterceptorHandler handler,
//   ) async {
//     // Only retry on network errors or server errors
//     if (err.type == DioPackage.DioExceptionType.connectionError ||
//         err.type == DioPackage.DioExceptionType.connectionTimeout ||
//         err.type == DioPackage.DioExceptionType.sendTimeout ||
//         err.type == DioPackage.DioExceptionType.receiveTimeout ||
//         (err.response?.statusCode ?? 0) >= 500) {
//       // Add retry logic here if needed
//       // For now, we'll handle retries in the main request method
//     }

//     handler.next(err);
//   }
// }

// /// Logging interceptor for debugging
// class _LoggingInterceptor extends DioPackage.Interceptor {
//   @override
//   void onRequest(
//     DioPackage.RequestOptions options,
//     DioPackage.RequestInterceptorHandler handler,
//   ) {
//     print("🚀 REQUEST: ${options.method} ${options.uri}");
//     print("📋 Headers: ${options.headers}");
//     print("📄 Data: ${options.data}");
//     handler.next(options);
//   }

//   @override
//   void onResponse(
//     DioPackage.Response response,
//     DioPackage.ResponseInterceptorHandler handler,
//   ) {
//     print("✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}");
//     print("📊 Data: ${response.data}");
//     handler.next(response);
//   }

//   @override
//   void onError(
//     DioPackage.DioException err,
//     DioPackage.ErrorInterceptorHandler handler,
//   ) {
//     print(
//       "❌ ERROR: ${err.type} ${err.response?.statusCode} ${err.requestOptions.uri}",
//     );
//     print("🚫 Message: ${err.message}");
//     handler.next(err);
//   }
// }

// /// Custom exception types
// class AppException implements Exception {
//   final String message;
//   final DioPackage.DioExceptionType type;

//   AppException(this.message, this.type);

//   @override
//   String toString() => 'AppException: $message';
// }

// class NoNetworkException extends AppException {
//   NoNetworkException(String message)
//     : super(message, DioPackage.DioExceptionType.connectionError);
// }
