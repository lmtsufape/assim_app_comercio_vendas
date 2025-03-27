import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:thunderapp/shared/constants/app_text_constants.dart';
import 'package:thunderapp/shared/core/models/banca_model.dart';
import 'package:thunderapp/shared/core/user_storage.dart';
import '../../shared/core/models/feira_model.dart';

class MyStoreRepository {
  List<String> checkItems = [];
  bool? entrega;
  FormData body = FormData.fromMap({});
  String formasPagamento = '';
  UserStorage userStorage = UserStorage();
  final Dio _dio = Dio();
  List<FeiraModel> feiras = [];
  FeiraModel feira = FeiraModel();

  Future<List<FeiraModel>> getFeiras() async {
    Dio dio = Dio();
    UserStorage userStorage = UserStorage();
    feiras = []; // Limpar a lista antes de preencher

    String? userToken = await userStorage.getUserToken();

    try {
      var response =
      await dio.get('$kBaseURL/feiras',
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $userToken"
            },
          ));

      List<dynamic> responseData = response.data['feiras'];

      for (int i = 0; i < responseData.length; i++) {
        feira = FeiraModel(
            id: responseData[i]["id"],
            nome: responseData[i]["nome"],
            descricao: responseData[i]["descricao"],
            horariosFuncionamento: responseData[i]["horarios_funcionamento"],
            /*bairroId: responseData[i]["bairro_id"],*/
            associacaoId: responseData[i]["associacao_id"]);
        feiras.add(feira);
      }

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return feiras;
      }
    } catch (e) {
      log("Erro ao carregar feiras: $e");
    }
    return [];
  }

  Future<bool> editarBanca(
      String nome,
      String horarioAbertura,
      String horarioFechamento,
      String precoMin,
      String feiraId,
      String? imgPath,
      List<bool> isSelected,
      String pix,
      bool? entrega,
      BancaModel banca) async {
    
    // Resetar variáveis para nova edição
    formasPagamento = '';
    checkItems = [];
    
    // Verificar formas de pagamento selecionadas
    for (int i = 0; i < isSelected.length; i++) {
      if (isSelected[i] == true) {
        checkItems.add((i + 1).toString());
      }
    }
    
    // Se nenhuma forma de pagamento foi selecionada, retorna falso
    if (checkItems.isEmpty) {
      log("Erro: Nenhuma forma de pagamento selecionada");
      return false;
    }

    // Se nenhuma forma de pagamento for selecionada, considere dinheiro como padrão
    if (checkItems.isEmpty) {
      checkItems.add("1"); // Dinheiro como padrão
    }
    
    for (int i = 0; i < checkItems.length; i++) {
      formasPagamento += '${checkItems[i]},';
    }
    
    // Remove a última vírgula da string se existir alguma forma de pagamento
    if (formasPagamento.isNotEmpty) {
      formasPagamento = formasPagamento.substring(0, formasPagamento.length - 1);
    }

    String? userToken = await userStorage.getUserToken();
    if (userToken == null || userToken.isEmpty) {
      log("Erro: Token de usuário não encontrado");
      return false;
    }
    
    // Tratamento do preço mínimo (se fornecido)
    String precoMinimo = '';
    if (precoMin.isNotEmpty) {
      const find = "R\$";
      const replace = "";
      var pMinimo = precoMin.replaceAll(find, replace);
      precoMinimo = pMinimo.replaceAll(",", ".");
    }

    try {
      // Criamos um Map dinâmico para incluir apenas os campos que foram alterados
      Map<String, dynamic> formFields = {};
      
      // Adiciona campos somente se foram alterados
      if (nome.isNotEmpty) formFields["nome"] = nome;
      formFields["descricao"] = "loja"; // Campo obrigatório
      
      // Adiciona horários, usando o valor original se não for alterado
      formFields["horario_abertura"] = horarioAbertura.isNotEmpty 
          ? horarioAbertura 
          : banca.horarioAbertura;
      
      formFields["horario_fechamento"] = horarioFechamento.isNotEmpty 
          ? horarioFechamento 
          : banca.horarioFechamento;
      
      if (precoMin.isNotEmpty) formFields["preco_minimo"] = precoMinimo;
      
      // Adicionar formas de pagamento (obrigatório)
      formFields["formas_pagamento"] = formasPagamento;
      
      // Sempre enviar a entrega como boolean
      /*formFields["entrega"] = entrega == true ? "true" : "false";
      
      // Adicionar bairro de entrega apenas se entrega for true
      if (entrega == true) {
        // Corrigir formato do bairro_entrega
        formFields["bairro_entrega"] = {
          "1": "4.50"
        };
      }*/
      
      // Só envia pix se foi preenchido
      if (pix.isNotEmpty) formFields["pix"] = pix;
      
      // Adiciona imagem apenas se foi selecionada uma nova
      if (imgPath != null) {
        try {
          formFields["imagem"] = await MultipartFile.fromFile(
            imgPath,
            filename: imgPath.split(Platform.pathSeparator).last,
          );
        } catch (e) {
          log("Erro ao carregar imagem: $e");
          // Continuar sem a imagem se houver erro
        }
      }

      Map<String, dynamic> encodableFields = Map.from(formFields);
      encodableFields.removeWhere((key, value) => value is MultipartFile);

      log("Formato completo dos campos: ${jsonEncode(encodableFields)}");

      log("Campos para log: ${encodableFields.map((key, value) => MapEntry(key, value.toString()))}");

      // Cria o FormData apenas com os campos modificados
      body = FormData.fromMap(formFields);
      
      // Adicionar ID da feira 
      if (feiraId.isNotEmpty) {
        formFields["feira_id"] = int.tryParse(feiraId) ?? banca.feiraId;
      }
      
      // Cria o FormData apenas com os campos modificados
      body = FormData.fromMap(formFields);
      
      log("Campos a serem enviados: ${body.fields}");
      log("URL: $kBaseURL/bancas/${banca.getId}");

      // Enviar para a API
      Response response = await _dio.post('$kBaseURL/bancas/${banca.getId}',
        options: Options(
          headers: {
            "Authorization": "Bearer $userToken",
            "Content-Type": "multipart/form-data",
            "X-HTTP-Method-Override": "PATCH"
          },
        ),
        data: body);
          
      log("Status da resposta: ${response.statusCode}");
      log("Resposta: ${response.data}");
      
      if (response.statusCode == 200) {
        log('Banca editada com sucesso');
        return true;
      } else {
        var errorMessage = "Erro desconhecido";
        if (response.data is Map && response.data['errors'] != null) {
          errorMessage = response.data['errors'].toString();
        }
        log('Erro: $errorMessage');
        log('Erro ao editar a banca: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      if (e is DioError) {
        final dioError = e;
        if (dioError.response != null) {
          var errorData = dioError.response!.data;
          var errorMessage = "Erro desconhecido";
          
          if (errorData is Map && errorData['errors'] != null) {
            errorMessage = errorData['errors'].toString();
          }
          
          log('Erro da API: ${dioError.response!.statusCode}');
          log('Detalhes: $errorMessage');
        } else {
          log('Erro de comunicação: ${dioError.message}');
        }
      } else {
        log("Erro não tratado na edição: $e");
      }
      log("Erro completo na edição: $e");
      return false;
    }
  }

  Future<bool> adicionarBanca(
      String nome,
      String horarioAbertura,
      String horarioFechamento,
      String precoMin,
      String feiraId,
      String? imgPath,
      List<bool> isSelected,
      bool? entrega,
      String? pix) async {
    // Resetar variáveis para nova adição
    formasPagamento = '';
    checkItems = [];
    
    // Se nenhuma forma de pagamento foi selecionada, retorna falso
    if (isSelected.every((element) => element == false)) {
      log("Erro: Nenhuma forma de pagamento selecionada");
      return false;
    }
    
    // Tratamento do preço
    const find = "R\$";
    const replace = "";
    var pMinimo = precoMin.replaceAll(find, replace);
    var preMinimo = pMinimo.replaceAll(",", ".");

    // Verificar formas de pagamento selecionadas
    for (int i = 0; i < isSelected.length; i++) {
      if (isSelected[i] == true) {
        checkItems.add((i + 1).toString());
      }
    }
    
    for (int i = 0; i < checkItems.length; i++) {
      formasPagamento += '${checkItems[i]},';
    }
    
    // Remove a última vírgula da string
    if (formasPagamento.isNotEmpty) {
      formasPagamento = formasPagamento.substring(0, formasPagamento.length - 1);
    }
    
    String? userToken = await userStorage.getUserToken();
    if (userToken == null || userToken.isEmpty) {
      log("Erro: Token de usuário não encontrado");
      return false;
    }
    
    String? userId = await userStorage.getUserId();
    if (userId == null || userId.isEmpty) {
      log("Erro: ID de usuário não encontrado");
      return false;
    }
    
    try {
      // Campos obrigatórios para adicionar banca
      Map<String, dynamic> formFields = {
        "nome": nome,
        "descricao": 'loja',
        "horario_abertura": horarioAbertura,
        "horario_fechamento": horarioFechamento,
        "formas_pagamento": formasPagamento,
        "agricultor_id": userId.toString(),
        "feira_id": feiraId,
      };
      
      // Adiciona imagem se foi fornecida
      if (imgPath != null) {
        try {
          formFields["imagem"] = await MultipartFile.fromFile(
            imgPath,
            filename: imgPath.split("\\").last,
          );
        } catch (e) {
          log("Erro ao carregar imagem: $e");
          // Continuar sem a imagem se houver erro
        }
      }
      
      // Adiciona campos opcionais
      // Comentado para não enviar bairro_entrega
      /*if (entrega == true) {
        formFields["entrega"] = "true";
        formFields["preco_minimo"] = preMinimo;
        formFields["bairro_entrega"] = '1=>3.50';
      } else {
        formFields["entrega"] = "false";
      }*/

      // Adiciona entrega como campo obrigatório
      formFields["entrega"] = entrega == true ? "true" : "false";
      
      // Adiciona PIX se fornecido
      if (pix != null && pix.isNotEmpty) {
        formFields["pix"] = pix;
      }

      body = FormData.fromMap(formFields);
      log("Campos para adicionar banca: ${body.fields}");

      Response response = await _dio.post(
        '$kBaseURL/bancas',
        options: Options(headers: {
          "Content-Type": "multipart/form-data",
          "Authorization": "Bearer $userToken"
        }),
        data: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        log('Cadastro da banca bem sucedido');
        return true;
      } else {
        var errorMessage = "Erro desconhecido";
        if (response.data is Map && response.data['errors'] != null) {
          errorMessage = response.data['errors'].toString();
        }
        log('Erro no cadastro da banca: ${response.statusCode}');
        log('Detalhes: $errorMessage');
        return false;
      }
    } catch (e) {
      if (e is DioError) {
        final dioError = e;
        if (dioError.response != null) {
          var errorData = dioError.response!.data;
          var errorMessage = "Erro desconhecido";
          
          if (errorData is Map && errorData['errors'] != null) {
            errorMessage = errorData['errors'].toString();
          }
          
          log('Erro da API: ${dioError.response!.statusCode}');
          log('Detalhes: $errorMessage');
        } else {
          log('Erro de comunicação: ${dioError.message}');
        }
      }
      log("Erro ao adicionar banca: $e");
      return false;
    }
  }
}