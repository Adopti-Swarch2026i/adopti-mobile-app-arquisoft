import 'package:dio/dio.dart';

import '../../data/datasources/local/firebase_auth_datasource.dart';

class AuthInterceptor extends Interceptor {
  final FirebaseAuthDataSource _authDataSource;

  AuthInterceptor(this._authDataSource);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _authDataSource.getIdToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
