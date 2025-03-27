class BancaModel {
  int id;
  String nome;
  String descricao;
  String horarioAbertura;
  String horarioFechamento;
  String precoMin;
  String pix;
  int feiraId;
  int agricultorId;
  String formasDePagamento;
  bool fazEntrega;

  BancaModel(
    this.id,
    this.nome,
    this.descricao,
    this.horarioAbertura,
    this.horarioFechamento,
    this.precoMin,
    this.pix,
    this.feiraId,
    this.agricultorId,
    {this.formasDePagamento = "1", this.fazEntrega = false}) {
    // Garantir que nenhum campo String seja null
    this.nome = nome ?? '';
    this.descricao = descricao ?? '';
    this.horarioAbertura = horarioAbertura ?? '';
    this.horarioFechamento = horarioFechamento ?? '';
    this.precoMin = precoMin ?? '0';
    this.pix = pix ?? '';
    this.formasDePagamento = formasDePagamento ?? '1';
  }

  // Getters com proteção contra null
  get getId => id;
  get getNome => nome ?? '';
  get getDescricao => descricao ?? '';
  get getHorarioAbertura => horarioAbertura ?? '';
  get getHorarioFechamento => horarioFechamento ?? '';
  get getPrecoMin => precoMin ?? '0';
  get getPix => pix ?? '';
  get getFeiraId => feiraId;
  get getAgricultorId => agricultorId;
  get getFormasDePagamento => formasDePagamento ?? '1';
  get getFazEntrega => fazEntrega;

  // Método para converter o modelo para um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome ?? '',
      'descricao': descricao ?? '',
      'horarioAbertura': horarioAbertura ?? '',
      'horarioFechamento': horarioFechamento ?? '',
      'precoMin': precoMin ?? '0',
      'pix': pix ?? '',
      'feiraId': feiraId,
      'agricultorId': agricultorId,
      'formasDePagamento': formasDePagamento ?? '1',
      'fazEntrega': fazEntrega,
    };
  }

  // Construtor de fábrica para criar uma instância a partir de um Map
  factory BancaModel.fromMap(Map<String, dynamic> map) {
    return BancaModel(
      map['id'] ?? 0,
      map['nome'] ?? '',
      map['descricao'] ?? '',
      map['horarioAbertura'] ?? '',
      map['horarioFechamento'] ?? '',
      map['precoMin'] ?? '0',
      map['pix'] ?? '',
      map['feiraId'] ?? 0,
      map['agricultorId'] ?? 0,
      formasDePagamento: map['formasDePagamento'] ?? '1',
      fazEntrega: map['fazEntrega'] ?? false,
    );
  }
}