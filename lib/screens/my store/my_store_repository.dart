import 'dart:developer';

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

    String? userToken = await userStorage.getUserToken();

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
          bairroId: responseData[i]["bairro_id"],
          associacaoId: responseData[i]["associacao_id"]);
      feiras.add(feira);
      print(feiras[i]);
    }

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return feiras;
    }
    return [];
  }

  //Função para editar a banca
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
    //Verifica se o usuário quer entrega ou retirada na banca e seta a variável entrega

    //Verifica se o usuário selecionou alguma forma de pagamento e seta a variável formasPagamento
    // a partir do checkItems, ele percorre o isSelected e verifica quais estão true,
    // e adiciona o valor de i + 1 no checkItems o i + 1 é o id da forma de pagamento, em seguida
    // ele percorre o checkItems e adiciona o valor de cada item no formasPagamento
    if (formasPagamento == '' && checkItems.isEmpty) {
      for (int i = 0; i < isSelected.length; i++) {
        if (isSelected[i] == true) {
          checkItems.add((i + 1).toString());
        }
      }
      for (int i = 0; i < checkItems.length; i++) {
        formasPagamento += '${checkItems[i]},';
      }
      //Remove a última vírgula da string
      formasPagamento =
          formasPagamento.substring(0, formasPagamento.length - 1);
    }

    String? userToken = await userStorage.getUserToken();
    print(banca.getPrecoMin);
    String precoMinimo = banca.getPrecoMin.toString();
    const find = "R\$";
    const replace = "";
    var pMinimo = precoMin.replaceAll(find, replace);
    var preMinimo = pMinimo.replaceAll(",", ".");

    try {
      //Se o usuário não selecionou uma imagem, ele envia o body sem a imagem para a API
      if (imgPath == null && entrega == true) {
        body = FormData.fromMap({
          "nome": nome.isEmpty ? banca.getNome.toString() : nome.toString(),
          "descricao": "loja",
          "horario_abertura": horarioAbertura.isEmpty
              ? banca.getHorarioAbertura.toString()
              : horarioAbertura.toString(),
          "horario_fechamento": horarioFechamento.isEmpty
              ? banca.getHorarioFechamento.toString()
              : horarioFechamento.toString(),
          "preco_minimo": precoMin.isEmpty
              ? banca.getPrecoMin.toString()
              : preMinimo.toString(),
          "formas_pagamento": formasPagamento.toString(),
          "entrega": entrega.toString(),
          "pix": pix.isEmpty ? banca.getPix.toString() : pix.toString(),
          "bairro entrega": "1=>4.50"
        });
        print(body.fields);
      } else if (entrega == true) {
        body = FormData.fromMap({
          "nome": nome.isEmpty ? banca.getNome.toString() : nome.toString(),
          "descricao": "loja",
          "horario_abertura": horarioAbertura.isEmpty
              ? banca.getHorarioAbertura.toString()
              : horarioAbertura.toString(),
          "horario_fechamento": horarioFechamento.isEmpty
              ? banca.getHorarioFechamento.toString()
              : horarioFechamento.toString(),
          "preco_minimo":
              precoMin.isEmpty ? banca.getPrecoMin : preMinimo.toString(),
          "feira_id": feiraId.isEmpty
              ? banca.feiraId.toString()
              : feiraId.toString(),
          "imagem": await MultipartFile.fromFile(
            imgPath.toString(),
            filename: imgPath?.split("\\").last,
          ),
          "formas pagamento": formasPagamento.toString(),
          "entrega": entrega.toString(),
          "pix": pix.toString(),
          "bairro entrega": "1=>4.50"
        });
        print(body.fields);
      } else if (imgPath == null && entrega == false) {
        body = FormData.fromMap({
          "nome": nome.isEmpty ? banca.getNome.toString() : nome.toString(),
          "descricao": "loja",
          "horario_abertura": horarioAbertura.isEmpty
              ? banca.getHorarioAbertura.toString()
              : horarioAbertura.toString(),
          "horario_fechamento": horarioFechamento.isEmpty
              ? banca.getHorarioFechamento.toString()
              : horarioFechamento.toString(),
          "feira_id": feiraId.isEmpty
              ? banca.feiraId.toString()
              : feiraId.toString(),
          "formas_pagamento": formasPagamento.toString(),
          "entrega": entrega.toString(),
          "pix": pix.toString(),
          "bairro entrega": "1=>4.50"
        });
        print(body.fields);
      } else {
        body = FormData.fromMap({
          "nome": nome.isEmpty ? banca.getNome.toString() : nome.toString(),
          "descricao": "loja",
          "horario_abertura": horarioAbertura.isEmpty
              ? banca.getHorarioAbertura.toString()
              : horarioAbertura.toString(),
          "horario_fechamento": horarioFechamento.isEmpty
              ? banca.getHorarioFechamento.toString()
              : horarioFechamento.toString(),
          "imagem": await MultipartFile.fromFile(
            imgPath.toString(),
            filename: imgPath?.split("\\").last,
          ),
          "feira_id": feiraId.isEmpty
              ? banca.feiraId.toString()
              : feiraId.toString(),
          "formas pagamento": formasPagamento.toString(),
          "entrega": entrega.toString(),
          "pix": pix.toString(),
          "bairro entrega": "1=>4.50"
        });
        print(body.fields);
      }
      Response response = await _dio.post('$kBaseURL/bancas/${banca.getId}',
          options: Options(
            headers: {
              "Authorization": "Bearer $userToken",
              "Content-Type": "multipart/form-data",
              "X-HTTP-Method-Override": "PATCH"
            },
          ),
          data: body);
      if (response.statusCode == 200) {
        print('banca editada com sucesso');
        print(body.fields);
        return true;
      } else {
        final errorMessage = response.data['errors'];
        print('Erro: $errorMessage');
        print('erro ao editar a banca ${response.statusCode}}');
        print(body.fields);
        return false;
      }
    } catch (e) {
      if (e is DioError) {
        final dioError = e;
        if (dioError.response != null) {
          final errorMessage = dioError.response!.data['errors'];
          print('Erro: $errorMessage');
          print("Erro ${e.toString()}");
          print(body.fields);
          return false;
        }
      }
    }
    print(body);
    return false;
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
    const find = "R\$";
    const replace = "";
    var pMinimo = precoMin.replaceAll(find, replace);
    var preMinimo = pMinimo.replaceAll(",", ".");

    if (formasPagamento == '' && checkItems.isEmpty) {
      for (int i = 0; i < isSelected.length; i++) {
        if (isSelected[i] == true) {
          checkItems.add((i + 1).toString());
        }
      }
      for (int i = 0; i < checkItems.length; i++) {
        formasPagamento += '${checkItems[i]},';
      }
      //Remove a última vírgula da string
      formasPagamento =
          formasPagamento.substring(0, formasPagamento.length - 1);
    }
    String? userToken = await userStorage.getUserToken();
    String? userId = await userStorage.getUserId();
    try {
      if (entrega == true) {
        body = FormData.fromMap({
          "nome": nome.toString(),
          "descricao": 'loja',
          "horario_abertura": horarioAbertura.toString(),
          "horario_fechamento": horarioFechamento.toString(),
          "preco_minimo": preMinimo.toString(),
          "imagem": await MultipartFile.fromFile(
            imgPath.toString(),
            filename: imgPath!.split("\\").last,
          ),
          "formas pagamento": formasPagamento.toString(),
          "entrega": entrega.toString(),
          "pix": pix.toString(),
          "agricultor_id": userId.toString(),
          "feira_id": feiraId.toString(),
          "bairro entrega": '1=>3.50'
        });
        print(body.fields);
      } else {
        body = FormData.fromMap({
          "nome": nome.toString(),
          "descricao": 'loja',
          "horario_abertura": horarioAbertura.toString(),
          "horario_fechamento": horarioFechamento.toString(),
          "imagem": await MultipartFile.fromFile(
            imgPath.toString(),
            filename: imgPath!.split("\\").last,
          ),
          "formas pagamento": formasPagamento.toString(),
          "entrega": entrega.toString(),
          "pix": pix.toString(),
          "agricultor_id": userId.toString(),
          "feira_id": feiraId.toString(),
          "bairro entrega": '1=>3.50'
        });
        print(body.fields);
      }

      Response response = await _dio.post(
        '$kBaseURL/bancas',
        options: Options(headers: {
          "Content-Type": "multipart/form-data",
          "Authorization": "Bearer $userToken"
        }),
        data: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        log('cadastro da banca bem sucedida');
        // Mostrar o statusCode em um AlertDialog
        return true;
      } else {
        formasPagamento = '';
        checkItems = [];
        return false;
      }
    } catch (e) {
      formasPagamento = '';
      checkItems = [];
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


/*void _showAlertDialog(BuildContext context, String title, String content) {
    // Código para outras plataformas (como mobile)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }*/
}
