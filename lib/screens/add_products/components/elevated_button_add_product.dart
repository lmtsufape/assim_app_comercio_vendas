import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thunderapp/screens/add_products/add_products_controller.dart';
import 'package:thunderapp/screens/home/home_screen.dart';
import 'package:thunderapp/screens/screens_index.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';

import '../../../shared/components/dialogs/default_alert_dialog.dart';

class ElevatedButtonAddProduct extends StatefulWidget {
  final AddProductsController controller;
  const ElevatedButtonAddProduct(this.controller,
      {Key? key})
      : super(key: key);

  static ButtonStyle styleEditProduct =
      ElevatedButton.styleFrom(
    backgroundColor: kDetailColor,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)),
  );

  @override
  State<ElevatedButtonAddProduct> createState() =>
      _ElevatedButtonAddProductState();
}

class _ElevatedButtonAddProductState
    extends State<ElevatedButtonAddProduct> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height * 0.06,
      child: ElevatedButton(
        onPressed: () async {
          final isValidForm = widget.controller.formKey.currentState!.validate();
          if(isValidForm){
            var response =
            await widget.controller.validateEmptyFields(context);
            if(response) {
            showDialog(
                context: context,
                builder: ((context) =>
                    DefaultAlertDialogOneButton(
                      title: 'Sucesso',
                      body:
                          'Produto cadastrado com sucesso',
                      confirmText: 'Ok',
                      onConfirm: () => Get.offAll(() => HomeScreen()),
                      buttonColor: kSuccessColor,
                    )));
          }}
        },
        style: ElevatedButtonAddProduct.styleEditProduct,
        child: Text(
          'Salvar',
          style: TextStyle(
              color: kTextColor,
              fontSize: size.height * 0.024,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
