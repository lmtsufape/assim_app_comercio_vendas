class ProductsModel {
  String? nome;
  int? id;
  String? createdAt;
  String? updatedAt;
  String? descricao;
  String? titulo;
  String? tipoMedida;
  int? estoque;
  double? preco;
  double? custo;
  bool? disponivel;
  int? bancaId;
  int? produtoTabeladoId;

  ProductsModel({
    this.nome,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.descricao,
    this.titulo,
    this.tipoMedida,
    this.estoque,
    this.preco,
    this.custo,
    this.disponivel,
    this.bancaId,
    this.produtoTabeladoId,
  });

  ProductsModel.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    descricao = json['descricao'];
    titulo = json['titulo'];
    tipoMedida = json['tipo_medida'];
    estoque = json['estoque'];
    preco = json['preco'];
    custo = json['custo'];
    disponivel = json['disponivel'];
    bancaId = json['banca_id'];
    produtoTabeladoId = json['produto_tabelado_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =
        <String, dynamic>{};
    data['nome'] = nome;
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['descricao'] = descricao;
    data['titulo'] = titulo;
    data['tipo_medida'] = tipoMedida;
    data['estoque'] = estoque;
    data['preco'] = preco;
    data['custo'] = custo;
    data['disponivel'] = disponivel;
    data['banca_id'] = bancaId;
    data['produto_tabelado_id'] = produtoTabeladoId;

    return data;
  }
}