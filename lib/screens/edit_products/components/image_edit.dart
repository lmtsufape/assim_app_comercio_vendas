import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:thunderapp/shared/core/models/products_model.dart';
import '../../../shared/core/models/table_products_model.dart';
import '../edit_products_controller.dart';

class ImageEdit extends StatefulWidget {
  final EditProductsController? controller;
  final ProductsModel model;

  const ImageEdit(this.controller, this.model, {Key? key})
      : super(key: key);

  @override
  State<ImageEdit> createState() => _ImageEditState();
}

class _ImageEditState extends State<ImageEdit> {
  TableProductsModel? tableProductsModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    tableProductsModel = widget.controller
        ?.search(widget.model.produtoTabeladoId);
    Size size = MediaQuery.of(context).size;
    if (tableProductsModel == null ||
        tableProductsModel?.imagem == null) {
      return Container(
        alignment: Alignment.center,
        height: size.height * 0.15,
        child: AspectRatio(
          aspectRatio: 12 / 9,
          child: Material(
            elevation: 1,
            shadowColor: Colors.black,
            child: Icon(
              Icons.shopping_bag,
              size: size.height * 0.1,
              color: Colors.orange,
            ),
          ),
        ),
      );
    }

    String? base64Image = tableProductsModel?.imagem != null
        ? 'data:image/jpeg;base64,${base64Encode(tableProductsModel!.imagem!)}'
        : null;

    return Container(
      alignment: Alignment.center,
      height: size.height * 0.2,
      child: AspectRatio(
        aspectRatio: 12 / 9,
        child: Material(
          elevation: 0,
          shadowColor: Colors.black,
          child: Image.memory(
              base64Decode(base64Image!.split(',').last)),
        ),
      ),
    );
  }
}
