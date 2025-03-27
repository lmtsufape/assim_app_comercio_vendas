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

enum LoginError {
  userNotFound,
  invalidPassword,
  notSeller,
  unknown
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

      // Verificar se o email tem um formato válido
      if (!_isValidEmail(_emailController.text)) {
        _showErrorDialog(
          context,
          'Email Inválido',
          'Por favor, insira um endereço de email válido.',
          LoginError.unknown
        );
        return;
      }

      // Verificar se a senha não está vazia
      if (_passwordController.text.isEmpty) {
        _showErrorDialog(
          context, 
          'Senha Vazia',
          'Por favor, insira sua senha.',
          LoginError.invalidPassword
        );
        return;
      }

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
        _showErrorDialog(
          context,
          'Acesso Negado',
          'Este aplicativo é exclusivo para vendedores.',
          LoginError.notSeller
        );
      } 
      else if (result == 4) {
        _showErrorDialog(
          context,
          'Usuário Não Encontrado',
          'O email informado não está cadastrado no sistema.',
          LoginError.userNotFound
        );
      }
      else if (result == 5) {
        _showErrorDialog(
          context,
          'Senha Incorreta',
          'A senha informada está incorreta. Por favor, verifique e tente novamente.',
          LoginError.invalidPassword
        );
      }
      else {
        // Erro genérico
        _showErrorDialog(
          context,
          'Erro',
          'Ocorreu um erro ao tentar fazer login. Verifique suas credenciais e tente novamente.',
          LoginError.unknown
        );
      }
    } catch (e) {
      // Tenta inferir o tipo de erro a partir da exceção
      if (e.toString().toLowerCase().contains('not found') || 
          e.toString().toLowerCase().contains('email') ||
          e.toString().toLowerCase().contains('usuário')) {
        _showErrorDialog(
          context,
          'Usuário Não Encontrado',
          'O email informado não está cadastrado no sistema.',
          LoginError.userNotFound
        );
      } else if (e.toString().toLowerCase().contains('password') || 
                e.toString().toLowerCase().contains('senha') ||
                e.toString().toLowerCase().contains('invalid credentials')) {
        _showErrorDialog(
          context,
          'Senha Incorreta',
          'A senha informada está incorreta. Por favor, verifique e tente novamente.',
          LoginError.invalidPassword
        );
      } else {
        status = SignInStatus.error;
        setErrorMessage('Erro ao tentar fazer login: ${e.toString()}');
        notifyListeners();
        
        // Mostrar um erro genérico mais amigável para o usuário
        _showErrorDialog(
          context,
          'Erro',
          'Ocorreu um erro ao tentar fazer login. Verifique suas credenciais e tente novamente.',
          LoginError.unknown
        );
      }
    }
  }

  // Verifica se o email tem um formato válido
  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  void _showErrorDialog(BuildContext context, String title, String message, LoginError errorType) {
    showDialog(
      context: context,
      builder: (context) => DefaultAlertDialogOneButton(
        title: title,
        body: message,
        confirmText: 'Voltar',
        onConfirm: () => Get.back(),
        buttonColor: kErrorColor,
      )
    );
    
    status = SignInStatus.error;
    setErrorMessage(message);
  }

  void setErrorMessage(String value) async {
    errorMessage = value;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    errorMessage = null;
    notifyListeners();
  }
}