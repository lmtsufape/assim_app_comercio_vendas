import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thunderapp/screens/add_products/add_products_controller.dart';
import 'package:thunderapp/screens/home/home_screen.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';

import '../../../shared/components/dialogs/default_alert_dialog.dart';
import '../../list_products/list_products_screen.dart';
import '../../screens_index.dart';

class ElevatedButtonAddProduct extends StatefulWidget {
  final AddProductsController controller;
  const ElevatedButtonAddProduct(this.controller,
      {Key? key})
      : super(key: key);

  static ButtonStyle styleEditProduct =
  ElevatedButton.styleFrom(
    backgroundColor: kPrimaryColor,
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
                // ignore: use_build_context_synchronously
                  context: context,
                  builder: ((context) =>
                      DefaultAlertDialogOneButton(
                        title: 'Sucesso',
                        body:
                        'Produto cadastrado com sucesso',
                        confirmText: 'Ok',
                        onConfirm: () {
                          navigator?.pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context)=>const ListProductsScreen()),
                                (Route<dynamic> route) => false,
                          );
                          widget.controller.clearFields();
                        },
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
