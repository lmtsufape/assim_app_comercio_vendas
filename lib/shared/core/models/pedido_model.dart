
import 'package:thunderapp/shared/core/models/produto_pedido_model.dart';



class PedidoModel{

  int? id;
  String? status;
  String? tipoEntrega;
  double? subtotal;
  double? taxaEntrega;
  double? total;
  String? dataPedido;
 
  


  PedidoModel({
      this.id,
      this.status,
      this.tipoEntrega,
      this.subtotal,
      this.taxaEntrega,
      this.total,
      this.dataPedido,
});

  get getId => id;
  get getStatus => status;
  get getDataPedido => dataPedido;
  get getSubtotal => subtotal;
  get getTaxaEntrega => taxaEntrega;
  get getTotal => total;

  get getTipoEntrega => tipoEntrega;

}