import 'package:dio/dio.dart';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:thunderapp/shared/core/models/pedido_model.dart';

import '../../shared/constants/app_text_constants.dart';
import '../../shared/core/user_storage.dart';

class ReportRepository extends GetxController {
  late String userToken;

  Future<List<PedidoModel>> getReports(int? id) async {
    Dio dio = Dio();
    PedidoModel pedido = PedidoModel();
    UserStorage userStorage = UserStorage();
    List<PedidoModel> orders = [];
    userToken = await userStorage.getUserToken();
    try{
    Response response = await dio.get(
        '$kBaseURL/transacoes/bancas/$id',
        options: Options(
          headers: {"Authorization": "Bearer $userToken"},
        ));

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      List<dynamic> all = response.data['vendas'];
      if (all.isNotEmpty) {
        for (int i = 0; i < all.length; i++) {
          if (all[i]["status"] != "pedido realizado" && all[i]["status"] != "pagamento pendente") {
          
            pedido = PedidoModel(
                id: all[i]["id"],
                status: all[i]["status"],
                dataPedido: all[i]["dataPedido"],
                tipoEntrega: all[i]["tipo_entrega"],
                subtotal: all[i]["subtotal"],
                taxaEntrega: all[i]["taxa_entrega"],
                total: all[i]["total"]);

            orders.add(pedido);
        
          }
        }
        return orders;
      }
      
    }
    }catch(e){
    if (e is DioError) {
        final dioError = e;
        if (dioError.response != null) {
          final errorMessage =
              dioError.response!.data['errors'];
          print('Erro: $errorMessage');
          print("Erro ${e.toString()}");
          
        }
      }
  }
  return [];
}
}