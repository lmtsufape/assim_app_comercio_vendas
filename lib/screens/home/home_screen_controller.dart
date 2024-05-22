import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thunderapp/screens/home/home_screen_repository.dart';
import 'package:thunderapp/shared/core/models/banca_model.dart';
import 'package:thunderapp/shared/core/models/list_banca_model.dart';
import 'package:thunderapp/shared/core/user_storage.dart';

class HomeScreenController extends GetxController {
  UserStorage userStorage = UserStorage();
  HomeScreenRepository homeScreenRepository =
      HomeScreenRepository();
  String? userToken;
  BancaModel? bancaModel;
  RxInt banca = 0.obs;
  String? userId;
  RxList<ListBancaModel> bancas = <ListBancaModel>[].obs;

  void loadBancas() async {
    userId = await userStorage.getUserId();
    bancas.value = await homeScreenRepository.getBancas(userId!);
    update();
  }

  void setBanca(int value) async{
    banca.value = value;
    print("valor do index da banca: $banca");
    await getBancaPrefs();
    update();
  }

  Future getBancaPrefs() async {
    userId = await userStorage.getUserId();
    userToken = await userStorage.getUserToken();
    bancaModel = await homeScreenRepository.getBancaPrefs(
        userToken, userId, banca.value);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    loadBancas();
    print("valor da banca: $banca");
    getBancaPrefs();
    update();
  }
}
