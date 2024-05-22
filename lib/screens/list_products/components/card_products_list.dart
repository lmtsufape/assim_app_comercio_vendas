import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thunderapp/screens/edit_products/edit_products_repository.dart';
import 'package:thunderapp/screens/edit_products/edit_products_screen.dart';
import 'package:thunderapp/screens/list_products/list_products_controller.dart';
import 'package:thunderapp/screens/add_products/add_products_screen.dart';
import 'package:thunderapp/screens/list_products/components/image_card_list.dart';
import 'package:thunderapp/screens/list_products/list_products_controller.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';
import 'package:thunderapp/shared/core/models/products_model.dart';
import '../../../shared/core/models/table_products_model.dart';
import '../list_products_repository.dart';

class CardProductsList extends StatefulWidget {
  String userToken;
  ProductsModel model;
  ListProductsRepository repository;
  EditProductsRepository editRepository;
  List<TableProductsModel> listTable;

  CardProductsList(this.userToken, this.model, this.repository, this.listTable,
      this.editRepository,
      {Key? key})
      : super(key: key);

  @override
  State<CardProductsList> createState() => _CardProductsListState();
}

class _CardProductsListState extends State<CardProductsList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(widget.listTable.length);
    return Column(
      children: [
        SizedBox(
          width: size.width,
          height: size.height * 0.115,
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (_) => EditProductsScreen(
                          widget.model, widget.editRepository)));
            },
            child: Ink(
              child: Card(
                margin: EdgeInsets.zero,
                color: Colors.white,
                elevation: 1.3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ImageCardList(widget.userToken,
                        widget.model.produtoTabeladoId, widget.listTable),
                    Container(
                      width: size.width * 0.5615,
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.only(start: 8, end: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                widget.model.descricao.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: size.height * 0.016,
                                    color: kSecondaryColor),
                              ),
                            ),
                            Divider(
                              height: size.height * 0.002,
                              color: Colors.transparent,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  NumberFormat.simpleCurrency(
                                          locale: 'pt-BR', decimalDigits: 2)
                                      .format(widget.model.preco),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: size.height * 0.018),
                                ),
                                Divider(
                                  height: size.height * 0.002,
                                  color: Colors.transparent,
                                ),
                                Text(
                                  'Estoque atual: ${widget.model.estoque.toString()}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: size.height * 0.014,
                                      color: kPrimaryColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Divider(
          height: size.height * 0.02,
          color: Colors.transparent,
        )
      ],
    );
  }
}
