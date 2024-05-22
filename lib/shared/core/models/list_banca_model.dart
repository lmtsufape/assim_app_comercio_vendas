class ListBancaModel {
  int? id;
  String? nome;
  String? descricao;
  String? horarioAbertura;
  String? horarioFechamento;
  String? precoMin;
  String? pix;
  int? feiraId;
  int? agricultorId;

  ListBancaModel({
    this.id,
    this.nome,
    this.descricao,
    this.horarioAbertura,
    this.horarioFechamento,
    this.precoMin,
    this.pix,
    this.feiraId,
    this.agricultorId,
  });

  ListBancaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricao = json['descricao'];
    horarioAbertura = json['horario_abertura'];
    horarioFechamento = json['horario_fechamento'];
    precoMin = json['preco_minimo'];
    pix = json['pix'];
    feiraId = json['feira_id'];
    agricultorId = json['agricultor_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    data['descricao'] = descricao;
    data['horario_abertura'] = horarioAbertura;
    data['horario_fechamento'] = horarioFechamento;
    data['preco_minimo'] = precoMin;
    data['pix'] = pix;
    data['feira_id'] = feiraId;
    data['agricultor_id'] = agricultorId;

    return data;
  }
}
