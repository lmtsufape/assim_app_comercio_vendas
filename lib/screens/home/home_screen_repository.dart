import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:thunderapp/shared/core/models/banca_model.dart';

import '../../shared/constants/app_text_constants.dart';
import '../../shared/core/models/list_banca_model.dart';
import '../../shared/core/user_storage.dart';

class HomeScreenRepository {
  final Dio _dio = Dio();
  List<ListBancaModel> bancas = [];
  ListBancaModel banca = ListBancaModel();

  Future<List<ListBancaModel>> getBancas(String userId) async {
    Dio dio = Dio();
    UserStorage userStorage = UserStorage();

    String? userToken = await userStorage.getUserToken();

    var response =
    await dio.get('$kBaseURL/bancas/agricultores/$userId',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $userToken"
          },
        ));

    List<dynamic> responseData = response.data['bancas'];

    for (int i = 0; i < responseData.length; i++) {
      banca = ListBancaModel(
          id: responseData[i]["id"],
          nome: responseData[i]["nome"],
          descricao: responseData[i]["descricao"],
          horarioAbertura: responseData[i]["horarios_abertura"],
          horarioFechamento: responseData[i]["horarios_fechamento"],
          precoMin: responseData[i]["preco_minimo"],
          pix: responseData[i]["pix"],
          feiraId: responseData[i]["feira_id"],
          agricultorId: responseData[i]["agricultor_id"]
      );
      bancas.add(banca);
      print(bancas[i].nome);
    }

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      print(bancas);
      return bancas;
    }
    return [];
  }

  Future<BancaModel?> getBancaPrefs(
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
        BancaModel bancaModel = BancaModel(
            response.data["bancas"][0]["id"],
            response.data["bancas"][0]["nome"].toString(),
            response.data["bancas"][0]["descricao"]
                .toString(),
            response.data["bancas"][0]["horario_abertura"]
                .toString(),
            response.data["bancas"][0]["horario_fechamento"]
                .toString(),
            response.data["bancas"][0]["preco_minimo"].toString(),
            response.data["bancas"][0]["pix"].toString(),
            response.data["bancas"][0]["feira_id"],
            response.data["bancas"][0]["agricultor_id"]);
        log('bancaModel: ${bancaModel.getNome}');
        return bancaModel;
      } else {
        log('response.statuscode != 200');
        return null;
      }
    } catch (e) {
      log('Entrou no catch do get de bancas');
      log("$e");
      return null;
    }
  }
}
