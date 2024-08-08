import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thunderapp/screens/home/home_screen_controller.dart';
import 'package:thunderapp/screens/home/home_screen_repository.dart';
import 'package:thunderapp/screens/add_products/add_products_repository.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';
import 'package:thunderapp/shared/core/models/banca_model.dart';
import 'package:thunderapp/shared/core/models/list_banca_model.dart';
import 'package:thunderapp/shared/core/models/table_products_model.dart';
import 'package:thunderapp/shared/core/user_storage.dart';

import '../edit_products/edit_products_repository.dart';
import '../list_products/components/card_products_list.dart';
import 'list_products_repository.dart';

class ListProductsController extends GetxController {
  final HomeScreenController homeScreenController = Get.put(HomeScreenController());
  List<TableProductsModel> tableProducts = [];
  List<CardProductsList> products = [];
  ListBancaModel? bancaModel;
  int quantProducts = 0;
  int quantStock = 0;
  int? productId;
  late String userToken;
  late String userId;
  late bool hasImage = false;

  HomeScreenRepository homeRepository = HomeScreenRepository();
  EditProductsRepository editRepository = EditProductsRepository();
  ListProductsRepository repository = ListProductsRepository();
  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  void setHasImage(bool value) {
    hasImage = value;
    update();
  }

  Future<List<CardProductsList>> populateCardsProductsList() async {
    List<CardProductsList> list = [];
    UserStorage userStorage = UserStorage();
    var token = await userStorage.getUserToken();
    var userId = await userStorage.getUserId();
    bancaModel = homeScreenController.bancas[homeScreenController.banca.value];
    var products = await repository.getProducts(bancaModel?.id);
    quantProducts = products.length;

    if (products.isNotEmpty) {
      for (int i = 0; i < products.length; i++) {
        CardProductsList card = CardProductsList(
            token,
            products[i],
            repository,
            tableProducts,
            editRepository);
        list.add(card);
        if (products.isNotEmpty) {
          quantStock += products[i].estoque!;
        }
      }
    } else {
      log('CARD VAZIO');
      list = [];
      return list;
    }

    // Verifica se a lista está vazia antes de tentar acessá-la
    if (list.isNotEmpty) {
      update();
      return list;
    } else {
      throw RangeError('Lista vazia');
    }
  }

  Future<List<TableProductsModel>> loadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listaString = prefs.getStringList('listaProdutosTabelados') ?? [];
    return listaString.map((string) => TableProductsModel.fromJson(json.decode(string))).toList();
  }

  Future<void> fetchProducts() async {
    tableProducts = await loadList();
    products = await populateCardsProductsList();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    update();
  }

  @override
  void onReady() {
    super.onReady();
    refreshProductList();
  }

  void refreshProductList() {
    populateCardsProductsList().then((_) => update());
  }
}