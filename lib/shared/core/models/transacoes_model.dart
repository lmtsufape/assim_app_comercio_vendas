import 'package:thunderapp/shared/core/models/item_model.dart';

class TransacoesModel {
    String comprovante_pagamento;
    int consumidor_id;
    String created_at;
    String data_pedido;
    int forma_pagamento_id;
    int id;
    List<ItemModel> itens;
    int produtor_id;
    String status;
    String subtotal;
    String taxa_entrega;
    String total;
    String updated_at;

    TransacoesModel(
        {
            required this.comprovante_pagamento,
            required this.consumidor_id,
            required this.created_at,
            required this.data_pedido,
            required this.forma_pagamento_id,
            required this.id,
            required this.itens,
            required this.produtor_id,
            required this.status,
            required this.subtotal,
            required this.taxa_entrega,
            required this.total,
            required this.updated_at
        });

    factory TransacoesModel.fromJson(Map<String, dynamic> json) {
        return TransacoesModel(
            comprovante_pagamento: json['comprovante_pagamento'] ?? '',
            consumidor_id: json['consumidor_id'], 
            created_at: json['created_at'], 
            data_pedido: json['data_pedido'], 
            forma_pagamento_id: json['forma_pagamento_id'], 
            id: json['id'],
            itens: (json['itens'] as List).map((i) => ItemModel.fromJson(i)).toList(),
          produtor_id: json['produtor_id'],
            status: json['status'], 
            subtotal: json['subtotal'], 
            taxa_entrega: json['taxa_entrega'], 
            total: json['total'], 
            updated_at: json['updated_at'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['consumidor_id'] = consumidor_id;
        data['created_at'] = created_at;
        data['data_pedido'] = data_pedido;
        data['forma_pagamento_id'] = forma_pagamento_id;
        data['id'] = id;
        data['produtor_id'] = produtor_id;
        data['status'] = status;
        data['subtotal'] = subtotal;
        data['taxa_entrega'] = taxa_entrega;
        data['total'] = total;
        data['updated_at'] = updated_at;
        data['comprovante_pagamento'] = comprovante_pagamento;
          data['itens'] = itens.map((v) => v.toJson()).toList();
              return data;
    }
}