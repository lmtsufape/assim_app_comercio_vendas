import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:thunderapp/shared/core/models/banca_model.dart';

import '../../shared/constants/app_text_constants.dart';

class StartRepository {
  final Dio _dio = Dio();
  int vazia = 5;

  Future<int?> Start(
      String? userToken, String? userId) async {
    print('userId: $userId');
    print('chegou aqui');

    try {
      Response response = await _dio.get(
          '$kBaseURL/bancas/agricultores/$userId',
          options: Options(headers: {
            "Authorization": "Bearer $userToken"
          }));
      if (response.statusCode == 200) {
        if(response.data["bancas"].isEmpty){
          vazia = 2;
          print('vazia = 2');
          return 2;
        }else{
          print(response.statusCode);
          vazia = 1;
          print('vazia = 1');
          return 1;}
      }
    } catch (e) {
      log('Entrou no catch do get de bancas');
      log("$e");
      print('vazia = 0');
      return 0;
    }
    print('vazia = 3');
    return 3;
  }
}