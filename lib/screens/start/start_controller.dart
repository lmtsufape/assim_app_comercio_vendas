import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:thunderapp/screens/start/start_repository.dart';
import 'package:thunderapp/shared/core/user_storage.dart';

import '../../shared/core/navigator.dart';
import '../screens_index.dart';


class StartController extends GetxController {

  UserStorage userStorage = UserStorage();
  StartRepository startRepository = StartRepository();
  String? userToken;
  String? userId;
  String userName = 'teste';

  Future startVeri(BuildContext context) async {
    var succ = await startRepository.start(
      userToken = await userStorage.getUserToken(),
      userId = await userStorage.getUserId(),
    );
    if(succ == 1){
      navigatorKey.currentState!
          .pushReplacementNamed(Screens.home);
    }
    else if(succ == 2){
      navigatorKey.currentState!.pushReplacementNamed(Screens.addStore);
      print('cadastro');
    }
    else{
      print('erro');
    }
  }

  Future getUserName() async {
    userName = await userStorage.getUserName();
    update();
  }


  @override
  void onInit() {
    super.onInit();
    getUserName();
  }
}
