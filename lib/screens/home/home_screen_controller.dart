import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
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
  int banca = 0;
  String? userId;
  List<ListBancaModel> bancas = [];

  void loadBancas() async {
    userId = await userStorage.getUserId();
    bancas = await homeScreenRepository.getBancas(userId!);
    update();
  }

  void setBanca(int value) {
    banca = value;
    update();
  }

  Future getBancaPrefs() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance();
    userId = await userStorage.getUserId();
    userToken = await userStorage.getUserToken();
    bancaModel = await homeScreenRepository.getBancaPrefs(
        userToken, userId);
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
