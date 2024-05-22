import 'package:dio/dio.dart';

abstract class IHttpClient {
  Future get({required String url, required String userToken});
}

class HttpClient implements IHttpClient {
  final Dio _dio = Dio();

  @override
  Future get({required String url, required String userToken}) async {
    final response = await _dio.get(
        url,
        options: Options(headers: {
            "Authorization": "Bearer $userToken"
          }
        )
    );
    return response;
  }
}
