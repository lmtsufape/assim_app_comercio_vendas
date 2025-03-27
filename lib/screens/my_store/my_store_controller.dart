import 'dart:io';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:thunderapp/screens/my_store/my_store_repository.dart';
import 'package:thunderapp/shared/core/models/banca_model.dart';
import 'package:thunderapp/shared/core/models/feira_model.dart';
import 'package:thunderapp/shared/core/user_storage.dart';
import '../../shared/components/dialogs/default_alert_dialog.dart';
import '../../shared/constants/style_constants.dart';
import '../../shared/core/image_picker_controller.dart';
import '../home/home_screen.dart';
import '../screens_index.dart';

class MyStoreController extends GetxController {
  UserStorage userStorage = UserStorage();
  MyStoreRepository myStoreRepository = MyStoreRepository();
  File? _selectedImage;
  String feira = 'Feira';
  final _imagePickerController = ImagePickerController();
  String? _imagePath;
  bool hasImg = false;
  bool editSucess = false;
  bool adcSucess = false;
  List<FeiraModel> feiras = [];
  var textoErro = "Verifique os campos";
  String userToken = '';
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void loadFeiras() async {
    feiras = await myStoreRepository.getFeiras();
    update();
  }
  
  final List<bool> isSelected = [false, false, false];
  final List<String> checkItems = ['Dinheiro', 'PIX', 'Cartão'];

  final List<bool> delivery = [false, false];
  final List<String> deliveryItems = ['Sim', 'Não'];

  bool deliver = false;
  bool pixBool = false;

  MaskTextInputFormatter timeFormatter = MaskTextInputFormatter(
      mask: '#@:%&',
      filter: {
        "#": RegExp(r'[0-2]'),
        "@": RegExp(r'^(?:[01]?\d|2[0-3])$'),
        "%": RegExp(r'[0-5]'),
        "&": RegExp(r'[0-9]')
      },
      type: MaskAutoCompletionType.lazy);

  MaskTextInputFormatter timeFormatter2 = MaskTextInputFormatter(
      mask: '#@:%&',
      filter: {
        "#": RegExp(r'[0-2]'),
        "@": RegExp(r'[0-3]'),
        "%": RegExp(r'[0-5]'),
        "&": RegExp(r'[0-9]')
      },
      type: MaskAutoCompletionType.lazy);

  final TextEditingController _nomeBancaController = TextEditingController();
  final TextEditingController _feiraIdController = TextEditingController();
  final TextEditingController _pixController = TextEditingController();
  final TextEditingController _quantiaMinController = TextEditingController();
  final TextEditingController _horarioAberturaController = TextEditingController();
  final TextEditingController _horarioFechamentoController = TextEditingController();

  TextEditingController get nomeBancaController => _nomeBancaController;
  TextEditingController get feiraIdController => _feiraIdController;
  TextEditingController get quantiaMinController => _quantiaMinController;
  TextEditingController get pixController => _pixController;
  TextEditingController get horarioAberturaController => _horarioAberturaController;
  TextEditingController get horarioFechamentoController => _horarioFechamentoController;

  void onItemTapped(int index) {
    isSelected[index] = !isSelected[index];
    update();
  }

  void onDeliveryTapped(int index) {
    //delivery[index] = !delivery[index];
    for (int i = 0; i < delivery.length; i++) {
      delivery[i] = false;
    }
    // Ativa o checkbox selecionado
    delivery[index] = true;
    deliver = delivery[0];
    print("Entrega: $deliver");
    update();
  }

  void setDeliver(bool value) {
    deliver = value;
    update();
  }
  
  void setPixBool(bool value){
    pixBool = value;
    update();
  }

  void setFeira(String value) {
    feira = value;
    update();
  }

  bool checkImg() {
    if (_selectedImage == null) {
      return false;
    }
    return true;
  }

  String? get imagePath => _imagePath;

  File? get selectedImage => _selectedImage;

  set selectedImage(File? value) {
    _selectedImage = value;
    update();
  }

  Future selectImageCam() async {
    try {
      File? file = await _imagePickerController.pickImageFromCamera();
      if (file != null) {
        _imagePath = file.path;
      } else {
        return null;
      }
      _selectedImage = file;
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: const Text('Erro 1'),
          content: Text("${e.toString()}\n Procure o suporte com a equipe LMTS"),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      );
    }

    update();
  }

  // Adicionar ao MyStoreController
  Future<bool> editBancaAsync(BuildContext context, BancaModel banca) async {
    try {
      // Validações adicionais
      if (nomeBancaController.text.isEmpty && 
          horarioAberturaController.text.isEmpty && 
          horarioFechamentoController.text.isEmpty && 
          quantiaMinController.text.isEmpty && 
          _imagePath == null) {
        print("Nenhum campo foi alterado");
        return false;
      }

      editSucess = await myStoreRepository.editarBanca(
        nomeBancaController.text.trim(),
        horarioAberturaController.text.trim(),
        horarioFechamentoController.text.trim(),
        quantiaMinController.text.trim(),
        feira,
        _imagePath,
        isSelected,
        pixController.text.trim(),
        deliver,
        banca);
      
      return editSucess;
    } catch (e) {
      print("Erro ao editar banca: $e");
      return false;
    }
  }

  Future selectImage() async {
    try {
      File? file = await _imagePickerController.pickImageFromGallery();
      if (file != null) {
        _imagePath = file.path;
      } else {
        return null;
      }

      _selectedImage = file;
      update();
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: const Text('Erro'),
          content: Text("${e.toString()}\n Procure o suporte com a equipe LMTS"),
          actions: [
            TextButton(
              child: const Text('Voltar'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      );
    }
  }

  Future clearImg() async {
    _selectedImage = null;
    update();
  }

  void editBanca(BuildContext context, BancaModel banca) async {
    // Aqui verificamos quais campos foram alterados
    // Deixamos vazios os que não foram alterados para manter os valores originais
    String nome = _nomeBancaController.text.trim();
    String horarioAbertura = _horarioAberturaController.text.trim();
    String horarioFechamento = _horarioFechamentoController.text.trim();
    String precoMin = _quantiaMinController.text.trim();
    String pix = _pixController.text.trim();
    
    // Nota para o log, apenas para debug
    log("Editando banca: Nome: ${nome.isEmpty ? 'não alterado' : nome}");
    log("Horário Abertura: ${horarioAbertura.isEmpty ? 'não alterado' : horarioAbertura}");
    log("Horário Fechamento: ${horarioFechamento.isEmpty ? 'não alterado' : horarioFechamento}");
    log("Preço Min: ${precoMin.isEmpty ? 'não alterado' : precoMin}");
    log("PIX: ${pix.isEmpty ? 'não alterado' : pix}");
    log("Imagem selecionada: ${_imagePath == null ? 'não alterada' : 'nova imagem'}");
    
    editSucess = await myStoreRepository.editarBanca(
        nome,
        horarioAbertura,
        horarioFechamento,
        precoMin,
        feira,
        _imagePath,
        isSelected,
        pix,
        deliver,
        banca);
        
    if (editSucess) {
      // ignore: use_build_context_synchronously
      Get.offAll(() => const HomeScreen());
    } else {
      Get.dialog(
        AlertDialog(
          title: const Text('Erro'),
          content: const Text("Ocorreu um erro ao editar a banca. Verifique os campos e tente novamente."),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      );
    }
  }

  void adicionarBanca(BuildContext context) async {
    try {
      adcSucess = await myStoreRepository.adicionarBanca(
          _nomeBancaController.text,
          _horarioAberturaController.text,
          _horarioFechamentoController.text,
          _quantiaMinController.text,
          feira,
          _imagePath,
          isSelected,
          deliver,
          _pixController.text);
          
      if (adcSucess) {
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (context) => DefaultAlertDialogOneButton(
                  title: 'Sucesso',
                  body: 'Sua banca foi criada',
                  confirmText: 'Ok',
                  onConfirm: () =>
                      Navigator.popAndPushNamed(context, Screens.home),
                  buttonColor: kSuccessColor,
                ));
      } else {
        if (_nomeBancaController.text.isEmpty == true) {
          textoErro = "Insira um nome";
        } else if (_horarioAberturaController.text.isEmpty) {
          textoErro = "Insira o horário de abertura";
        } else if (_horarioFechamentoController.text.isEmpty) {
          textoErro = "Insira o horário de fechamento";
        } else if (_quantiaMinController.text.isEmpty) {
          textoErro = "Insira uma quantia mínima para entrega";
        } else if (!isSelected.contains(true)) {
          textoErro = "Adicione pelo menos um método de pagamento";
        } else {
          log("Ocorreu um erro, verifique os campos");
        }
      }
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: const Text('Erro'),
          content: Text("${e.toString()}\n Procure o suporte com a equipe LMTS"),
          actions: [
            TextButton(
              child: const Text('Voltar'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      );
    }
  }

  bool verifySelectedFields() {
    // Verificamos se pelo menos uma forma de pagamento foi selecionada
    return isSelected.contains(true);
  }

  bool verifyFields() {
    // Para edição, consideramos como válido quando:
    // - Pelo menos um campo foi editado
    // - E pelo menos uma forma de pagamento está selecionada
    bool hasChanges = _nomeBancaController.text.isNotEmpty || 
                      _horarioAberturaController.text.isNotEmpty ||
                      _horarioFechamentoController.text.isNotEmpty ||
                      _quantiaMinController.text.isNotEmpty ||
                      _pixController.text.isNotEmpty ||
                      _imagePath != null;
                      
    bool hasPagamento = isSelected.contains(true);
    
    if (!hasPagamento) {
      textoErro = "Selecione pelo menos uma forma de pagamento";
      return false;
    }
    
    return true;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    loadFeiras();
    update();
  }
}