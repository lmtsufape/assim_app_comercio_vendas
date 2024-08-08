import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';
import 'package:thunderapp/shared/core/models/feira_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../shared/core/models/list_banca_model.dart';
import '../../../shared/core/navigator.dart';
import '../../screens_index.dart';
import '../home_screen.dart';
import '../home_screen_controller.dart';

// ignore: must_be_immutable
class DropDownBanca extends StatefulWidget {
  late HomeScreenController controller;

  DropDownBanca(this.controller, {Key? key}) : super(key: key);

  @override
  State<DropDownBanca> createState() => _DropDownAddProductState();
}

class _DropDownAddProductState extends State<DropDownBanca> {
  final dropValue = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    var idScreen = 0;
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.topCenter,
      width: size.width * 0.2,
      child: DropdownButton2<ListBancaModel>(
        isExpanded: true,
        customButton: Icon(
          Icons.keyboard_arrow_up,
          color: kPrimaryColor,
          size: size.width * 0.1,
        ),
        dropdownStyleData: DropdownStyleData(
          width: size.width,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          offset: const Offset(0, 8),
        ),
        value: null,
        items: widget.controller.bancas.map((obj) {
          return DropdownMenuItem<ListBancaModel>(
            value: obj,
            child: Text(obj.nome.toString()),
          );
        }).toList(),
        onChanged: (selectedObj) {
          int selectedIndex = widget.controller.bancas
              .indexWhere((banca) => banca.id == selectedObj!.id);
          setState(() {
            widget.controller.setBanca(selectedIndex);
            idScreen = widget.controller.banca.value;
          });
        },
      ),
    );
  }
}
