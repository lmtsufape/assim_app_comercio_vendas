import 'package:flutter/material.dart';
import 'package:thunderapp/components/buttons/primary_button.dart';
import 'package:thunderapp/components/forms/custom_text_form_field.dart';
import 'package:thunderapp/components/utils/horizontal_spacer_box.dart';
import 'package:thunderapp/components/utils/vertical_spacer_box.dart';
import 'package:thunderapp/shared/constants/app_enums.dart';

import '../../shared/constants/app_number_constants.dart';
import '../../shared/constants/style_constants.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() =>
      _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pagamentos',
          style: kTitle2.copyWith(color: kPrimaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Cadastrar Pagamento PIX',
              style: kTitle2,
            ),
            const VerticalSpacerBox(size: SpacerSize.medium),
            Form(
                child: Column(
              children: <Widget>[
                const CustomTextFormField(
                  label: 'Nome',
                  isBordered: true,
                ),
                const VerticalSpacerBox(
                    size: SpacerSize.large),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: DropdownButton<String>(
                            hint: const Text('Banco'),
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(
                                  value: 'bb',
                                  child: Text(
                                      'Banco do Brasil 00')),
                              DropdownMenuItem(
                                  value: 'bd',
                                  child: Text('BRADESCO')),
                              DropdownMenuItem(
                                  value: 'cs',
                                  child: Text('CS6 BANK')),
                            ],
                            onChanged: (value) {})),
                    const HorizontalSpacerBox(
                        size: SpacerSize.huge),
                    const Icon(Icons.qr_code)
                  ],
                )
              ],
            )),
            const VerticalSpacerBox(size: SpacerSize.medium),
            const Text('Cadastrar chave', style: kCaption1),
            const VerticalSpacerBox(size: SpacerSize.medium),
            DropdownButton<String>(
                hint: const Text('Tipo de chave'),
                isExpanded: true,
                items: const [
                  DropdownMenuItem(
                      value: 'bb', child: Text('PIX')),
                  DropdownMenuItem(
                      value: 'bd', child: Text('CPF')),
                  DropdownMenuItem(
                      value: 'cs',
                      child: Text('CHAVE ALEATÓRIA')),
                ],
                onChanged: (value) {}),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding),
              child: PrimaryButton(
                  text: 'Salvar', onPressed: () {}),
            ),
            const VerticalSpacerBox(size: SpacerSize.huge)
          ],
        ),
      ),
    );
  }
}
