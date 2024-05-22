import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:thunderapp/shared/core/models/pedido_model.dart';
import 'package:thunderapp/shared/core/models/produto_pedido_model.dart';
import '../../shared/constants/app_text_constants.dart';
import '../../shared/core/user_storage.dart';

class OrdersRepository extends GetxController {
  late String userToken;
  late String userId;
  final Dio _dio = Dio();

  Future<List<PedidoModel>> getOrders(int bancaId) async {
    UserStorage userStorage = UserStorage();
    userToken = await userStorage.getUserToken();
    userId = await userStorage.getUserId();

    log('Sending request with token: $userToken'); // Log do token

    try {
      var response = await _dio.get('$kBaseURL/transacoes/bancas/$bancaId',
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              'Cache-Control': 'no-cache',
              "Authorization": "Bearer $userToken"
            },
          ));

      if (response.statusCode == 200) {
        /*  log('Response data: ${response.data}'); */

        if (response.data['vendas'] != null) {
          final jsonData = Map<String, dynamic>.from(response.data);
          final ordersJson = List.from(jsonData['vendas'])
              .map((item) => Map<String, dynamic>.from(item))
              .toList();

          List<PedidoModel> orders = [];
          for (var orderJson in ordersJson) {
            var order = PedidoModel.fromJson(orderJson);
            orders.add(order);
          }

          // Ordenar os pedidos pela data
          orders.sort((a, b) => a.dataPedido!.compareTo(b.dataPedido!));

          return orders;
        } else {
          log('No vendas data available.');
          return [];
        }
      } else {
        throw Exception(
            'Falha em carregar os pedidos. Status code: ${response.statusCode}');
      }
    } catch (error) {
      log('Error making the request: $error');
      rethrow;
    }
  }

  Future<bool> confirmOrder(int pedidoId, bool confirm) async {
    UserStorage userStorage = UserStorage();
    userToken = await userStorage.getUserToken();

    try {
      var body = {
        "confirmacao": confirm,
      };

      print(body);

      Response response = await _dio.post(
        '$kBaseURL/transacoes/$pedidoId/confirmar',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $userToken"
          },
        ),
        data: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (e is DioError) {
        final dioError = e;
        if (dioError.response != null) {
          final errorMessage = dioError.response!.data['errors'];
          print('Erro: $errorMessage');
          print("Erro ${e.toString()}");
          return false;
        }
      }
      return false;
    }
  }
}
