import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:thunderapp/shared/constants/app_text_constants.dart';
import 'package:thunderapp/shared/core/user_storage.dart';

class SignInRepository {
  final userStorage = UserStorage();
  String userId = "0";
  String userToken = "0";
  String noAut = 'Este aplicativo é exclusivo para vendedores.';
  
  final _dio = Dio();
  Future<int> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '$kBaseURL/sanctum/token',
        data: {
          'email': email,
          'password': password,
          'device_name': "PC"
        },
      );
      
      if (response.statusCode == 200) {
        if (await userStorage.userHasCredentials()) {
          await userStorage.clearUserCredentials();
        }
        
        userId = response.data['user']['id'].toString();
        userToken = response.data['token'].toString();
        
        await userStorage.saveUserCredentials(
          id: userId,
          nome: response.data['user']['name'].toString(),
          token: userToken,
          email: response.data['user']['email'].toString(),
        );

        try {
          Response userResponse = await _dio.get(
            '$kBaseURL/users/$userId',
            options: Options(headers: {"Authorization": "Bearer $userToken"}),
          );
          
          if (userResponse.statusCode == 200) {
            List roles = userResponse.data['user']['roles'];
            if (roles.isNotEmpty) {
              int roleId = roles[0]['id'];
              print('Role ID: $roleId');
              
              // Verifica se é vendedor (role 4)
              if (roleId == 4) {
                Response bancaResponse = await _dio.get(
                  '$kBaseURL/bancas/agricultores/$userId',
                  options: Options(headers: {"Authorization": "Bearer $userToken"})
                );
                
                if (bancaResponse.statusCode == 200) {
                  if(bancaResponse.data["bancas"].isEmpty) {
                    return 2; // Vendedor sem banca
                  }
                  return 1; // Sucesso - é vendedor com banca
                }
              } else {
                print(noAut);
                return 3; // Não autorizado - não é vendedor
              }
            }
          }
        } catch (e) {
          print(e);
          return 0;
        }
      }
    } catch (e) {
      log(e.toString());
      return 0;
    }
    return 0;
  }
}