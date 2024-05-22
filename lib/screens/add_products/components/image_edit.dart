import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:thunderapp/screens/add_products/add_products_controller.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';
import '../../../shared/core/models/table_products_model.dart';

class ImageEdit extends StatefulWidget {
  final AddProductsController? controller;

  const ImageEdit(this.controller, {Key? key}) : super(key: key);

  @override
  State<ImageEdit> createState() => _ImageEditState();
}

class _ImageEditState extends State<ImageEdit> {
  int? _currentProductId;
  TableProductsModel? tableProductsModel;

  @override
  void initState() {
    super.initState();
    _currentProductId = widget.controller?.productId;
  }

  @override
  void didUpdateWidget(covariant ImageEdit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller?.productId != _currentProductId) {
      _currentProductId = widget.controller?.productId;
      tableProductsModel = widget.controller?.search(_currentProductId);
    }
    print(_currentProductId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (tableProductsModel == null || tableProductsModel?.imagem == null) {
      return Container(
        alignment: Alignment.center,
        height: size.height * 0.2,
        child: AspectRatio(
          aspectRatio: 12 / 9,
          child: Material(
            elevation: 1,
            shadowColor: Colors.black,
            child: Icon(
              Icons.shopping_bag,
              size: size.height * 0.1,
              color: kDetailColor,
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
          child: Image.memory(base64Decode(base64Image!.split(',').last)),
        ),
      ),
    );
  }
}
