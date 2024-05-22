import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomCurrencyTextFormField extends StatefulWidget {
  const CustomCurrencyTextFormField(
      {Key? key,
      this.onChanged,
      this.label,
      this.maskFormatter,
      this.controller,
      this.keyboardType,
      this.hintText,
      this.icon,
      this.isBordered,
      this.inputFormatter})
      : super(key: key);
  final Function(String)? onChanged;
  final String? label;
  final MaskTextInputFormatter? maskFormatter;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final IconData? icon;
  final bool? isBordered;
  final CurrencyTextInputFormatter? inputFormatter;
  @override
  State<CustomCurrencyTextFormField> createState() =>
      _CustomCurrencyTextFormFieldState();
}

class _CustomCurrencyTextFormFieldState
    extends State<CustomCurrencyTextFormField> {
  bool _obscureText = false;
  @override
  void initState() {
    super.initState();
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        textAlign: TextAlign.center,
        onChanged: widget.onChanged,
        inputFormatters: widget.inputFormatter == null
            ? null
            : [widget.inputFormatter!],
        obscureText: _obscureText,
        controller: widget.controller,
        decoration: InputDecoration(
          floatingLabelBehavior:
              FloatingLabelBehavior.never,
          prefixIcon: widget.icon == null
              ? null
              : Icon(widget.icon),
          border: widget.isBordered == null
              ? InputBorder.none
              : const OutlineInputBorder(),
          labelText: widget.label,
          filled: true,
          fillColor: Colors.white,
          hintText: widget.hintText,
        ),
      ),
    );
  }
}
