import 'package:flutter/cupertino.dart';
import 'package:thunderapp/shared/core/http/exceptions.dart';
import 'package:thunderapp/shared/core/models/transacoes_model.dart';
import 'package:thunderapp/shared/core/repositories/transacoes_repository.dart';

class TransacaoStore {

  final ITransacoesRepository repository;

  //variavel reativa para loading
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  //variavel reativa para state
  final ValueNotifier<List<TransacoesModel>> state = ValueNotifier<List<TransacoesModel>>([]);

  //variavel reativa para error
  final ValueNotifier<String> erro = ValueNotifier<String>('');


  TransacaoStore({required this.repository});

  Future getTransacoes() async {
    isLoading.value = true;

    try {
      final result = await repository.getTransacoes();
      state.value = result;
    }on NotFundException catch (e){
      erro.value = e.menssage;
    } catch (e){
      erro.value = e.toString();
    }

    isLoading.value = false;
  }
}