import 'package:flutter/material.dart';
import 'package:thunderapp/components/buttons/cancel_button.dart';
import 'package:thunderapp/components/buttons/primary_button.dart';
import 'package:thunderapp/screens/order_detail/file_view_screen.dart';
import 'package:thunderapp/shared/constants/app_number_constants.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';
import 'package:intl/intl.dart';
import '../../shared/components/dialogs/default_alert_dialog.dart';
import '../../shared/core/models/pedido_model.dart';
import '../orders/orders_controller.dart';

// ignore: must_be_immutable
class OrderDetailScreen extends StatefulWidget {
  PedidoModel model;
  OrdersController controller;

  OrderDetailScreen(
      this.model,
      this.controller, {
        Key? key,
      }) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.model.status == "aguardando confirmação") {
      Size size = MediaQuery.of(context).size;
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Detalhe pedido #0${widget.model.id}',
            style: kTitle2.copyWith(color: kPrimaryColor),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(kDefaultPadding - kSmallSize),
          height: size.height,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pedido #${widget.model.id.toString()}',
                        style: TextStyle(fontSize: size.height * 0.018),
                      ),
                      Text(
                        widget.model.dataPedido.toString(),
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Divider(
                    height: size.height * 0.01,
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Cliente:',
                        style: TextStyle(
                            fontSize: size.height * 0.022,
                            color: kTextButtonColor),
                      ),
                      const Padding(
                        padding: EdgeInsetsDirectional.only(start: 10),
                        // child: Text(widget.model.consumidorId.toString(),
                        //     style: TextStyle(fontSize: size.height * 0.018, fontWeight: FontWeight.w700),),
                      ),
                      const SizedBox()
                    ],
                  ),
                  Divider(
                    height: size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Forma de pagamento:',
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            color: kTextButtonColor),
                      ),
                      Text(
                         widget.model.formaPagamentoId == 1 ? "Pix" : "Dinheiro",
                         style: TextStyle(fontSize: size.height * 0.018),
                       ),
                    ],
                  ),
                  Divider(
                    height: size.height * 0.01,
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Tipo de entrega:',
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            color: kTextButtonColor),
                      ),
                      Text(
                        widget.model.tipoEntrega.toString(),
                        style: TextStyle(fontSize: size.height * 0.018),
                      ),
                    ],
                  ),
                  Divider(
                    height: size.height * 0.02,
                    color: Colors.transparent,
                  ),
                  const InformationHolder(),
                  Divider(
                    height: size.height * 0.02,
                    color: Colors.transparent,
                  ),
                  const ItensOrder(),
                  Divider(
                    height: size.height * 0.03,
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Taxa de entrega',
                        style: TextStyle(fontSize: size.height * 0.018),
                      ),
                      Text(
                        NumberFormat.simpleCurrency(
                            locale: 'pt-BR', decimalDigits: 2)
                            .format(widget.model.taxaEntrega),
                        style: TextStyle(fontSize: size.height * 0.018),
                      ),
                    ],
                  ),
                  Divider(
                    height: size.height * 0.015,
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Total do pedido',
                        style: TextStyle(fontSize: size.height * 0.018),
                      ),
                      Text(
                        NumberFormat.simpleCurrency(
                            locale: 'pt-BR', decimalDigits: 2)
                            .format(widget.model.subtotal),
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            color: kPrimaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        persistentFooterButtons: [
          SizedBox(
            child: Column(
              children: <Widget>[
                Divider(
                  height: size.height * 0.006,
                  color: Colors.transparent,
                ),
                Text(
                  'Confirmar pedido?',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: size.height * 0.020),
                ),
                Divider(
                  height: size.height * 0.015,
                  color: Colors.transparent,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(
                      width: 168,
                      child: PrimaryButton(
                        text: 'Confirmar',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => DefaultAlertDialog(
                              title: 'Confirmar',
                              body:
                              'Você tem certeza que deseja aceitar o pedido?',
                              confirmText: 'Sim',
                              cancelText: 'Não',
                              onConfirm: () {
                                widget.controller.setConfirm(true);
                                widget.controller
                                    .confirmOrder(context, widget.model.id!);
                              },
                              confirmColor: kSuccessColor,
                              cancelColor: kErrorColor,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 168,
                      child: CancelButton(
                        text: 'Cancelar',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => DefaultAlertDialog(
                              title: 'Recusar',
                              body:
                              'Você tem certeza que deseja recusar o pedido?',
                              confirmText: 'Sim',
                              cancelText: 'Não',
                              onConfirm: () {
                                widget.controller
                                    .confirmOrder(context, widget.model.id!);
                              },
                              confirmColor: kSuccessColor,
                              cancelColor: kErrorColor,
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      );
    } else if (widget.model.status == "comprovante anexado") {
      Size size = MediaQuery.of(context).size;
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Detalhe pedido #0${widget.model.id}',
            style: kTitle2.copyWith(color: kPrimaryColor),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(kDefaultPadding - kSmallSize),
          height: size.height,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pedido #${widget.model.id.toString()}',
                        style: TextStyle(fontSize: size.height * 0.018),
                      ),
                      Text(
                        widget.model.dataPedido.toString(),
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Divider(
                    height: size.height * 0.01,
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Cliente:',
                        style: TextStyle(
                            fontSize: size.height * 0.022,
                            color: kTextButtonColor),
                      ),
                      const Padding(
                        padding: EdgeInsetsDirectional.only(start: 10),
                        // child: Text(widget.model.consumidorId.toString(),
                        //     style: TextStyle(fontSize: size.height * 0.018, fontWeight: FontWeight.w700),),
                      ),
                      const SizedBox()
                    ],
                  ),
                  Divider(
                    height: size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Forma de pagamento:',
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            color: kTextButtonColor),
                      ),
                      // Text(
                      //   widget.model.tipoPagamentoId.toString(),
                      //   style: TextStyle(fontSize: size.height * 0.018),
                      // ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialogComprovante(
                              title: 'Comprovante',
                              body:
                              'Você quer visualizar ou baixar o comprovante?',
                              viewText: 'Visualizar',
                              downloadText: 'Baixar',
                              view: () async {
                                await widget.controller
                                    .fetchComprovanteBytes(widget.model.id!);
                                if (widget.controller.comprovanteBytes !=
                                    null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FileViewScreen(
                                        comprovanteBytes:
                                        widget.controller.comprovanteBytes!,
                                        comprovanteType:
                                        widget.controller.comprovanteType!,
                                      ),
                                    ),
                                  );
                                }
                              },
                              download: () async {
                                await widget.controller
                                    .downloadComprovante(widget.model.id!);
                                if (widget.controller.downloadPath != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Comprovante baixado com sucesso!')),
                                  );
                                }
                              },
                              viewColor: kSuccessColor,
                              downloadColor: kErrorColor,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.image,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: size.height * 0.01,
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Tipo de entrega:',
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            color: kTextButtonColor),
                      ),
                      Text(
                        widget.model.tipoEntrega.toString(),
                        style: TextStyle(fontSize: size.height * 0.018),
                      ),
                    ],
                  ),
                  Divider(
                    height: size.height * 0.02,
                    color: Colors.transparent,
                  ),
                  const InformationHolder(),
                  Divider(
                    height: size.height * 0.02,
                    color: Colors.transparent,
                  ),
                  const ItensOrder(),
                  Divider(
                    height: size.height * 0.03,
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Taxa de entrega',
                        style: TextStyle(fontSize: size.height * 0.018),
                      ),
                      Text(
                        NumberFormat.simpleCurrency(
                            locale: 'pt-BR', decimalDigits: 2)
                            .format(widget.model.taxaEntrega),
                        style: TextStyle(fontSize: size.height * 0.018),
                      ),
                    ],
                  ),
                  Divider(
                    height: size.height * 0.015,
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Total do pedido',
                        style: TextStyle(fontSize: size.height * 0.018),
                      ),
                      Text(
                        NumberFormat.simpleCurrency(
                            locale: 'pt-BR', decimalDigits: 2)
                            .format(widget.model.subtotal),
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            color: kPrimaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        persistentFooterButtons: [
          SizedBox(
            child: Column(
              children: <Widget>[
                Divider(
                  height: size.height * 0.006,
                  color: Colors.transparent,
                ),
                Text(
                  'Confirmar entrega/retirada',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: size.height * 0.020),
                ),
                Divider(
                  height: size.height * 0.015,
                  color: Colors.transparent,
                ),
                Center(
                  child: SizedBox(
                    width: 168,
                    child: PrimaryButton(
                      text: 'Confirmar',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => DefaultAlertDialog(
                            title: 'Confirmar',
                            body: 'O pedido está pronto para entrega/retirada?',
                            confirmText: 'Sim',
                            cancelText: 'Não',
                            onConfirm: () {
                              widget.controller
                                  .confirmDeliver(context, widget.model.id!);
                            },
                            confirmColor: kSuccessColor,
                            cancelColor: kErrorColor,
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      );
    } else {
      Size size = MediaQuery.of(context).size;
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Detalhe pedido #0${widget.model.id}',
            style: kTitle2.copyWith(color: kPrimaryColor),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(kDefaultPadding - kSmallSize),
          height: size.height,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pedido #${widget.model.id.toString()}',
                        style: TextStyle(fontSize: size.height * 0.018),
                      ),
                      Text(
                        widget.model.dataPedido.toString(),
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Divider(
                    height: size.height * 0.01,
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Cliente:',
                        style: TextStyle(
                            fontSize: size.height * 0.022,
                            color: kTextButtonColor),
                      ),
                      const Padding(
                        padding: EdgeInsetsDirectional.only(start: 10),
                        // child: Text(widget.model.consumidorId.toString(),
                        //     style: TextStyle(fontSize: size.height * 0.018, fontWeight: FontWeight.w700),),
                      ),
                      const SizedBox()
                    ],
                  ),
                  Divider(
                    height: size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Forma de pagamento:',
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            color: kTextButtonColor),
                      ),
                      // Text(
                      //   widget.model.tipoPagamentoId.toString(),
                      //   style: TextStyle(fontSize: size.height * 0.018),
                      // ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialogComprovante(
                              title: 'Comprovante',
                              body:
                              'Você quer visualizar ou baixar o comprovante?',
                              viewText: 'Visualizar',
                              downloadText: 'Baixar',
                              view: () async {
                                await widget.controller
                                    .fetchComprovanteBytes(widget.model.id!);
                                if (widget.controller.comprovanteBytes !=
                                    null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FileViewScreen(
                                        comprovanteBytes:
                                        widget.controller.comprovanteBytes!,
                                        comprovanteType:
                                        widget.controller.comprovanteType!,
                                      ),
                                    ),
                                  );
                                }
                              },
                              download: () async {
                                await widget.controller
                                    .downloadComprovante(widget.model.id!);
                                if (widget.controller.downloadPath != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Comprovante baixado com sucesso!')),
                                  );
                                }
                              },
                              viewColor: kSuccessColor,
                              downloadColor: kErrorColor,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.image,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: size.height * 0.01,
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Tipo de entrega:',
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            color: kTextButtonColor),
                      ),
                      Text(
                        widget.model.tipoEntrega.toString(),
                        style: TextStyle(fontSize: size.height * 0.018),
                      ),
                    ],
                  ),
                  Divider(
                    height: size.height * 0.02,
                    color: Colors.transparent,
                  ),
                  const InformationHolder(),
                  Divider(
                    height: size.height * 0.02,
                    color: Colors.transparent,
                  ),
                  const ItensOrder(),
                  Divider(
                    height: size.height * 0.03,
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Taxa de entrega',
                        style: TextStyle(fontSize: size.height * 0.018),
                      ),
                      Text(
                        NumberFormat.simpleCurrency(
                            locale: 'pt-BR', decimalDigits: 2)
                            .format(widget.model.taxaEntrega),
                        style: TextStyle(fontSize: size.height * 0.018),
                      ),
                    ],
                  ),
                  Divider(
                    height: size.height * 0.015,
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Total do pedido',
                        style: TextStyle(fontSize: size.height * 0.018),
                      ),
                      Text(
                        NumberFormat.simpleCurrency(
                            locale: 'pt-BR', decimalDigits: 2)
                            .format(widget.model.subtotal),
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            color: kPrimaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

class InformationHolder extends StatefulWidget {
  const InformationHolder({
    Key? key,
  }) : super(key: key);

  @override
  State<InformationHolder> createState() => _InformationHolderState();
}

class _InformationHolderState extends State<InformationHolder> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Endereço:',
          style: TextStyle(fontSize: size.height * 0.018),
        ),
        Padding(
          padding: const EdgeInsets.only(left: kHugeSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Rua professora Esmeralda Barros, 67',
                  style: TextStyle(fontSize: size.height * 0.018)),
              Text('Boa Vista',
                  style: TextStyle(fontSize: size.height * 0.018)),
              Text('Apartamento',
                  style: TextStyle(fontSize: size.height * 0.018)),
              Text('Contato: (81) 99699-7476',
                  style: TextStyle(fontSize: size.height * 0.018)),
            ],
          ),
        )
      ],
    );
  }
}

class ItensOrder extends StatefulWidget {
  const ItensOrder({super.key});

  @override
  State<ItensOrder> createState() => _ItensOrderState();
}

class _ItensOrderState extends State<ItensOrder> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Itens:',
          style: TextStyle(fontSize: size.height * 0.018),
        ),
        Divider(
          height: size.height * 0.01,
          color: Colors.transparent,
        ),
        const Column(
          children: [
            ListItens(),
            ListItens(),
            ListItens(),
            ListItens(),
          ],
        ),
      ],
    );
  }
}

class ListItens extends StatefulWidget {
  const ListItens({super.key});

  @override
  State<ListItens> createState() => _ListItensState();
}

class _ListItensState extends State<ListItens> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '2 unid x Pêra',
          style: TextStyle(fontSize: size.height * 0.018),
        ),
        Text(
          'R\$ 6,00',
          style: TextStyle(fontSize: size.height * 0.018),
        ),
      ],
    );
  }
}
