import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:infrearnclass/common/const/data.dart';
import 'package:infrearnclass/common/secure_storage/secure_storage.dart';

final dioProvider = Provider((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(CustomInterceptor(storage: storage));

  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  // 1) 요청을 보낼때
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{
    print('[REQ] [${options.method}] ${options.uri}');

    if(options.headers['accessToken'] == 'true'){
      options.headers.remove('accessToken');
      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if(options.headers['refreshToken'] == 'true'){
      options.headers.remove('refreshToken');
      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을때 - Status 200
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async{
    // status 401 - token refresh
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if(refreshToken == null){
      // error 던지는 방법
      return handler.reject(err);
    }

    final is401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if(is401 && !isPathRefresh){
      final dio = Dio();

      try{
        final resp = await dio.post(
            'http://$ip/auth/token',
            options: Options(
                headers: {'authorization': 'Bearer $refreshToken',}
            )
        );

        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;

        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        final response = await dio.fetch(options);

        return handler.resolve(response);
      } on DioError catch (e) {
        return handler.reject(e);
      }
    }
  }

}