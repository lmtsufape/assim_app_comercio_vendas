import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:thunderapp/shared/constants/app_text_constants.dart';
import 'package:thunderapp/shared/core/models/products_model.dart';
import '../../shared/core/user_storage.dart';

class ListProductsRepository {
  late String userToken;

  Future<List<ProductsModel>> getProducts(id) async {
    Dio dio = Dio();
    List<ProductsModel> stockProduct = [];
    ProductsModel product = ProductsModel();
    UserStorage userStorage = UserStorage();
    String nome;
    var userToken = await userStorage.getUserToken();
    print(id);
    var response = await dio.get(
      '$kBaseURL/bancas/$id/produtos',
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $userToken"
        },
      ),
    );

    List<dynamic> data = response.data['produtos'];

    for (int i = 0; i < data.length; i++) {
      product = ProductsModel(
        nome: data[i]['nome'],
        id: data[i]['id'],
        descricao: data[i]['descricao'],
        titulo: data[i]['titulo'],
        tipoMedida: data[i]['tipo_medida'],
        estoque:
            int.tryParse(data[i]['estoque'].toString()),
        preco: double.parse(data[i]['preco'].toString()),
        custo: double.parse("1.00"),
        disponivel: data[i]['disponivel'],
        produtoTabeladoId: data[i]['produto_tabelado_id'],
        bancaId: data[i]['banca_id'],
      );
      stockProduct.add(product);
    }

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return stockProduct;
    } else {
      return stockProduct;
    }
  }

  Future<bool> deleteProduct(int? prodId) async {
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
}
