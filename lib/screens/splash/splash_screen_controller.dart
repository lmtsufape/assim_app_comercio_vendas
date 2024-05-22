import 'dart:convert';
import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thunderapp/screens/screens_index.dart';
import 'package:thunderapp/shared/core/navigator.dart';
import 'package:thunderapp/shared/core/preferences_manager.dart';
import 'package:thunderapp/shared/core/user_storage.dart';

import '../../shared/constants/app_text_constants.dart';
import '../../shared/core/models/table_products_model.dart';

class SplashScreenController {
  final BuildContext context;
  bool isFirstTime = false;
  SplashScreenController(this.context);
  final Logger _logger = Logger(
      'Splash screen logger'); //a logger is always good to have
  final userStorage = UserStorage();

  ///this class is binded with SplashScreen widget and should be used
  /// to manage the startup logic of the app. ALL PRE LOAD DATA MUST BE HERE like the following:
  /// -- initialization of the app
  /// -- loading of the app
  /// -- getting startup data from the server
  /// -- setting and config startup data

  void initApplication(Function onComplete) async {

    ///initialize the application
    /// DO put all startup logic in here, the startup logic should be returned by futures
    /// so we can await the setup while the app don't freeze

    // navigatorKey.currentState!.pushReplacementNamed(Screens.signin);
    ///here we can put the logic that should be executed after the splash screen
    ///is shown for 3 seconds
    ///for example, we can go to the home screen after 3 seconds
    ///we can also use the following code to go to the home screen:
    ///Navigator.pushNamed(context, Screens.home);
    ///or we can use the following code to go to the sign in screen:
    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    await Future.delayed(const Duration(seconds: 3), () {
      getTableProducts();
      onComplete.call();
    });
    await configDefaultAppSettings();
    // });
  }

  Future configDefaultAppSettings() async {
    _logger.config('Configuring default app settings...');
    const String loadedKey = 'loadedFirstTime';
    final prefs = await SharedPreferences.getInstance();
    PreferencesManager.saveIsFirstTime();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _logger.fine('Default app settings configured!');
    final bool? isFirstTime = prefs.getBool(loadedKey);
    if (isFirstTime != null && isFirstTime) {
      log('First time user in: login');
      navigatorKey.currentState!
          .popAndPushNamed(Screens.signin);
    } else {
      log('User already open app: sign in or home');
      if (await userStorage.userHasCredentials()) {
        navigatorKey.currentState!
            .popAndPushNamed(Screens.start);
      } else {
        // ignore: use_build_context_synchronously
        navigatorKey.currentState!
            .popAndPushNamed(Screens.signin);
      }
    }
  }

  Future<bool> userHasToken() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final token = prefs.getString('token');
    if (token != null) {
      log('user has token');
      log(email!);
      log(token);
      return true;
    } else {
      log('user has no token');
      return false;
    }
  }

  void getTableProducts() async {
    Dio dio = Dio();
    UserStorage userStorage = UserStorage();
    List<TableProductsModel> products = [];

    var userToken = await userStorage.getUserToken();

    var response =
        await dio.get('$kBaseURL/produtos/tabelados',
            options: Options(
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer $userToken"
              },
            ));

    List<dynamic> responseData = response.data['produtos'];

    for (int i = 0; i < responseData.length; i++) {
      var product =
          TableProductsModel.fromJson(responseData[i]);
      products.add(product);
    }
    SharedPreferences prefs =
        await SharedPreferences.getInstance();
    List<String> listProducts = products
        .map((product) => json.encode(product.toJson()))
        .toList();
    prefs.setStringList(
        'listaProdutosTabelados', listProducts);
  }
}
