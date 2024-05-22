import 'package:flutter/material.dart';
import 'package:thunderapp/components/buttons/primary_button.dart';
import 'package:thunderapp/components/forms/custom_text_form_field.dart';
import 'package:thunderapp/shared/constants/app_number_constants.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informações do perfil'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Center(
              child: CircleAvatar(
                radius: 60,
              ),
            ),
            Center(
              child: TextButton(
                  onPressed: () {},
                  child: const Text('Editar foto')),
            ),
            const Text(
              'Nome',
              style: kBody2,
            ),
            const CustomTextFormField(
              label: 'João',
            ),
            const Text(
              'Endereço',
              style: kBody2,
            ),
            const CustomTextFormField(
              label: 'João',
            ),
            const Text(
              'Forma de envio',
              style: kBody2,
            ),
            Row(
              children: [
                Checkbox(
                    value: false, onChanged: (value) {}),
                const Text('Retirada'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: false, onChanged: (value) {}),
                const Text('Entrega'),
              ],
            ),
            const Text(
              'Forma de Pagamento',
              style: kBody2,
            ),
            Row(
              children: [
                Checkbox(
                    value: false, onChanged: (value) {}),
                const Text('Dinheiro'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: false, onChanged: (value) {}),
                const Text('PIX'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: false, onChanged: (value) {}),
                const Text('Cartão'),
              ],
            ),
            const Spacer(),
            PrimaryButton(text: 'Salvar', onPressed: () {})
          ],
        ),
      ),
    );
  }
}
