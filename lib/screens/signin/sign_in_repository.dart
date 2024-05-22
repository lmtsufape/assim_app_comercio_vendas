import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:thunderapp/shared/constants/app_text_constants.dart';
import 'package:thunderapp/shared/core/user_storage.dart';

class SignInRepository {
  final userStorage = UserStorage();
  String userId = "0";
  String userToken = "0";
  

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
              nome:
                  response.data['user']['name'].toString(),
              token:
                  userToken,
              email:
                  response.data['user']['email'].toString(),
              );
          try{
            Response response = await _dio.get(
          '$kBaseURL/bancas/agricultores/$userId',
          options: Options(headers: {
            "Authorization": "Bearer $userToken"
          }));
      if (response.statusCode == 200) {
        if(response.data["bancas"].isEmpty){
          return 2;
        }else{
          print(response.statusCode);
          return 1;}
      }
          }catch(e){
            print(e);
            return 0;
          }
      return 1;
        
      }
    } catch (e) {
      log(e.toString());
      return 0;
    }
    return 0;
  }

}
