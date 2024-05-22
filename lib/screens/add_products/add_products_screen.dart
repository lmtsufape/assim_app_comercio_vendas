import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:thunderapp/screens/add_products/add_products_controller.dart';
import 'package:thunderapp/screens/add_products/add_products_repository.dart';
import 'package:thunderapp/screens/add_products/components/dropdown_add_product.dart';
import 'package:thunderapp/screens/add_products/components/dropdown_qtd_add_product.dart';
import 'package:thunderapp/screens/add_products/components/elevated_button_add_product.dart';
import 'package:thunderapp/screens/add_products/components/image_edit.dart';
import 'package:thunderapp/screens/add_products/components/sale_infos.dart';

import 'package:thunderapp/shared/core/models/table_products_model.dart';
import '../../shared/constants/app_number_constants.dart';
import '../../shared/constants/style_constants.dart';


class AddProductsScreen extends StatefulWidget {
  const AddProductsScreen({Key? key}) : super(key: key);

  @override
  State<AddProductsScreen> createState() =>
      _AddProductsScreenState();
}

class _AddProductsScreenState
    extends State<AddProductsScreen> {
  AddProductsRepository repository =
      AddProductsRepository();

  Future<List<TableProductsModel>>? products;

  @override
  void initState() {
    products = repository.getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<AddProductsController>(
      init: AddProductsController(),
      builder: (controller) => GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: Text(
              'Adicionar produto',
              style: kTitle2.copyWith(color: Colors.white),
            ),
            iconTheme:
                const IconThemeData(color: Colors.white),
          ),
          body: Form(
            key: controller.formKey,
            child: Container(
              width: size.width,
              height: size.height,
              padding: const EdgeInsets.all(kDefaultPadding),
              child: ListView(
                children: [
                  Divider(
                    height: size.height * 0.008,
                    color: Colors.transparent,
                  ),
                  ImageEdit(controller),
                  Divider(
                    height: size.height * 0.03,
                    color: Colors.transparent,
                  ),
                  Text(
                    'Imagem do produto',
                    style: TextStyle(
                      fontSize: size.height * 0.018,
                      fontWeight: FontWeight.w700,
                      color: kSecondaryColor,
                    ),
                  ),
                  Divider(
                    height: size.height * 0.005,
                    color: Colors.transparent,
                  ),
                  DropDownAddProduct(controller),
                  Divider(
                    height: size.height * 0.03,
                    color: Colors.transparent,
                  ),
                  SaleInfos(controller),
                  Divider(
                    height: size.height * 0.03,
                    color: Colors.transparent,
                  ),
                  Align(
                      alignment:
                          AlignmentDirectional.centerStart,
                      child: DropDownQtdAddProduct(controller)),
                  Divider(
                    height: size.height * 0.03,
                    color: Colors.transparent,
                  ),
                  ElevatedButtonAddProduct(controller),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
