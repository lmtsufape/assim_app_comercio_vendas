class BairroModel {
  int? id;
  String? nome;
  String? taxa;

  BairroModel({this.id, this.nome, this.taxa});

  BairroModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    taxa = json['taxa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    data['taxa'] = taxa;
    return data;
  }
}
