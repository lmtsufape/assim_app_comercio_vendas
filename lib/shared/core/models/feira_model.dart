class FeiraModel {
  int? id;
  String? nome;
  String? descricao;
  dynamic horariosFuncionamento;
  int? bairroId;
  int? associacaoId;

  FeiraModel({
    this.id,
    this.nome,
    this.descricao,
    this.horariosFuncionamento,
    this.bairroId,
    this.associacaoId,
  });

  factory FeiraModel.fromJson(Map<String, dynamic> json) {
    var horarios = json['horarios_funcionamento'];
    var horariosParsed;

    if (horarios != null) {
      if (horarios is List) {
        horariosParsed = List<String>.from(horarios);
      } else if (horarios is Map) {
        horariosParsed = Map.from(horarios).map((key, value) {
          return MapEntry(key, List<String>.from(value));
        });
      } else {
        throw Exception('Unexpected type for horarios_funcionamento');
      }
    }


    return FeiraModel(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      horariosFuncionamento: horariosParsed,
      bairroId: json['bairro_id'],
      associacaoId: json['associacao_id'],
    );
  }
}