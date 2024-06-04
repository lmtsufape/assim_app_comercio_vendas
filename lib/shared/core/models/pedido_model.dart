import 'package:thunderapp/shared/core/models/produto_pedido_model.dart';

class PedidoModel {
  int? id;
  String? status;
  String? tipoEntrega;
  double? subtotal;
  double? taxaEntrega;
  double? total;
  DateTime? dataPedido;
  DateTime? dataConfirmacao;
  DateTime? dataCancelamento;
  DateTime? dataPagamento;
  DateTime? dataEnvio;
  DateTime? dataEntrega;
  int consumidorId;
  String? formaDePagamento;
  int? bancaId;
  String? consumidorName;
  String? consumidorEmail;
  List<ProdutoPedidoModel>? listaDeProdutos;

  PedidoModel({
    this.id,
    this.status,
    this.tipoEntrega,
    this.subtotal,
    this.taxaEntrega,
    this.total,
    this.dataPedido,
    this.dataConfirmacao,
    this.dataCancelamento,
    this.dataPagamento,
    this.dataEnvio,
    this.dataEntrega,
    this.formaDePagamento,
    this.consumidorEmail,
    this.consumidorName,
    required this.consumidorId,
    this.listaDeProdutos,
    this.bancaId,
  });

  factory PedidoModel.fromJson(Map<String, dynamic> json) {
    List<ProdutoPedidoModel> listaTemp = [];
    if (json['itens'] != null) {
      List<dynamic> itens = json['itens'];
      for (var item in itens) {
        ProdutoPedidoModel produto = ProdutoPedidoModel(
          id: item['id'],
          tipoUnidade: item['tipo_medida'],
          quantidade: item['quantidade'],
          preco: double.parse(item['preco'].toString()),
          titulo: item['produto']?['titulo']?.toString() ?? '',
        );
        listaTemp.add(produto);
      }
    }
    return PedidoModel(
      id: json['id'],
      status: json['status'],
      tipoEntrega: json['tipo_entrega'],
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '') ?? 0.0,
      taxaEntrega: double.tryParse(json['taxa_entrega']?.toString() ?? '') ?? 0.0,
      total: double.tryParse(json['total']?.toString() ?? '') ?? 0.0,
      dataPedido: json['data_pedido'] != null ? DateTime.tryParse(json['data_pedido']) : null,
      dataConfirmacao: json['data_confirmacao'] != null ? DateTime.tryParse(json['data_confirmacao']) : null,
      dataCancelamento: json['data_cancelamento'] != null ? DateTime.tryParse(json['data_cancelamento']) : null,
      dataPagamento: json['data_pagamento'] != null ? DateTime.tryParse(json['data_pagamento']) : null,
      dataEnvio: json['data_envio'] != null ? DateTime.tryParse(json['data_envio']) : null,
      dataEntrega: json['data_entrega'] != null ? DateTime.tryParse(json['data_entrega']) : null,
      consumidorEmail: json['consumidor']?['email'],
      consumidorName: json['consumidor']?['name'],
      consumidorId: json['consumidor_id'],
      bancaId: json['banca_id'],
      formaDePagamento: json['forma_pagamento']?['tipo'],
      listaDeProdutos: listaTemp,
    );
  }

  get getId => id;
  get getStatus => status;
  get getDataPedido => dataPedido;
  get getSubtotal => subtotal;
  get getTaxaEntrega => taxaEntrega;
  get getTotal => total;
  get getTipoEntrega => tipoEntrega;
}
