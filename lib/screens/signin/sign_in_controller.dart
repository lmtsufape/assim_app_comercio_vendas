import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thunderapp/screens/screens_index.dart';
import '../../shared/components/dialogs/default_alert_dialog.dart';
import '../../shared/constants/style_constants.dart';
import 'sign_in_repository.dart';

enum SignInStatus {
  done,
  error,
  loading,
  idle,
}

class SignInController with ChangeNotifier {
  final SignInRepository _repository = SignInRepository();
  String? email;
  String? password;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? errorMessage;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  var status = SignInStatus.idle;

  SignInController() {
    loadSavedEmail();
  }

  Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
  }

  Future<void> loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('userEmail');
    if (savedEmail != null) {
      _emailController.text = savedEmail;
      notifyListeners();
    }
  }

  void signIn(BuildContext context) async {
    try {
      status = SignInStatus.loading;
      notifyListeners();

      var result = await _repository.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (result == 1) {
        await saveEmail(_emailController.text);
        status = SignInStatus.done;
        notifyListeners();
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, Screens.home);
      } 
      else if (result == 2) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, Screens.addStore);
      } 
      else if (result == 3) {
        showDialog(
          context: context,
          builder: (context) => DefaultAlertDialogOneButton(
            title: 'Acesso Negado',
            body: 'Este aplicativo é exclusivo para vendedores.',
            confirmText: 'Voltar',
            onConfirm: () => Get.back(),
            buttonColor: kErrorColor,
          )
        );
        status = SignInStatus.error;
        setErrorMessage('Você não tem permissão para acessar este aplicativo.');
      } 
      else {
        showDialog(
          context: context,
          builder: (context) => DefaultAlertDialogOneButton(
            title: 'Erro',
            body: 'Credenciais inválidas, verifique seus dados',
            confirmText: 'Voltar',
            onConfirm: () => Get.back(),
            buttonColor: kErrorColor,
          )
        );
        status = SignInStatus.error;
        setErrorMessage('Credenciais inválidas, verifique seus dados');
      }
      notifyListeners();
    } catch (e) {
      status = SignInStatus.error;
      setErrorMessage('Credenciais inválidas, verifique seus dados');
      notifyListeners();
    }
  }

  void setErrorMessage(String value) async {
    errorMessage = value;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    errorMessage = null;
    notifyListeners();
  }
}