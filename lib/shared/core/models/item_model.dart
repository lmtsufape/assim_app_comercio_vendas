class ItemModel {
    String created_at;
    int id;
    String preco;
    int produto_id;
    int quantidade;
    String tipo_unidade;
    String updated_at;
    int venda_id;

    ItemModel(
        {
            required this.created_at,
            required this.id,
            required this.preco,
            required this.produto_id,
            required this.quantidade,
            required this.tipo_unidade,
            required this.updated_at,
            required this.venda_id
        });

    factory ItemModel.fromJson(Map<String, dynamic> json) {
        return ItemModel(
            created_at: json['created_at'], 
            id: json['id'], 
            preco: json['preco'], 
            produto_id: json['produto_id'], 
            quantidade: json['quantidade'], 
            tipo_unidade: json['tipo_unidade'], 
            updated_at: json['updated_at'], 
            venda_id: json['venda_id'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['created_at'] = created_at;
        data['id'] = id;
        data['preco'] = preco;
        data['produto_id'] = produto_id;
        data['quantidade'] = quantidade;
        data['tipo_unidade'] = tipo_unidade;
        data['updated_at'] = updated_at;
        data['venda_id'] = venda_id;
        return data;
    }
}

