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

//TELA ASSIM - Edição de banca
class EditStoreScreen extends StatefulWidget {
  BancaModel? bancaModel;

  EditStoreScreen(this.bancaModel, {Key? key}) : super(key: key);

  @override
  State<EditStoreScreen> createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  String? startTime;
  String? endTime;

  @override
  void initState() {
    super.initState();

    final MyStoreController controller = Get.put(MyStoreController());
    
    // Limpa os campos para não serem preenchidos automaticamente,
    // assim o usuário pode escolher quais campos atualizar
    controller.nomeBancaController.clear();
    controller.horarioAberturaController.clear();
    controller.horarioFechamentoController.clear();
    controller.quantiaMinController.clear();
    controller.pixController.clear();
    
    if (widget.bancaModel != null) {
      // Configurar estado do pix baseado na existência de uma chave
      controller.pixBool =
          widget.bancaModel!.pix != null && widget.bancaModel!.pix.isNotEmpty;

      // Definir os itens selecionados de acordo com as formas de pagamento
      String formasPagamento = widget.bancaModel!.formasDePagamento ?? "1";
      List<String> pagamentoSelecionado = formasPagamento.split(",");

      // Configura os checkboxes das formas de pagamento
      controller.isSelected[0] = pagamentoSelecionado.contains("1"); // Dinheiro
      controller.isSelected[1] = pagamentoSelecionado.contains("2"); // PIX
      controller.isSelected[2] = pagamentoSelecionado.contains("3"); // Cartão
      
      // Configurar delivery
      controller.delivery[0] = widget.bancaModel!.fazEntrega ?? false;
      controller.delivery[1] = !(widget.bancaModel!.fazEntrega ?? false);
    } else {
      // Valores padrão caso bancaModel seja nulo
      controller.isSelected[0] = true; // Dinheiro habilitado por padrão
      controller.delivery[1] = true; // "Não" para entregas por padrão
    }
  }

  TimeOfDay _getInitialTime(TextEditingController controller, String defaultTime) {
    final text = controller.text;
    if (text.isEmpty) {
      // Se o controller estiver vazio, tentamos usar o valor padrão
      if (defaultTime.isNotEmpty) {
        final timeParts = defaultTime.split(':');
        if (timeParts.length == 2) {
          final hour = int.tryParse(timeParts[0]) ?? 0;
          final minute = int.tryParse(timeParts[1]) ?? 0;
          return TimeOfDay(hour: hour, minute: minute);
        }
      }
      return TimeOfDay.now();
    }
    
    // Se o controller tiver um valor, usamos ele
    final timeParts = text.split(':');
    if (timeParts.length == 2) {
      final hour = int.tryParse(timeParts[0]) ?? 0;
      final minute = int.tryParse(timeParts[1]) ?? 0;
      return TimeOfDay(hour: hour, minute: minute);
    }
    return TimeOfDay.now();
  }

  String _formatTimeOfDayTo24Hour(TimeOfDay time) {
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final double? doubleFrete =
        double.tryParse(widget.bancaModel?.precoMin ?? '0');
    final String freteCorreto =
        doubleFrete != null ? doubleFrete.toStringAsFixed(2) : '0.00';
    Size size = MediaQuery.of(context).size;

    return GetBuilder<MyStoreController>(
        init: MyStoreController(),
        builder: (controller) => GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: kPrimaryColor,
                    iconTheme: const IconThemeData(color: Colors.white),
                    centerTitle: true,
                    title: Text(
                      'Editar banca',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: size.height * 0.030
                      ),
                    ),
                    automaticallyImplyLeading: true,
                  ),
                  body: SingleChildScrollView(
                    child: Form(
                      key: controller.formKey,
                      child: Container(
                          padding: const EdgeInsets.only(
                              top: 20,
                              left: 26,
                              right: 26,
                              bottom: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Imagem do perfil
                              Center(
                                child: CircleImageProfile(controller),
                              ),
                              Divider(
                                height: size.height * 0.016,
                                color: Colors.transparent,
                              ),
                              
                              // Informações atuais da banca
                              /*Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Informações atuais da banca',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height * 0.018,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text('Nome: ${widget.bancaModel?.nome ?? ""}'),
                                    Text('Horário de Abertura: ${widget.bancaModel?.horarioAbertura ?? ""}'),
                                    Text('Horário de Fechamento: ${widget.bancaModel?.horarioFechamento ?? ""}'),
                                    Text('Preço Mínimo: R\$ ${widget.bancaModel?.precoMin ?? "0.00"}'),
                                    Text('Chave PIX: ${widget.bancaModel?.pix ?? ""}'),
                                  ],
                                ),
                              ),*/
                              
                              const VerticalSpacerBox(size: SpacerSize.small),
                              
                              // Nome da banca
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
                                            hintText: widget.bancaModel?.nome ?? '',
                                            erroStyle: const TextStyle(fontSize: 12),
                                            validatorError: (value) {
                                              if (value.isNotEmpty && value.length < 3) {
                                                return 'O nome deve ter no mínimo 3 caracteres';
                                              }
                                              return null;
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
                              
                              // Horários
                              SizedBox(
                                width: size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Horário de abertura
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Início dos pedidos',
                                          style: TextStyle(
                                            color: kSecondaryColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: size.height * 0.018,
                                          ),
                                        ),
                                        Divider(
                                          height: size.height * 0.006,
                                          color: Colors.transparent,
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.access_time),
                                          onPressed: () async {
                                            final selectedTime = await showTimePicker(
                                              context: context,
                                              cancelText: "Cancelar",
                                              confirmText: "Confirmar",
                                              hourLabelText: "Horas",
                                              minuteLabelText: "Minutos",
                                              helpText: "Insira o horário:",
                                              initialTime: _getInitialTime(
                                                controller.horarioAberturaController, 
                                                widget.bancaModel?.horarioAbertura ?? ""
                                              ),
                                              initialEntryMode: TimePickerEntryMode.inputOnly,
                                              builder: (context, child) {
                                                return Theme(
                                                  data: Theme.of(context).copyWith(
                                                    colorScheme: ColorScheme.light(
                                                      primary: kPrimaryColor,
                                                      onPrimary: Colors.white,
                                                      onSurface: kPrimaryColor,
                                                    ),
                                                  ),
                                                  child: MediaQuery(
                                                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                                    child: child!,
                                                  ),
                                                );
                                              },
                                            );

                                            if (selectedTime != null) {
                                              final formattedTime = _formatTimeOfDayTo24Hour(selectedTime);
                                              final fechamentoTime = controller.horarioFechamentoController.text;

                                              if (fechamentoTime.isNotEmpty &&
                                                  _isClosingTimeInvalid(formattedTime, fechamentoTime)) {
                                                _showSnackbar(context, "O horário de abertura deve ser menor que o de fechamento.");
                                                return;
                                              }

                                              setState(() {
                                                controller.horarioAberturaController.text = formattedTime;
                                              });
                                            }
                                          },
                                        ),
                                        if (controller.horarioAberturaController.text.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              controller.horarioAberturaController.text,
                                              style: TextStyle(
                                                color: kSecondaryColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: size.height * 0.018,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    
                                    // Horário de fechamento
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Término dos pedidos',
                                          style: TextStyle(
                                            color: kSecondaryColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: size.height * 0.018,
                                          ),
                                        ),
                                        Divider(
                                          height: size.height * 0.006,
                                          color: Colors.transparent,
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.access_time),
                                          onPressed: () async {
                                            final selectedTime = await showTimePicker(
                                              context: context,
                                              cancelText: "Cancelar",
                                              confirmText: "Confirmar",
                                              hourLabelText: "Horas",
                                              minuteLabelText: "Minutos",
                                              helpText: "Insira o horário:",
                                              initialTime: _getInitialTime(
                                                controller.horarioFechamentoController,
                                                widget.bancaModel?.horarioFechamento ?? ""
                                              ),
                                              initialEntryMode: TimePickerEntryMode.inputOnly,
                                              builder: (context, child) {
                                                return Theme(
                                                  data: Theme.of(context).copyWith(
                                                    colorScheme: ColorScheme.light(
                                                      primary: kPrimaryColor,
                                                      onPrimary: Colors.white,
                                                      onSurface: kPrimaryColor,
                                                    ),
                                                  ),
                                                  child: MediaQuery(
                                                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                                    child: child!,
                                                  ),
                                                );
                                              },
                                            );

                                            if (selectedTime != null) {
                                              final formattedTime = _formatTimeOfDayTo24Hour(selectedTime);
                                              final aberturaTime = controller.horarioAberturaController.text;

                                              if (aberturaTime.isNotEmpty && 
                                                  _isClosingTimeInvalid(aberturaTime, formattedTime)) {
                                                _showSnackbar(context, "O horário de fechamento deve ser maior que o de abertura.");
                                                return;
                                              }

                                              setState(() {
                                                controller.horarioFechamentoController.text = formattedTime;
                                              });
                                            }
                                          },
                                        ),
                                        if (controller.horarioFechamentoController.text.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              controller.horarioFechamentoController.text,
                                              style: TextStyle(
                                                color: kSecondaryColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: size.height * 0.018,
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
                              
                              // Formas de Pagamento
                              Text('Formas de Pagamento',
                                  style: kTitle1.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: size.height * 0.018,
                                      color: kSecondaryColor)),
                              SizedBox(
                                width: size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Dinheiro
                                    Flexible(
                                      child: ListTileTheme(
                                        horizontalTitleGap: 0,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.zero,
                                          activeColor: kPrimaryColor,
                                          value: controller.isSelected[0],
                                          title: Text(
                                            controller.checkItems[0],
                                            style: TextStyle(fontSize: size.height * 0.016),
                                          ),
                                          checkboxShape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5)),
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) => controller.onItemTapped(0),
                                        ),
                                      ),
                                    ),
                                    
                                    // PIX
                                    Flexible(
                                      child: ListTileTheme(
                                        horizontalTitleGap: 0,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.zero,
                                          activeColor: kPrimaryColor,
                                          value: controller.isSelected[1],
                                          title: Text(
                                            controller.checkItems[1],
                                            style: TextStyle(fontSize: size.height * 0.016),
                                          ),
                                          checkboxShape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5)),
                                          controlAffinity: ListTileControlAffinity.leading,
                                          // No método onItemTapped ou onde o checkbox do PIX é alterado:
                                            onChanged: (value) {
                                              controller.onItemTapped(1);
                                              controller.setPixBool(controller.isSelected[1]);
                                              print("valor do pix: ${controller.pixBool}");
                                            },
                                        ),
                                      ),
                                    ),
                                    
                                    // Cartão
                                    /*Flexible(
                                      child: ListTileTheme(
                                        horizontalTitleGap: 0,
                                        child: CheckboxListTile(
                                          contentPadding: EdgeInsets.zero,
                                          activeColor: kPrimaryColor,
                                          value: controller.isSelected[2],
                                          title: Text(
                                            controller.checkItems[2],
                                            style: TextStyle(fontSize: size.height * 0.016),
                                          ),
                                          checkboxShape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5)),
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) => controller.onItemTapped(2),
                                        ),
                                      ),
                                    ),*/
                                  ],
                                ),
                              ),
                              
                              // Chave PIX (exibida apenas se PIX estiver selecionado)
                              Visibility(
                                visible: controller.pixBool,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const VerticalSpacerBox(size: SpacerSize.small),
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
                                              erroStyle: const TextStyle(fontSize: 12),
                                              validatorError: (value) {
                                                if (controller.pixBool == true) {
                                                  if (value.isEmpty) {
                                                    return 'Obrigatório';
                                                  }
                                                }
                                                return null;
                                              },
                                              hintText: widget.bancaModel?.pix ?? "Chave Pix",
                                              controller: controller.pixController,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const VerticalSpacerBox(size: SpacerSize.small),
                              
                              // Entregas
                              /*Text(
                                'Realizará entregas?',
                                style: TextStyle(
                                    fontSize: size.height * 0.018,
                                    color: kSecondaryColor,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: size.height * 0.08,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            style: TextStyle(fontSize: size.height * 0.018),
                                          ),
                                          checkboxShape: const CircleBorder(),
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) => controller.onDeliveryTapped(0),
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
                                            style: TextStyle(fontSize: size.height * 0.018),
                                          ),
                                          checkboxShape: const CircleBorder(),
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (value) => controller.onDeliveryTapped(1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),*/
                              
                              // Valor mínimo para frete (exibido apenas se entregas estiver ativo)
                              Visibility(
                                visible: controller.delivery[0],
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(
                                      height: size.height * 0.025,
                                      color: Colors.transparent,
                                    ),
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
                                              erroStyle: const TextStyle(fontSize: 12),
                                              validatorError: (value) {
                                                if (controller.delivery[0] == true) {
                                                  if (value.isEmpty) {
                                                    return 'Obrigatório';
                                                  }
                                                }
                                                return null;
                                              },
                                              hintText: "R\$ $freteCorreto",
                                              currencyFormatter: <TextInputFormatter>[
                                                CurrencyTextInputFormatter.currency(
                                                  locale: 'pt_BR',
                                                  symbol: 'R\$',
                                                  decimalDigits: 2,
                                                ),
                                                LengthLimitingTextInputFormatter(8),
                                              ],
                                              keyboardType: TextInputType.number,
                                              controller: controller.quantiaMinController,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const VerticalSpacerBox(size: SpacerSize.large),
                              
                              // Botão Salvar
                              SizedBox(
                                width: size.width,
                                height: size.height * 0.06,
                                child: PrimaryButton(
                                  text: 'Salvar',
                                  // No EditStoreScreen, botão Salvar
                                    onPressed: () async {
                                      print("Validando formulário...");
                                      if (controller.formKey.currentState?.validate() ?? false) {
                                        print("Formulário validado com sucesso.");
                                        
                                        if (controller.verifySelectedFields()) {
                                          // Em vez de mostrar diálogo, mostrar um indicador de carregamento
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) => const Center(child: CircularProgressIndicator()),
                                          );
                                          
                                          // Chamar a edição e aguardar o resultado
                                          bool success = await controller.editBancaAsync(context, widget.bancaModel!);
                                          
                                          // Fechar o diálogo de carregamento
                                          Navigator.of(context).pop();
                                          
                                          if (success) {
                                            showDialog(
                                              context: context,
                                              builder: (context) => DefaultAlertDialogOneButton(
                                                title: 'Êxito',
                                                body: 'Suas informações foram alteradas com sucesso',
                                                confirmText: 'Ok',
                                                onConfirm: () {
                                                  Get.offAll(() => const HomeScreen());
                                                },
                                                buttonColor: kAlertColor,
                                              ),
                                            );
                                          } else {
                                            _showSnackbar(context, "Erro ao editar a banca. Verifique os campos e tente novamente.");
                                          }
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) => DefaultAlertDialogOneButton(
                                              title: 'Erro',
                                              body: controller.textoErro,
                                              confirmText: 'Voltar',
                                              onConfirm: () => Get.back(),
                                              buttonColor: kAlertColor,
                                            ),
                                          );
                                        }
                                      } else {
                                        print("Formulário não validado.");
                                      }
                                    }
                                ),
                              ),
                              
                              // Botão Voltar
                              Divider(height: size.height * 0.015, color: Colors.transparent),
                              SizedBox(
                                width: size.width,
                                height: size.height * 0.06,
                                child: OutlinedButton(
                                  onPressed: () => Get.off(() => const HomeScreen()),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(color: kPrimaryColor, width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: Text(
                                    'Voltar',
                                    style: TextStyle(
                                        color: kPrimaryColor,
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

// Funções auxiliares

bool _isClosingTimeInvalid(String abertura, String fechamento) {
  if (abertura.isEmpty || fechamento.isEmpty) return false;

  try {
    final aberturaParts = abertura.split(":").map(int.parse).toList();
    final fechamentoParts = fechamento.split(":").map(int.parse).toList();

    if (aberturaParts.length < 2 || fechamentoParts.length < 2) return false;

    final aberturaMinutes = aberturaParts[0] * 60 + aberturaParts[1];
    final fechamentoMinutes = fechamentoParts[0] * 60 + fechamentoParts[1];

    return fechamentoMinutes <= aberturaMinutes;
  } catch (e) {
    print("Erro ao validar horários: $e");
    return false;
  }
}

void _showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
    ),
  );
}

List<int> _extractHoursAndMinutes(String time) {
  if (time.isEmpty) return [0, 0];
  
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