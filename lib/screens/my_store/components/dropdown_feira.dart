import 'package:flutter/material.dart';
import 'package:thunderapp/screens/add_products/add_products_controller.dart';
import 'package:thunderapp/screens/my_store/my_store_controller.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';
import 'package:thunderapp/shared/core/models/feira_model.dart';
import 'package:thunderapp/shared/core/models/table_products_model.dart';

// ignore: must_be_immutable
class DropDownFeira extends StatefulWidget {
  late MyStoreController controller;

  DropDownFeira(this.controller, {Key? key})
      : super(key: key);

  @override
  State<DropDownFeira> createState() =>
      _DropDownAddProductState();
}

class _DropDownAddProductState
    extends State<DropDownFeira> {
  final dropValue = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            alignment: Alignment.topCenter,
            width: size.width,
            child:
            DropdownButtonFormField<FeiraModel>(
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: kPrimaryColor,
                size: size.width * 0.05,
              ),
              hint: Text(
                'Selecione a feira',
                style: TextStyle(fontSize: size.height * 0.02),
              ),
              value: null,
              items: widget.controller.feiras.map((obj) {
                return DropdownMenuItem<FeiraModel>(
                  value: obj,
                  child: Text(obj.nome.toString()),
                );
              }).toList(),
              onChanged: (selectedObj) {
                setState(() {
                  widget.controller
                      .setFeira(selectedObj!.id.toString());
                  // widget.controller
                  //     .setDescription(selectedObj.nome);
                });
              },
              decoration: const InputDecoration(
                errorStyle: TextStyle(fontSize: 12),
              ),
              validator: (dropValue) {
                if(dropValue == null){
                  return 'Obrigatório';
                }
                return null;
              },
            )),
      ],

    );
  }
}