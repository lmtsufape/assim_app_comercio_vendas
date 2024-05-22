import 'dart:convert';
import 'dart:typed_data';

class TableProductsModel {
  int? id;
  String? nome;
  String? categoria;
  Uint8List? imagem;

  TableProductsModel({this.id, this.nome, this.categoria, this.imagem});

  TableProductsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    categoria = json['categoria'];
    if (json['imagem'] != null) {
      // Decodifica a imagem de base64
      List<int> bytes = base64Decode(json['imagem']);

      // Atribui os bytes decodificados à propriedade 'imagem'
      imagem = Uint8List.fromList(bytes);
    } else {
      imagem = null;
    }}

    Map<String, dynamic> toJson() => {
          'id': id,
          'nome': nome,
          'categoria': categoria,
          'imagem': imagem != null ? base64Encode(imagem!) : null,
        };
  }

