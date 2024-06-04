import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:thunderapp/screens/home/home_screen_controller.dart';
import 'package:thunderapp/screens/home/home_screen_repository.dart';
import 'package:thunderapp/screens/orders/orders_repository.dart';
import 'package:thunderapp/screens/orders/orders_screen.dart';
import 'package:thunderapp/shared/core/models/banca_model.dart';
import 'package:thunderapp/shared/core/models/list_banca_model.dart';
import 'package:thunderapp/shared/core/models/pedido_model.dart';

import '../../shared/components/dialogs/default_alert_dialog.dart';
import '../../shared/constants/style_constants.dart';
import '../../shared/core/models/produto_pedido_model.dart';
import '../../shared/core/user_storage.dart';
import '../home/home_screen.dart';



class OrdersController extends GetxController {
  final HomeScreenController homeScreenController = Get.put(HomeScreenController());
  int quantPedidos = 0;
  RxString statusOrder = ''.obs;
  ListBancaModel? bancaModel;
  HomeScreenRepository homeRepository = HomeScreenRepository();
  List<PedidoModel> orders = [];
  List<OrderCard> pedidos = [];
  late Future<List<dynamic>> orderData;
  OrdersRepository repository = OrdersRepository();
  bool confirmSucess = false;
  bool confirmedOrder = false;
  bool delivery = false;
  File? _comprovante;
  String? _comprovanteType;
  String? _pdfPath;
  String? _downloadPath;
  Uint8List? _comprovanteBytes;

  File? get comprovante => _comprovante;

  String? get comprovanteType => _comprovanteType;

  String? get pdfPath => _pdfPath;

  String? get downloadPath => _downloadPath;

  Uint8List? get comprovanteBytes => _comprovanteBytes;


  List<PedidoModel> get getOrders => orders;

  void setConfirm(bool value) {
    confirmedOrder = value;
    update();
  }

  void setStatus(String value) {
    statusOrder.value = value;
    update();
  }


  void confirmOrder(BuildContext context, int id) async {
    try {
      confirmSucess = await repository.confirmOrder(id, confirmedOrder);
      if (confirmSucess && confirmedOrder == true) {
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (context) => DefaultAlertDialogOneButton(
              title: 'Sucesso',
              body: 'O pedido foi aceito',
              confirmText: 'Ok',
              onConfirm: () {
                navigator?.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context)=>HomeScreen()),
                      (Route<dynamic> route) => false,
                );
              },
              buttonColor: kSuccessColor,
            ));
      } else {
        showDialog(
            context: context,
            builder: (context) => DefaultAlertDialogOneButton(
              title: 'Sucesso',
              body: 'O pedido foi negado',
              confirmText: 'Ok',
              onConfirm: () {
                navigator?.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context)=>HomeScreen()),
                      (Route<dynamic> route) => false,
                );
              },
              buttonColor: kSuccessColor,
            ));
      }
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: const Text('Erro'),
          content:
          Text("${e.toString()}\n Procure o suporte com a equipe LMTS"),
          actions: [
            TextButton(
              child: const Text('Voltar'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      );
    }
  }

  Future<List<OrderCard>> populateOrderCard() async {
    List<OrderCard> list = [];
    UserStorage userStorage = UserStorage();
    var token = await userStorage.getUserToken();
    var userId = await userStorage.getUserId();
    bancaModel =
    homeScreenController.bancas[homeScreenController.banca.value];

    var pedidos = await repository.getOrders(bancaModel!.id!);

    quantPedidos = pedidos.length;

    for (int i = 0; i < pedidos.length; i++) {
      if (pedidos[i].status != "pedido recusado" &&
          pedidos[i].status != "pagamento expirado" &&
          pedidos[i].status != "pedido entregue") {
        OrderCard card = OrderCard(pedidos[i], OrdersController());
        list.add(card);
      }
    }

    if (list.isNotEmpty) {
      update();
      return list;
    } else {
      log('CARD VAZIO');
      return list;
    }
  }

  void confirmDeliver(BuildContext context, int id) async {
    try {
      delivery = await repository.confirmDelivery(id);
      if (delivery == true) {
        showDialog(
            context: context,
            builder: (context) => DefaultAlertDialogOneButton(
              title: 'Sucesso',
              body: 'O pedido está pronto',
              confirmText: 'Ok',
              onConfirm: () {
                navigator?.pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const HomeScreen()),
                      (Route<dynamic> route) => false,
                );
              },
              buttonColor: kSuccessColor,
            ));
      } else {
        showDialog(
            context: context,
            builder: (context) => DefaultAlertDialogOneButton(
              title: 'Erro',
              body: 'Erro na entrega',
              confirmText: 'Ok',
              onConfirm: () {
                navigator?.pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const HomeScreen()),
                      (Route<dynamic> route) => false,
                );
              },
              buttonColor: kSuccessColor,
            ));
      }
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: const Text('Erro'),
          content:
          Text("${e.toString()}\n Procure o suporte com a equipe LMTS"),
          actions: [
            TextButton(
              child: const Text('Voltar'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      );
    }
  }

  Future<String> fetchUserDetails(int userId) async {
    try {
      var userDetails = await repository.fetchUserDetails(userId);
      if (userDetails != null && userDetails.containsKey('user')) {
        return userDetails['user']['name']; // Retorna apenas o nome do usuário
      } else {
        return "Nome não encontrado"; // Retorna uma mensagem padrão
      }
    } catch (e) {
      print('Erro ao buscar nome do usuário: $e');
      return "Erro ao buscar usuário"; // Retorna uma mensagem de erro
    }
  }

  Future<void> pickComprovante() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null && result.files.single.path != null) {
        _comprovante = File(result.files.single.path!);
        _comprovanteType = result.files.single.extension;
        _pdfPath = (_comprovanteType == 'pdf') ? _comprovante!.path : null;
        update();
      } else {
        debugPrint('Nenhum arquivo selecionado');
      }
    } catch (e) {
      debugPrint('Erro ao selecionar arquivo: $e');
    }
  }

  Future<void> loadPDF(String? path) async {
    try {
      if (path != null && path.isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (e) {
      debugPrint('Erro ao carregar PDF: $e');
      throw Exception('Erro ao carregar PDF');
    }
  }

  Future<void> downloadComprovante(int orderId) async {
    try {
      _downloadPath = await repository.downloadComprovante(orderId);
      _comprovanteType = _downloadPath!.split('.').last;
      _pdfPath = (_comprovanteType == 'pdf') ? _downloadPath : null;
      update();
    } catch (e) {
      debugPrint('Erro ao baixar comprovante: $e');
    }
  }

  Future<void> fetchComprovanteBytes(int orderId) async {
    try {
      _comprovanteBytes = await repository.getComprovanteBytes(orderId);
      _comprovanteType = detectFileType(_comprovanteBytes!);
      update();
    } catch (e) {
      debugPrint('Erro ao obter bytes do comprovante: $e');
    }
  }

  String detectFileType(Uint8List bytes) {
    final pdfHeader = [0x25, 0x50, 0x44, 0x46];
    final jpgHeader = [0xFF, 0xD8, 0xFF];
    final pngHeader = [0x89, 0x50, 0x4E, 0x47];

    bool matchesHeader(Uint8List bytes, List<int> header) {
      for (int i = 0; i < header.length; i++) {
        if (bytes[i] != header[i]) {
          return false;
        }
      }
      return true;
    }

    if (bytes.length >= 4 && matchesHeader(bytes, pdfHeader)) {
      return 'pdf';
    } else if (bytes.length >= 3 && matchesHeader(bytes, jpgHeader)) {
      return 'jpg';
    } else if (bytes.length >= 4 && matchesHeader(bytes, pngHeader)) {
      return 'png';
    } else {
      return 'unknown';
    }
  }


  List<ProdutoPedidoModel> getItensDoPedido(int pedidoId) {
    var pedido = orders.firstWhere(
            (order) => order.id == pedidoId,
        orElse: () => PedidoModel(consumidorId: 0));
    return pedido.listaDeProdutos ?? [];
  }

  Future<void> fetchOrders() async {
    UserStorage userStorage = UserStorage();
    String userId = await userStorage.getUserId();
    try {
      bancaModel =
      homeScreenController.bancas[homeScreenController.banca.value];
      var fetchedOrders = await repository.getOrders(bancaModel!.id!);
      orders.assignAll(fetchedOrders);
    } catch (e) {
      print('Erro ao buscar pedidos: $e');
    }
  }


  @override
  void onInit() async {
    pedidos = await populateOrderCard();
    super.onInit();
    fetchOrders();
    update();
  }

}

