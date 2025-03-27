import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:thunderapp/shared/core/models/table_products_model.dart';

import '../../shared/constants/app_text_constants.dart';
import '../../shared/core/user_storage.dart';
import 'edit_products_controller.dart';

class EditProductsRepository extends GetxController {
  late String userToken;
  List<TableProductsModel> products = [];
  TableProductsModel product = TableProductsModel();


  Future<List<TableProductsModel>> getProducts() async {
    Dio dio = Dio();
    UserStorage userStorage = UserStorage();

    userToken = await userStorage.getUserToken();

    var response =
        await dio.get('$kBaseURL/produtos/tabelados',
            options: Options(
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer $userToken"
              },
            ));

    List<dynamic> responseData = response.data['produtos'];

    for (int i = 0; i < responseData.length; i++) {
      product = TableProductsModel(
          id: responseData[i]["id"],
          nome: responseData[i]["nome"],
          categoria: responseData[i]["categoria"]);
      products.add(product);
    }

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return products;
    }
    return [];
  }

  Future<bool> editProductsWithChanges(
    EditProductsController controller,
    Map<String, dynamic> changedFields) async {
  Dio dio = Dio();
  UserStorage userStorage = UserStorage();
  userToken = await userStorage.getUserToken();

  log('Enviando requisição PATCH para o endpoint: $kBaseURL/produtos/${controller.productId}');
  log('Corpo da requisição: $changedFields');
  
  try {
    var response = await dio.patch(
      "$kBaseURL/produtos/${controller.productId}",
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $userToken"
        },
      ),
      data: changedFields
    );

    log('Resposta da API - Status code: ${response.statusCode}');
    log('Resposta da API - Corpo: ${response.data}');
    
    return response.statusCode == 200 || response.statusCode == 201;
  } catch (e) {
    if (e is DioError) {
      final dioError = e;
      if (dioError.response != null) {
        log('Erro de API - Status code: ${dioError.response!.statusCode}');
        log('Erro de API - Corpo: ${dioError.response!.data}');
      } else {
        log('Erro de conexão: ${e.toString()}');
      }
    } else {
      log('Erro inesperado: ${e.toString()}');
    }
    return false;
  }
}

  Future<bool> deleteProduct(context, int? prodId) async {
    Dio dio = Dio();

    UserStorage userStorage = UserStorage();

    userToken = await userStorage.getUserToken();

    var response = await dio.delete(
      '$kBaseURL/produtos/$prodId',
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $userToken"
        },
      ),
    );
    if (kDebugMode) {
      print(response.statusCode);
    }
    print(response.statusCode);
    return true;
  }

  Future<bool> editProducts(
      EditProductsController controller) async {
    Dio dio = Dio();

    UserStorage userStorage = UserStorage();

    userToken = await userStorage.getUserToken();

    var body = {
      "descricao": controller.description.toString(),
      "titulo": controller.title.toString(),
      "tipo_medida": controller.measure
          .toString() /**Alterar para "measure" quando tiver a validação*/,
      "estoque": controller.stock,
      "preco": controller.salePrice,
      "custo": controller.costPrice,
      "disponivel": true
    };
    print(body);
    try {
      var response = await dio.patch(
          "$kBaseURL/produtos/${controller.productId}",
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $userToken"
            },
          ),
          data: body);

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
