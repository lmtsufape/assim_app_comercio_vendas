import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thunderapp/screens/orders/orders_controller.dart';

class ItensPedidoWidget extends StatelessWidget {
  final int pedidoId;
  final OrdersController controller = Get.find();

  ItensPedidoWidget({super.key, required this.pedidoId});

  @override
  Widget build(BuildContext context) {
    var itens = controller.getItensDoPedido(pedidoId);

    return itens.isEmpty
        ? const Center(
      child: Text('Nenhum item encontrado'),
    )
        : ListView.builder(
      shrinkWrap: true,
      itemCount: itens.length,
      itemBuilder: (context, index) {
        var item = itens[index];
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${item.quantidade} ${item.tipoUnidade} x ${item.titulo}',
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: const TextStyle(fontSize: 12),
              ),
              Text('R\$ ${item.preco?.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}
