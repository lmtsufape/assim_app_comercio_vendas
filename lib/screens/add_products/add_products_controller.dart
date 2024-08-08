import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thunderapp/screens/add_products/add_products_repository.dart';
import 'package:thunderapp/screens/home/home_screen_controller.dart';
import 'package:thunderapp/screens/home/home_screen_repository.dart';
import 'package:thunderapp/shared/components/dialogs/default_alert_dialog.dart';
import 'package:thunderapp/shared/constants/app_enums.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';
import 'package:thunderapp/shared/core/models/banca_model.dart';
import 'package:thunderapp/shared/core/models/list_banca_model.dart';
import 'package:thunderapp/shared/core/models/table_products_model.dart';
import 'package:thunderapp/shared/core/user_storage.dart';

class AddProductsController extends GetxController {
  final HomeScreenController homeScreenController = Get.put(HomeScreenController());
  ScreenState screenState = ScreenState.idle;

  // Informações para o post de cadastro de produtos.
  String? description;
  String? title;
  String measure = 'unidade';
  int? productId;
  int? stock;
  String? salePrice;
  //String? costPrice;
  String? token;
  ListBancaModel? bancaModel;
  String? userId;
  late String userToken;
  bool hasImage = false;
  var selectedDropdownValue1 = 'DefaultValue1'.obs;
  var selectedDropdownValue2 = 'DefaultValue2'.obs;
  // -----------------------

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  HomeScreenRepository homeRepository = HomeScreenRepository();
  UserStorage userStorage = UserStorage();

  AddProductsRepository repository = AddProductsRepository();

  List<TableProductsModel> products = [];

  final TextEditingController _stockController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _saleController = TextEditingController();

  final TextEditingController _titleController = TextEditingController();

  TextEditingController get saleController => _saleController;

  TextEditingController get titleController => _titleController;

  TextEditingController get stockController => _stockController;

  TextEditingController get descriptionController => _descriptionController;

  double changeProfit(String salePrice, String costPrice) {
    salePrice = salePrice.replaceAll(RegExp(r'[^0-9,.]'), '').replaceAll(',', '.');
    costPrice = costPrice.replaceAll(RegExp(r'[^0-9,.]'), '').replaceAll(',', '.');

    double profit = 0.0;
    if (salePrice.isNotEmpty && costPrice.isNotEmpty) {
      profit = double.parse(salePrice) - double.parse(costPrice);
    }

    return profit;
  }

  void setProductId(int? value) {
    productId = value;
    update();
  }

  void setDescription() {
    description = descriptionController.text;
    update();
  }

  void setTitle() {
    title = titleController.text;
    update();
  }

  void setMeasure(String value) {
    measure = value;
    update();
  }

  void setStock() {
    String value = stockController.text
        .replaceAll(RegExp(r'[^0-9,.]'), '')
        .replaceAll(',', '.');
    if (value.isNotEmpty) {
      stock = int.parse(value);
    }
    update();
  }

  void setSalePrice() {
    salePrice = saleController.text
        .replaceAll(RegExp(r'[^0-9,.]'), '')
        .replaceAll(',', '.');

    update();
  }

  void loadTableProducts() async {
    products = await repository.getProducts();

    update();
  }

  Future<bool> validateEmptyFields(context) async {
    Size size = MediaQuery.of(context).size;
    ButtonStyle styleCancel = ElevatedButton.styleFrom(
      backgroundColor: kErrorColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    );
    try {
      if (description == null ||
          measure.isEmpty ||
          _stockController.text.isEmpty ||
          _saleController.text.isEmpty ||
          _titleController.text.isEmpty ||
          productId == null) {
        log('Error, o user não preencheu todos os campos, retornando falso');
        return false;
      } else {
        var response = await repository.registerProduct(description, title, measure,
            stock, salePrice, productId, bancaModel?.id);
        if (response) {
          return true;
        }
        return false;
      }
    } catch (e) {
      if (e is DioError && e.response?.statusCode == 400) {
        Get.dialog(
          AlertDialog(
            title: Text('Erro', style: TextStyle(fontSize: size.height * 0.026)),
            content: Text('Esse produto já está cadastrado.', style: TextStyle(fontSize: size.height * 0.022),),
            actions: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SizedBox(
                    width: size.width * 0.3,
                    height: size.height * 0.040,
                    child: ElevatedButton(
                      style: styleCancel,
                      onPressed: () => Get.back(),
                      child: Text(
                        'Voltar',
                        style: TextStyle(
                            color: kTextColor,
                            fontSize: size.height * 0.022,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        Get.dialog(
          AlertDialog(
            title: const Text('Erro', style: TextStyle(fontSize: 22)),
            content: Container(
              alignment: Alignment.center,
              height: 75,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 10),
                child: Text(e.toString()),
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Voltar',
                  style: TextStyle(color: kErrorColor, fontSize: 20),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        );
      }
      return false;
    }
  }

  void printList() {
    print(products);
  }

  Future<List<TableProductsModel>> loadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listaString =
        prefs.getStringList('listaProdutosTabelados') ?? [];
    return listaString
        .map((string) => TableProductsModel.fromJson(json.decode(string)))
        .toList();
  }

  TableProductsModel? search(int? tableProId) {
    for (int i = 0; i < products.length; i++) {
      if (products[i].id == tableProId) {
        return products[i];
      }
    }
    return null;
  }

  void clearFields() {
    _saleController.clear();
    _titleController.clear();
    _descriptionController.clear();
    _stockController.clear();
    measure = 'unidade';
    productId = null;
    update();
  }

  @override
  void onClose() {
    _saleController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();
    super.onClose();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    token = await userStorage.getUserToken();
    userId = await userStorage.getUserId();
    bancaModel = homeScreenController.bancas[homeScreenController.banca.value];
    products = await loadList();
    clearFields();
    update();
  }
}