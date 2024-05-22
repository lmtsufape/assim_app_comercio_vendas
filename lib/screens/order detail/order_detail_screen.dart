import 'package:flutter/material.dart';
import 'package:thunderapp/components/buttons/cancel_button.dart';
import 'package:thunderapp/components/buttons/primary_button.dart';
import 'package:thunderapp/components/utils/vertical_spacer_box.dart';
import 'package:thunderapp/shared/constants/app_enums.dart';
import 'package:thunderapp/shared/constants/app_number_constants.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      persistentFooterButtons: [
        SizedBox(
          child: Column(
            children: <Widget>[
              const Text(
                'Confirmar pedido?',
                style: kBody1,
              ),
              const VerticalSpacerBox(
                  size: SpacerSize.medium),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    width: 168,
                    child: PrimaryButton(
                        text: 'Confirmar',
                        onPressed: () {}),
                  ),
                  SizedBox(
                    width: 168,
                    child: CancelButton(
                        text: 'Cancelar', onPressed: () {}),
                  )
                ],
              )
            ],
          ),
        )
      ],
      appBar: AppBar(
        title: Text(
          'Detalhe pedido #01023',
          style: kTitle2.copyWith(color: kPrimaryColor),
        ),
      ),
      body: Container(
          padding: const EdgeInsets.all(
              kDefaultPadding - kSmallSize),
          height: size.height,
          child: Card(
            child: Padding(
              padding:
                  const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pedido 010101',
                        style: kBody3.copyWith(
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '10/10/2022',
                        style: kCaption2.copyWith(
                            color: kTextButtonColor),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Cliente:',
                        style: kCaption2.copyWith(
                            color: kTextButtonColor),
                      ),
                      const Text('Nome do Cliente',
                          style: kCaption1),
                      const SizedBox()
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Forma de pagamento:',
                        style: kCaption2.copyWith(
                            color: kTextButtonColor),
                      ),
                      const Text(
                        'PIX',
                        style: kBody2,
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.image,
                            color: kSuccessColor,
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Tipo de entrega:',
                        style: kCaption2.copyWith(
                            color: kTextButtonColor),
                      ),
                      const Text(
                        'Entrega',
                        style: kBody2,
                      ),
                      const SizedBox(),
                    ],
                  ),
                  const InformationHolder(),
                  const InformationHolder(),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Taxa de entrega',
                        style: kCaption2.copyWith(
                            color: kTextButtonColor),
                      ),
                      const Text(
                        '7,00',
                        style: kBody2,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Total do pedido',
                          style: kBody1),
                      Text(
                        '7,00',
                        style: kBody2.copyWith(
                            color: kAlertColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class InformationHolder extends StatelessWidget {
  const InformationHolder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Endereço:',
          style: kBody3,
        ),
        Padding(
          padding: const EdgeInsets.only(left: kHugeSize),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Rua professora Esmeralda Barros, 67'),
              Text('Apartamento'),
              Text('Caruaru, PE, 5504200'),
              Text('Brasil'),
              Text('Contato: (81) 99699-7476'),
            ],
          ),
        )
      ],
    );
  }
}
