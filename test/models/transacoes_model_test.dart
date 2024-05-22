import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:thunderapp/shared/core/models/item_model.dart';
import 'package:thunderapp/shared/core/models/transacoes_model.dart';


void main() async{
  TestWidgetsFlutterBinding.ensureInitialized();
  String stringJsonObjectTransacoes= '{"id":1,"status":"Concluído","data_pedido":"1983-02-04 06:20:09","subtotal":"26.59","taxa_entrega":"8.12","total":"23.79","comprovante_pagamento":null,"forma_pagamento_id":1,"consumidor_id":1,"produtor_id":1,"created_at":"2023-06-09T14:46:18.000000Z","updated_at":"2023-06-09T14:46:18.000000Z","itens":[{"id":1,"tipo_unidade":"unidade","quantidade":8,"preco":"1.60","produto_id":7,"venda_id":1,"created_at":"2023-06-09T14:46:18.000000Z","updated_at":"2023-06-09T14:46:18.000000Z"},{"id":2,"tipo_unidade":"unidade","quantidade":5,"preco":"12.86","produto_id":10,"venda_id":1,"created_at":"2023-06-09T14:46:18.000000Z","updated_at":"2023-06-09T14:46:18.000000Z"}]}';
  String strtingJsonObjectItem = '{"id":2,"tipo_unidade":"unidade","quantidade":5,"preco":"12.86","produto_id":10,"venda_id":1,"created_at":"2023-06-09T14:46:18.000000Z","updated_at":"2023-06-09T14:46:18.000000Z"}';
  test('Convert a string on a map', () async{

    Map<String, dynamic> data = jsonDecode(stringJsonObjectTransacoes);

    expect(data.isNotEmpty, true);
  });

  test('Create a Item Model from Json', () async{

    Map<String, dynamic> data = jsonDecode(strtingJsonObjectItem);
    ItemModel itemModel = ItemModel.fromJson(data);
    expect(itemModel.id, 2);
  });

  test('Create TransacoesModel from Json', () async{
    Map<String, dynamic> data = jsonDecode(stringJsonObjectTransacoes);
    TransacoesModel transacoesModel = TransacoesModel.fromJson(data);
    expect(transacoesModel.id, 1);
  });

}