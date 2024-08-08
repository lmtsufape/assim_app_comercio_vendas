// ignore_for_file: avoid_print
import 'dart:math';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thunderapp/components/buttons/primary_button.dart';
import 'package:thunderapp/components/utils/vertical_spacer_box.dart';
import 'package:thunderapp/screens/home/home_screen.dart';
import 'package:thunderapp/screens/my_store/my_store_controller.dart';
import 'package:thunderapp/shared/constants/app_enums.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';
import 'package:thunderapp/shared/core/models/banca_model.dart';
import '../../components/forms/custom_text_form_field.dart';
import '../../shared/components/dialogs/default_alert_dialog.dart';
import 'components/circle_image_profile.dart';

// ignore: must_be_immutable
class EditStoreScreen extends StatefulWidget {
  BancaModel? bancaModel;

  EditStoreScreen(this.bancaModel, {Key? key}) : super(key: key);

  @override
  State<EditStoreScreen> createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  @override
  Widget build(BuildContext context) {
    final double? doubleFrete = double.tryParse(widget.bancaModel!.precoMin);
    final String? freteCorreto = doubleFrete?.toStringAsFixed(2);
    Size size = MediaQuery.of(context).size;

    return GetBuilder<MyStoreController>(
        init: MyStoreController(),
        builder: (controller) => GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: kPrimaryColor,
                title: Center(
                  child: Text(
                    'Editar banca',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: size.height * 0.030),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Container(
                      padding: const EdgeInsets.only(
                          top: 20, left: 26, right: 26, bottom: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CircleImageProfile(controller),
                          ),
                          Divider(
                            height: size.height * 0.016,
                            color: Colors.transparent,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nome da banca',
                                style: TextStyle(
                                    color: kSecondaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: size.height * 0.018),
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
                                        autoValidate: AutovalidateMode.onUserInteraction,
                                        hintText: widget.bancaModel!.nome,
                                        erroStyle:
                                        const TextStyle(fontSize: 12),
                                        validatorError: (value) {
                                          if (value.isEmpty) {
                                            return 'Obrigatório';
                                          }
                                          if (value.length < 3){
                                            return 'O nome deve ter no mínimo 3 caracteres';
                                          }
                                        },
                                        controller: controller.nomeBancaController,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const VerticalSpacerBox(size: SpacerSize.small),
                          Divider(
                            height: size.height * 0.01,
                            color: Colors.transparent,
                          ),
                          SizedBox(
                            width: size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Início dos pedidos',
                                      style: TextStyle(
                                          color: kSecondaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: size.height * 0.018),
                                    ),
                                    Divider(
                                      height: size.height * 0.006,
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
                                            child: CustomTextFormFieldTime(
                                              erroStyle: const TextStyle(fontSize: 12),
                                              validatorError: (value) {
                                                final exp = RegExp(
                                                    r"(\d{2})+:?(\d{2})+");
                                                if (value.isEmpty) {
                                                  return 'Obrigatório';
                                                }
                                                if (!exp.hasMatch(value)) {
                                                  return 'Horário inválido';
                                                }
                                                return null;
                                              },
                                              hintText: widget.bancaModel!.horarioAbertura,
                                              keyboardType: TextInputType.datetime,
                                              timeFormatter: [
                                                _HourInputFormatter(),
                                              ],
                                              controller: controller.horarioAberturaController,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const VerticalSpacerBox(
                                    size: SpacerSize.large),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Término dos pedidos',
                                      style: TextStyle(
                                          color: kSecondaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: size.height * 0.018),
                                    ),
                                    Divider(
                                      height: size.height * 0.006,
                                      color: Colors.transparent,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.40,
                                      child: Card(
                                        margin: EdgeInsets.zero,
                                        elevation: 0,
                                        child: ClipPath(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: CustomTextFormFieldTime(
                                              erroStyle: const TextStyle(
                                                  fontSize: 12),
                                              validatorError: (value) {
                                                final exp = RegExp(
                                                    r"(\d{2})+:?(\d{2})+");
                                                if (value.isEmpty) {
                                                  return 'Obrigatório';
                                                }
                                                if (!exp.hasMatch(value)) {
                                                  return 'Horário inválido';
                                                }
                                                List<int> startTime =
                                                _extractHoursAndMinutes(
                                                    controller
                                                        .horarioAberturaController
                                                        .text);
                                                List<int> endTime =
                                                _extractHoursAndMinutes(
                                                    controller
                                                        .horarioFechamentoController
                                                        .text);

                                                int startMinutes =
                                                    startTime[0] * 60 +
                                                        startTime[1];
                                                int endMinutes =
                                                    endTime[0] * 60 +
                                                        endTime[1];

                                                if (startMinutes >=
                                                    endMinutes) {
                                                  return 'Horário inválido';
                                                }
                                                return null;
                                              },
                                              hintText: widget.bancaModel!
                                                  .horarioFechamento,
                                              keyboardType:
                                              TextInputType.datetime,
                                              timeFormatter: [
                                                _HourInputFormatter(),
                                              ],
                                              controller: controller
                                                  .horarioFechamentoController,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: size.height * 0.018,
                            color: Colors.transparent,
                          ),
                          Text('Formas de Pagamento',
                              style: kTitle1.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: size.height * 0.018,
                                  color: kSecondaryColor)),
                          SizedBox(
                            width: size.width,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: ListTileTheme(
                                    horizontalTitleGap: 0,
                                    child: CheckboxListTile(
                                      contentPadding: EdgeInsets.zero,
                                      activeColor: kPrimaryColor,
                                      value: controller.isSelected[0],
                                      title: Text(
                                        controller.checkItems[0],
                                        style: TextStyle(
                                            fontSize: size.height * 0.016),
                                      ),
                                      checkboxShape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(5)),
                                      controlAffinity:
                                      ListTileControlAffinity.leading,
                                      onChanged: (value) =>
                                          controller.onItemTapped(0),
                                    ),
                                  ),
                                ),
                                // Flexible(
                                //   child: ListTileTheme(
                                //     horizontalTitleGap: 0,
                                //     child: CheckboxListTile(
                                //       contentPadding: EdgeInsets.zero,
                                //       activeColor: kPrimaryColor,
                                //       value: controller.isSelected[2],
                                //       title: Text(
                                //         controller.checkItems[2],
                                //         style: TextStyle(
                                //             fontSize: size.height * 0.016),
                                //       ),
                                //       checkboxShape: RoundedRectangleBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(5)),
                                //       controlAffinity:
                                //           ListTileControlAffinity.leading,
                                //       onChanged: (value) =>
                                //           controller.onItemTapped(2),
                                //     ),
                                //   ),
                                // ),
                                Flexible(
                                  child: ListTileTheme(
                                    horizontalTitleGap: 0,
                                    child: CheckboxListTile(
                                        contentPadding: EdgeInsets.zero,
                                        activeColor: kPrimaryColor,
                                        value: controller.isSelected[1],
                                        title: Text(
                                          controller.checkItems[1],
                                          style: TextStyle(
                                              fontSize: size.height * 0.016),
                                        ),
                                        checkboxShape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(5)),
                                        controlAffinity:
                                        ListTileControlAffinity.leading,
                                        onChanged: (value)
                                        {
                                          controller.onItemTapped(1);
                                          controller.setPixBool(!controller.pixBool);
                                          print("valor do pix: ${controller.pixBool}");
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const VerticalSpacerBox(size: SpacerSize.small),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chave Pix',
                                style: TextStyle(
                                    fontSize: size.height * 0.018,
                                    color: kSecondaryColor,
                                    fontWeight: FontWeight.w700),
                              ),
                              IntrinsicWidth(
                                stepWidth: size.width,
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  elevation: 0,
                                  child: ClipPath(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: CustomTextFormField(
                                        autoValidate: AutovalidateMode.onUserInteraction,
                                        enabled: controller.pixBool,
                                        erroStyle:
                                        const TextStyle(fontSize: 12),
                                        validatorError: (value) {
                                          if(controller.pixBool == true) {
                                            if (value.isEmpty) {
                                              return 'Obrigatório';
                                            }
                                          }
                                        },
                                        hintText: "Chave Pix",
                                        controller:
                                        controller.pixController,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const VerticalSpacerBox(size: SpacerSize.small),
                          Text(
                            'Realizará entregas?',
                            style: TextStyle(
                                fontSize: size.height * 0.018,
                                color: kSecondaryColor,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: size.height * 0.08,
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: ListTileTheme(
                                    horizontalTitleGap: 0,
                                    child: CheckboxListTile(
                                        contentPadding: EdgeInsets.zero,
                                        activeColor: kPrimaryColor,
                                        value: controller.delivery[0],
                                        title: Text(
                                          'Sim',
                                          style: TextStyle(
                                              fontSize: size.height * 0.018),
                                        ),
                                        checkboxShape: const CircleBorder(),
                                        controlAffinity:
                                        ListTileControlAffinity.leading,
                                        onChanged: (value) {
                                          controller.onDeliveryTapped(0);
                                        }
                                    ),
                                  ),
                                ),
                                Flexible(
                                    child: ListTileTheme(
                                      horizontalTitleGap: 0,
                                      child: CheckboxListTile(
                                        contentPadding: EdgeInsets.zero,
                                        activeColor: kPrimaryColor,
                                        value: controller.delivery[1],
                                        title: Text(
                                          'Não',
                                          style: TextStyle(
                                              fontSize: size.height * 0.018),
                                        ),
                                        checkboxShape: const CircleBorder(),
                                        controlAffinity:
                                        ListTileControlAffinity.leading,
                                        onChanged: (value) =>
                                            controller.onDeliveryTapped(1),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Divider(
                            height: size.height * 0.025,
                            color: Colors.transparent,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Valor mínimo para frete',
                                  style: kTitle1.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: size.height * 0.018,
                                      color: kSecondaryColor)),
                              SizedBox(
                                width: size.width,
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  elevation: 0,
                                  child: ClipPath(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: CustomTextFormFieldCurrency(
                                        autoValidate: AutovalidateMode.onUserInteraction,
                                        enabled: controller.delivery[0],
                                        erroStyle:
                                        const TextStyle(fontSize: 12),
                                        validatorError: (value) {
                                          if(controller.delivery[0] == true) {
                                            if (value.isEmpty) {
                                              return 'Obrigatório';
                                            }
                                          }
                                        },
                                        hintText: "R\$ $freteCorreto",
                                        currencyFormatter: <TextInputFormatter>[
                                          CurrencyTextInputFormatter(
                                            locale: 'pt_BR',
                                            symbol: 'R\$',
                                            decimalDigits: 2,
                                          ),
                                          LengthLimitingTextInputFormatter(
                                              8),
                                        ],
                                        keyboardType: TextInputType.number,
                                        controller:
                                        controller.quantiaMinController,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const VerticalSpacerBox(size: SpacerSize.large),
                          SizedBox(
                            width: size.width,
                            height: size.height * 0.06,
                            child: PrimaryButton(
                                text: 'Salvar',
                                onPressed: () {
                                  final isValidForm = controller
                                      .formKey.currentState!
                                      .validate();
                                  if (isValidForm) {
                                    if (controller.verifySelectedFields()) {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              DefaultAlertDialogOneButton(
                                                title: 'Êxito',
                                                body:
                                                'Suas informações foram alteradas com sucesso',
                                                confirmText: 'Ok',
                                                onConfirm: () {
                                                  controller.editBanca(
                                                      context,
                                                      widget.bancaModel!);
                                                },
                                                buttonColor: kAlertColor,
                                              ));
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              DefaultAlertDialogOneButton(
                                                title: 'Erro',
                                                body: controller.textoErro,
                                                confirmText: 'Voltar',
                                                onConfirm: () => Get.back(),
                                                buttonColor: kAlertColor,
                                              ));
                                    }
                                  }
                                }),
                          ),
                          Divider(
                              height: size.height * 0.015,
                              color: Colors.transparent),
                          SizedBox(
                            width: size.width,
                            height: size.height * 0.06,
                            child: OutlinedButton(
                              onPressed: () => Get.off(() => const HomeScreen()),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(
                                    color: Colors.orange, width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Text(
                                'Voltar',
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: size.height * 0.024,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              )),
        ));
  }
}

List<int> _extractHoursAndMinutes(String time) {
  final exp = RegExp(r"(\d{2})+:?(\d{2})+");
  Match? match = exp.firstMatch(time);

  if (match != null) {
    int hours = int.parse(match.group(1)!);
    int minutes = int.parse(match.group(2)!);
    return [hours, minutes];
  } else {
    // Se não houver correspondência, retorna uma lista com valores padrão
    return [0, 0];
  }
}

class _HourInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.length > 4) {
      newText = newText.substring(0, 4);
    }

    if (newText.length >= 2) {
      int hours = int.parse(newText.substring(0, 2));
      hours = hours.clamp(0, 23);

      String formattedText = hours.toString().padLeft(2, '0');

      if (newText.length >= 3) {
        int minutes =
            int.tryParse(newText.substring(2, min(newText.length, 4))) ?? 0;

        // Avoid adding leading zero for the first digit of minutes
        if (newText.length > 3) {
          minutes = minutes.clamp(0, 59);
          formattedText += ':${minutes.toString().padLeft(2, '0')}';
        } else {
          formattedText += ':$minutes';
        }
      } else {
        formattedText += ':${newText.substring(2)}';
      }

      newText = formattedText;
    }

    // Allow deleting characters without needing to tap again for the cursor to move
    if (newValue.text.length < oldValue.text.length) {
      newText = newText.substring(0, max(0, newText.length - 1));
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
