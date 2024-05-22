import 'package:thunderapp/shared/core/models/transacoes_model.dart';

class VendasModel {
    List<TransacoesModel> transacoes;

    VendasModel({required this.transacoes});

    factory VendasModel.fromJson(Map<String, dynamic> json) {
        return VendasModel(
            transacoes: List<TransacoesModel>.from( (json['transações'] as List) )
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
          data['transacoes'] = transacoes.map((v) => v.toJson()).toList();
        return data;
    }
}