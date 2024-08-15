import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thunderapp/components/forms/custom_text_form_field.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';
import '../../../shared/core/models/products_model.dart';
import '../edit_products_controller.dart';

class SaleInfos extends StatefulWidget {
  final EditProductsController controller;
  ProductsModel? productsModel;

  SaleInfos(this.controller, this.productsModel, {Key? key})
      : super(key: key);

  @override
  State<SaleInfos> createState() => _SaleInfosState();
}

class _SaleInfosState extends State<SaleInfos> {
  double profit = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double? preco = widget.productsModel!.preco;
    final String? precoCorreto = preco?.toStringAsFixed(2);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              height: size.height * 0.03,
              color: Colors.transparent,
            ),
            Text(
              'Nome do produto',
              style: TextStyle(
                  color: kSecondaryColor,
                  fontSize: size.height * 0.018,
                  fontWeight: FontWeight.w700),
            ),
            Divider(
              height: size.height * 0.005,
              color: Colors.transparent,
            ),
            SizedBox(
              width: size.width,
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                child: ClipPath(
                  child: Container(
                    alignment: Alignment.center,
                    child: CustomTextFormField(
                      hintText:
                          widget.productsModel!.descricao,
                      erroStyle:
                          const TextStyle(fontSize: 12),
                      validatorError: (value) {
                        if (value.isEmpty) {
                          return 'Obrigatório';
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          widget.controller
                              .setDescription();
                        });
                      },
                      controller: widget
                          .controller.descriptionController,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        Divider(
          height: size.height * 0.03,
          color: Colors.transparent,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Descrição',
              style: TextStyle(
                  color: kSecondaryColor,
                  fontSize: size.height * 0.018,
                  fontWeight: FontWeight.w700),
            ),
            Divider(
              height: size.height * 0.005,
              color: Colors.transparent,
            ),
            SizedBox(
              width: size.width,
              child: Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                child: ClipPath(
                  child: CustomTextFormField(
                    hintText: widget.productsModel!.titulo,
                    erroStyle:
                        const TextStyle(fontSize: 12),
                    validatorError: (value) {
                      if (value.isEmpty) {
                        return 'Obrigatório';
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        widget.controller.setTitle();
                      });
                    },
                    controller:
                        widget.controller.titleController,
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(
          height: size.height * 0.03,
          color: Colors.transparent,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(
                'Preço',
                style: TextStyle(
                    color: kSecondaryColor,
                    fontSize: size.height * 0.018,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Divider(
              height: size.height * 0.005,
              color: Colors.transparent,
            ),
            SizedBox(
              width: size.width,
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                child: ClipPath(
                  child: Container(
                    alignment: Alignment.center,
                    child: CustomTextFormFieldCurrency(
                      keyboardType: TextInputType.number,
                      erroStyle:
                          const TextStyle(fontSize: 12),
                      validatorError: (value) {
                        if (value.isEmpty) {
                          return 'Obrigatório';
                        }
                      },
                      hintText: "R\$ $precoCorreto",
                      onChanged: (value) {
                        setState(() {
                          widget.controller.setSalePrice();
                        });
                      },
                      currencyFormatter: <TextInputFormatter>[
                        CurrencyTextInputFormatter.currency(
                          locale: 'pt-BR',
                          symbol: 'R\$',
                          decimalDigits: 2,
                        ),
                        LengthLimitingTextInputFormatter(9),
                      ],
                      controller:
                          widget.controller.saleController,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
