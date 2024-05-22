import 'package:flutter/material.dart';

import 'package:thunderapp/screens/add_products/add_products_controller.dart';

import 'package:thunderapp/shared/constants/style_constants.dart';
import 'package:thunderapp/shared/core/models/products_model.dart';

import '../../../components/forms/custom_text_form_field.dart';
import '../edit_products_controller.dart';

class StockEditProduct extends StatefulWidget {
  final EditProductsController controller;
  ProductsModel? model;

  StockEditProduct(this.controller, this.model, {Key? key})
      : super(key: key);

  @override
  State<StockEditProduct> createState() =>
      _StockEditProductState();
}

class _StockEditProductState
    extends State<StockEditProduct> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estoque',
          style: TextStyle(
            fontSize: size.height * 0.018,
            color: kSecondaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        Divider(
          height: size.height * 0.005,
          color: Colors.transparent,
        ),
        SizedBox(
          width: size.width * 0.4,
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            child: ClipPath(
              child: Container(
                alignment: Alignment.center,
                child: CustomTextFormField(
                    erroStyle: const TextStyle(fontSize: 12),
                    validatorError: (value) {
                      if(value.isEmpty){
                        return 'Obrigatório';
                      }
                    },
                    keyboardType: TextInputType.number,
                    hintText: widget.model!.estoque.toString(),
                    controller:
                        widget.controller.stockController,
                    onChanged: (value) {
                      setState(() {
                        widget.controller.setStock();
                      });
                    }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
