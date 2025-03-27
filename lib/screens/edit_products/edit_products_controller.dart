import 'dart:convert';
import 'dart:developer';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thunderapp/screens/home/home_screen_repository.dart';
import 'package:thunderapp/shared/constants/app_enums.dart';
import 'package:thunderapp/shared/core/models/banca_model.dart';
import 'package:thunderapp/shared/core/models/products_model.dart';

import 'package:thunderapp/shared/core/models/table_products_model.dart';
import 'package:thunderapp/shared/core/user_storage.dart';

import 'edit_products_repository.dart';

class EditProductsController extends GetxController {
  ScreenState screenState = ScreenState.idle;

  // Informações para o post de cadastro de produtos.

  String? description;
  String? title;
  String measure = 'unidade';
  int? productId;
  int? stock;
  String? costPrice;
  String? salePrice;
  String? token;
  BancaModel? bancaModel;
  String? userId;
  late String userToken;
  bool hasImage = false;
  List<TableProductsModel> tableProducts = [];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // -----------------------
  EditProductsController(ProductsModel model) {
    description = model.descricao;
    title = model.titulo;
    productId = model.id;
    stock = model.estoque;
    costPrice = "1.00";
    salePrice = model.preco.toString();
  }
  HomeScreenRepository homeRepository =
      HomeScreenRepository();
  UserStorage userStorage = UserStorage();

  EditProductsRepository repository =
      EditProductsRepository();
  List<TableProductsModel> products = [];
  final TextEditingController _stockController =
      TextEditingController();

  CurrencyTextInputFormatter currencyFormatter =
      CurrencyTextInputFormatter.currency(
          locale: 'pt-Br', symbol: 'R\$');

  final TextEditingController _saleController =
      TextEditingController();

  final TextEditingController _descriptionController =
      TextEditingController();

  final TextEditingController _titleController =
      TextEditingController();

  TextEditingController get saleController =>
      _saleController;

  TextEditingController get titleController =>
      _titleController;

  TextEditingController get descriptionController =>
      _descriptionController;

  TextEditingController get stockController =>
      _stockController;

  double changeProfit(String salePrice, String costPrice) {
    salePrice = salePrice
        .replaceAll(RegExp(r'[^0-9,.]'), '')
        .replaceAll(',', '.');
    costPrice = costPrice
        .replaceAll(RegExp(r'[^0-9,.]'), '')
        .replaceAll(',', '.');

    double profit = 0.0;
    if (salePrice.isNotEmpty && costPrice.isNotEmpty) {
      profit =
          double.parse(salePrice) - double.parse(costPrice);
    }

    return profit;
  }

  void setHasImage(bool value) {
    hasImage = value;
    update();
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
  // Remover símbolos de moeda (R$), espaços e substituir vírgulas por pontos
  salePrice = _saleController.text
      .replaceAll('R\$', '')
      .replaceAll(' ', '')
      .replaceAll(RegExp(r'[^0-9,.]'), '')
      .replaceAll(',', '.');
  
  // Garantir que é um número decimal válido
  try {
    double value = double.parse(salePrice!);
    salePrice = value.toString(); // Formato decimal padrão com ponto
  } catch (e) {
    // Se não for possível converter, manter o valor como está
    log('Erro ao converter preço para decimal: $e');
  }
  
  update();
}

  Future<bool> validateEmptyFields() async {
  try {
    log('Iniciando validação de campos...');
    
    // Verificar se o ID do produto existe (necessário para a edição)
    if (productId == null) {
      log('Erro: ID do produto não fornecido. Operação cancelada.');
      return false;
    }
    
    // Criando um mapa dos valores originais e atuais para comparação
    log('Verificando campos alterados...');
    
    Map<String, dynamic> changedFields = {};
    bool hasChanges = false;
    
    // Verificar título
    if (_titleController.text.isNotEmpty) {
      log('Campo título preenchido: ${_titleController.text}');
      changedFields['titulo'] = _titleController.text;
      hasChanges = true;
    } else {
      log('Campo título vazio. Usando valor original: $title');
    }
    
    // Verificar descrição
    if (_descriptionController.text.isNotEmpty) {
      log('Campo descrição preenchido: ${_descriptionController.text}');
      changedFields['descricao'] = _descriptionController.text;
      hasChanges = true;
    } else {
      log('Campo descrição vazio. Usando valor original: $description');
    }
    
    // Verificar unidade de medida
    if (measure.isNotEmpty) {
      log('Campo medida preenchido: $measure');
      changedFields['tipo_medida'] = measure;
      hasChanges = true;
    } else {
      log('Campo medida vazio. Esse campo é obrigatório.');
      return false;
    }
    
    // Verificar estoque
    if (_stockController.text.isNotEmpty) {
      log('Campo estoque preenchido: ${_stockController.text}');
      try {
        String value = _stockController.text
            .replaceAll(RegExp(r'[^0-9,.]'), '')
            .replaceAll(',', '.');
        int stockValue = int.parse(value);
        changedFields['estoque'] = stockValue;
        hasChanges = true;
      } catch (e) {
        log('Erro ao converter valor de estoque: $e');
        return false;
      }
    } else {
      log('Campo estoque vazio. Usando valor original: $stock');
    }
    
    // Verificar preço de venda
    if (_saleController.text.isNotEmpty) {
      log('Campo preço de venda preenchido: ${_saleController.text}');
      try {
        String value = _saleController.text
            .replaceAll(RegExp(r'[^0-9,.]'), '')
            .replaceAll(',', '.');
        changedFields['preco'] = value;
        hasChanges = true;
      } catch (e) {
        log('Erro ao converter valor de preço de venda: $e');
        return false;
      }
    } else {
      log('Campo preço de venda vazio. Usando valor original: $salePrice');
    }
    
    // Verificar preço de custo (provavelmente usando um valor padrão)
    if (costPrice != null && costPrice!.isNotEmpty) {
      log('Campo preço de custo presente: $costPrice');
      changedFields['custo'] = costPrice;
      hasChanges = true;
    } else {
      log('Campo preço de custo vazio. Usando valor padrão: 1.00');
      changedFields['custo'] = "1.00";
    }
    
    // Sempre incluir disponibilidade
    changedFields['disponivel'] = true;
    
    // Verificar se algum campo foi alterado
    if (!hasChanges) {
      log('Nenhum campo foi alterado. Operação cancelada.');
      return false;
    }
    
    // Enviando dados alterados para o repositório
    log('Campos alterados: $changedFields');
    log('Enviando requisição para API...');
    
    // Substitua pela chamada real ao repositório quando estiver pronto
    // Para esse exemplo, estamos criando um corpo de requisição personalizado
    var response = await repository.editProductsWithChanges(this, changedFields);
    
    if (response) {
      log('Produto atualizado com sucesso!');
      return true;
    } else {
      log('Falha ao atualizar o produto.');
      return false;
    }
  } catch (e) {
    if (e is DioError) {
      final dioError = e;
      if (dioError.response != null) {
        final errorMessage = dioError.response!.data['errors'];
        log('Erro de API: $errorMessage');
        log('Detalhes do erro: ${e.toString()}');
      } else {
        log('Erro de conexão: ${e.toString()}');
      }
    } else {
      log('Erro inesperado: ${e.toString()}');
    }
    return false;
  }
}

  Future<List<TableProductsModel>> loadList() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance();
    List<String> listaString =
        prefs.getStringList('listaProdutosTabelados') ?? [];
    return listaString
        .map((string) => TableProductsModel.fromJson(
            json.decode(string)))
        .toList();
  }

  TableProductsModel? search(int? tableProId) {
    for (int i = 0; i < tableProducts.length; i++) {
      if (tableProducts[i].id == tableProId) {
        return tableProducts[i];
      }
    }
    return null;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    tableProducts = await loadList();

    _titleController.text = title ?? '';
    _descriptionController.text = description ?? '';
    _stockController.text = stock?.toString() ?? '';
    
    // Mostrar o preço formatado para o usuário, mas mantendo o valor original
    if (salePrice != null && salePrice!.isNotEmpty) {
      try {
        double price = double.parse(salePrice!);
        // Usar o formato de moeda apenas para visualização
        _saleController.text = "R\$ ${price.toStringAsFixed(2)}".replaceAll('.', ',');
      } catch (e) {
        _saleController.text = salePrice ?? '';
      }
    }
    
    update();
  }
}
