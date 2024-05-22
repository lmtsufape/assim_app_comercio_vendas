import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:thunderapp/screens/home/home_screen_controller.dart';
import 'package:thunderapp/screens/home/home_screen_repository.dart';
import 'package:thunderapp/screens/orders/orders_repository.dart';
import 'package:thunderapp/screens/orders/orders_screen.dart';
import 'package:thunderapp/shared/core/models/banca_model.dart';
import 'package:thunderapp/shared/core/models/list_banca_model.dart';
import 'package:thunderapp/shared/core/models/pedido_model.dart';

import '../../shared/core/user_storage.dart';



class OrdersController extends GetxController {
  final HomeScreenController homeScreenController = Get.put(HomeScreenController());
  int quantPedidos = 0;
  ListBancaModel? bancaModel;
  HomeScreenRepository homeRepository = HomeScreenRepository();
  List<PedidoModel> orders = [];
  List<OrderCard> pedidos = [];
  late Future<List<dynamic>> orderData;
  OrdersRepository repository = OrdersRepository();

  List<PedidoModel> get getOrders => orders;

  Future<List<OrderCard>> populateOrderCard() async {
    List<OrderCard> list = [];
    UserStorage userStorage = UserStorage();
    var token = await userStorage.getUserToken();
    var userId = await userStorage.getUserId();
    bancaModel =
    homeScreenController.bancas[homeScreenController.banca.value];
    var pedidos = await repository.getOrders(bancaModel!.id);

    quantPedidos = pedidos.length;

    for (int i = 0; i < pedidos.length; i++) {
      OrderCard card = OrderCard(pedidos[i]);
      list.add(card);
    }

    if (list.isNotEmpty) {
      update();
      return list;
    } else {
      log('CARD VAZIO');
      return list;
    }
  }

  @override
  void onInit() async {
    pedidos = await populateOrderCard();
    super.onInit();
    update();
  }

}

