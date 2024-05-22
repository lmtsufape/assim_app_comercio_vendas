
import 'package:thunderapp/shared/constants/app_text_constants.dart';
import 'package:thunderapp/shared/core/http/exceptions.dart';
import 'package:thunderapp/shared/core/http/http_client.dart';
import 'package:thunderapp/shared/core/models/transacoes_model.dart';
import 'package:thunderapp/shared/core/user_storage.dart';

abstract class ITransacoesRepository  {
  Future<List<TransacoesModel>> getTransacoes();
}

class TransasoesRepository implements ITransacoesRepository {
  final IHttpClient client;
  final UserStorage userStorage = UserStorage();

  TransasoesRepository({required this.client});


  @override
  Future<List<TransacoesModel>> getTransacoes() async{
    final response = await client.get(
      url: '$kBaseURL/vendas',
      userToken: await userStorage.getUserToken()
    );

    if (response.statusCode == 200){
      final List<TransacoesModel> transacoes = [];

      response.data['transações'].forEach((item) {
        TransacoesModel transacao = TransacoesModel.fromJson(item);
        transacoes.add(transacao);
      });
      return transacoes;
    } else if (response.statusCode == 404){
      throw NotFundException('A url informada é invalida...');
    } else if (response.statusCode == 500){
      throw Exception('Erro 500....');
    } else {
      throw Exception('Não foi possível carregar suas transaões...');
    }
  }

}