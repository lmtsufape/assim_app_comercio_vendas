import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thunderapp/screens/list_products/list_products_screen.dart';
import 'package:thunderapp/shared/core/models/products_model.dart';
import '../../shared/components/dialogs/default_alert_dialog.dart';
import '../home/home_screen.dart';
import 'components/dropdown_edit_product.dart';
import 'components/dropdown_qtd_edit_product.dart';
import 'components/elevated_button_edit_product.dart';
import 'components/image_edit.dart';
import 'components/sale_infos.dart';
import 'edit_products_controller.dart';
import 'edit_products_repository.dart';
import '../../shared/constants/app_number_constants.dart';
import '../../shared/constants/style_constants.dart';

class EditProductsScreen extends StatefulWidget {
  ProductsModel model;
  EditProductsRepository repository;

  EditProductsScreen(this.model, this.repository, {Key? key}) : super(key: key);

  @override
  State<EditProductsScreen> createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  EditProductsRepository repository = EditProductsRepository();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(widget.model.id);
    return GetBuilder<EditProductsController>(
      init: EditProductsController(widget.model),
      builder: (controller) => GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
              title: Text(
                'Editar produto',
                style: kTitle2.copyWith(color: kPrimaryColor),
              ),
              iconTheme: const IconThemeData(color: kPrimaryColor),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 14),
                  child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      size: size.width * 0.1,
                    ),
                    color: Colors.redAccent,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Center(
                                  child: Text(
                                    'Excluir produto?',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.height * 0.020,
                                    ),
                                  ),
                                ),
                                content: Text(
                                  'Você tem certeza que deseja excluir este produto?',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.height * 0.015,
                                  ),
                                ),
                                actions: [
                                  Center(
                                    child: Wrap(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          // ignore: sort_child_properties_last
                                          child: Text(
                                            'Cancelar',
                                            style: TextStyle(
                                              color: kBackgroundColor,
                                              fontSize: size.height * 0.020,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kSuccessColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16),
                                          child: ElevatedButton(
                                            onPressed: () => widget.repository
                                                        .deleteProduct(context,
                                                            widget.model.id) ==
                                                    true
                                                ? showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        DefaultAlertDialogOneButton(
                                                          title: 'Erro',
                                                          body:
                                                              'Impossível excluir esse produto',
                                                          confirmText: 'Ok',
                                                          onConfirm: () =>
                                                              Get.back(),
                                                          buttonColor:
                                                              kSuccessColor,
                                                        ))
                                                : showDialog(
                                                    context: context,
                                                    builder: ((context) =>
                                                        DefaultAlertDialogOneButton(
                                                          title: 'Sucesso',
                                                          body:
                                                              'Produto excluído com sucesso',
                                                          confirmText: 'Ok',
                                                          onConfirm: () =>
                                                              Get.offAll(() =>
                                                                  const HomeScreen()),
                                                          buttonColor:
                                                              kSuccessColor,
                                                        ))),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.redAccent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              'Excluir',
                                              style: TextStyle(
                                                color: kBackgroundColor,
                                                fontSize: size.height * 0.020,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ));
                    },
                  ),
                ),
              ]),
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
                  Column(
                    children: [
                      ImageEdit(controller, widget.model),
                    ],
                  ),
                  Divider(
                    height: size.height * 0.03,
                    color: Colors.transparent,
                  ),
                  Text(
                    'Imagem do produto',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: size.height * 0.018,
                        color: kSecondaryColor),
                  ),
                  Divider(
                    height: size.height * 0.005,
                    color: Colors.transparent,
                  ),
                  DropDownEditProduct(controller, widget.model),
                  SaleInfos(controller, widget.model),
                  Divider(
                    height: size.height * 0.02,
                    color: Colors.transparent,
                  ),
                  Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: DropDownQtdEditProduct(controller, widget.model)),
                  Divider(
                    height: size.height * 0.02,
                    color: Colors.transparent,
                  ),
                  ElevatedButtonEditProduct(controller),
                  /*Divider(
                      height: size.height * 0.015, color: Colors.transparent),
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Center(
                                    child: Text(
                                      'Excluir produto?',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: size.height * 0.020,
                                      ),
                                    ),
                                  ),
                                  content: Text(
                                    'Você tem certeza que deseja excluir este produto?',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.height * 0.015,
                                    ),
                                  ),
                                  actions: [
                                    Center(
                                      child: Wrap(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            // ignore: sort_child_properties_last
                                            child: Text(
                                              'Cancelar',
                                              style: TextStyle(
                                                color: kBackgroundColor,
                                                fontSize: size.height * 0.020,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: kSuccessColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 16),
                                            child: ElevatedButton(
                                              onPressed: () => widget.repository
                                                          .deleteProduct(
                                                              context,
                                                              widget
                                                                  .model.id) ==
                                                      true
                                                  ? showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          DefaultAlertDialogOneButton(
                                                            title: 'Erro',
                                                            body:
                                                                'Impossível excluir esse produto',
                                                            confirmText: 'Ok',
                                                            onConfirm: () =>
                                                                Get.back(),
                                                            buttonColor:
                                                                kSuccessColor,
                                                          ))
                                                  : showDialog(
                                                      context: context,
                                                      builder: ((context) =>
                                                          DefaultAlertDialogOneButton(
                                                            title: 'Sucesso',
                                                            body:
                                                                'Produto excluído com sucesso',
                                                            confirmText: 'Ok',
                                                            onConfirm: () =>
                                                                Get.offAll(() =>
                                                                    const HomeScreen()),
                                                            buttonColor:
                                                                kSuccessColor,
                                                          ))),
                                              child: Text(
                                                'Excluir',
                                                style: TextStyle(
                                                  color: kBackgroundColor,
                                                  fontSize: size.height * 0.020,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.redAccent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ));
                      },
                      style: EditProductsScreen.styleEditProductDelete,
                      child: Text(
                        'Remover',
                        style: TextStyle(
                            color: kTextColor,
                            fontSize: size.height * 0.024,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),*/
                  Divider(
                      height: size.height * 0.015, color: Colors.transparent),
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.06,
                    child: OutlinedButton(
                      onPressed: () => Get.off(() => ListProductsScreen()),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side:
                            const BorderSide(color: kDetailColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        'Voltar',
                        style: TextStyle(
                            color: kDetailColor,
                            fontSize: size.height * 0.024,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
