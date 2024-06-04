import 'package:flutter/material.dart';
import 'package:thunderapp/components/buttons/cancel_button.dart';
import 'package:thunderapp/components/buttons/primary_button.dart';
import 'package:thunderapp/screens/order_detail/components/list_itens.dart';
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
  State<OrderDetailScreen> createState() =>
      _OrderDetailScreenState();
}

class _OrderDetailScreenState
    extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.model.status == "aguardando confirmação") {
      widget.model.consumidorName;
      Size size = MediaQuery.of(context).size;
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Detalhe pedido #${widget.model.id}',
            style: kTitle2.copyWith(color: kPrimaryColor),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(
              kDefaultPadding - kSmallSize),
          height: size.height,
          child: Container(
            decoration: BoxDecoration(
              color:
              Colors.white, // Cor de fundo do Container
              borderRadius: BorderRadius.circular(
                  10), // Bordas arredondadas
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(
                      0.5), // Cor da sombra com transparência
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding:
              const EdgeInsets.all(kDefaultPadding),
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pedido #${widget.model.id.toString()}',
                        style: TextStyle(
                            fontSize: size.height * 0.018),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(
                            widget.model.dataPedido!),
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
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Cliente:',
                        style: TextStyle(
                            fontSize: size.height * 0.022,
                            color: kTextButtonColor),
                      ),
                      Padding(
                          padding:
                          const EdgeInsetsDirectional
                              .only(start: 10),
                          child: Text(widget
                              .model.consumidorName!)),
                      const SizedBox()
                    ],
                  ),
                  Divider(
                    height: size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Forma de pagamento:',
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            color: kTextButtonColor),
                      ),
                      Text(
                        widget.model.formaDePagamento!,
                        style: TextStyle(
                            fontSize: size.height * 0.018),
                      ),
                      widget.model.bancaId == 'pix'
                          ? IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                AlertDialogComprovante(
                                  title: 'Comprovante',
                                  body:
                                  'Você quer visualizar ou baixar o comprovante?',
                                  viewText: 'Visualizar',
                                  downloadText: 'Baixar',
                                  view: () async {
                                    await widget
                                        .controller
                                        .fetchComprovanteBytes(
                                        widget.model
                                            .id!);
                                    if (widget.controller
                                        .comprovanteBytes !=
                                        null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                              FileViewScreen(
                                                comprovanteBytes: widget
                                                    .controller
                                                    .comprovanteBytes!,
                                                comprovanteType: widget
                                                    .controller
                                                    .comprovanteType!,
                                              ),
                                        ),
                                      );
                                    }
                                  },
                                  download: () async {
                                    await widget
                                        .controller
                                        .downloadComprovante(
                                        widget.model
                                            .id!);
                                    if (widget.controller
                                        .downloadPath !=
                                        null) {
                                      ScaffoldMessenger
                                          .of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Comprovante baixado com sucesso!')),
                                      );
                                    }
                                  },
                                  viewColor:
                                  kSuccessColor,
                                  downloadColor:
                                  kErrorColor,
                                ),
                          );
                        },
                        icon: const Icon(
                          Icons.image,
                          color: kPrimaryColor,
                        ),
                      )
                          : const Text('')
                    ],
                  ),
                  Divider(
                    height: size.height * 0.01,
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Tipo de entrega:',
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            color: kTextButtonColor),
                      ),
                      Text(
                        widget.model.tipoEntrega.toString(),
                        style: TextStyle(
                            fontSize: size.height * 0.018),
                      ),
                    ],
                  ),
                  Divider(
                    height: size.height * 0.02,
                    color: Colors.transparent,
                  ),
                  // const InformationHolder(),
                  Divider(
                    height: size.height * 0.02,
                    color: Colors.transparent,
                  ),
                  Expanded(
                    child: ItensPedidoWidget(
                        pedidoId: widget.model.id!),
                  ),
                  Divider(
                    height: size.height * 0.03,
                    color: Colors.transparent,
                  ),
                  // Row(
                  //   mainAxisAlignment:
                  //       MainAxisAlignment.spaceBetween,
                  //   children: <Widget>[
                  //     Text(
                  //       'Taxa de entrega',
                  //       style: TextStyle(
                  //           fontSize: size.height * 0.018),
                  //     ),
                  //     Text(
                  //       NumberFormat.simpleCurrency(
                  //               locale: 'pt-BR',
                  //               decimalDigits: 2)
                  //           .format(
                  //               widget.model.taxaEntrega),
                  //       style: TextStyle(
                  //           fontSize: size.height * 0.018),
                  //     ),
                  //   ],
                  // ),
                  Divider(
                    height: size.height * 0.015,
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Total do pedido',
                        style: TextStyle(
                            fontSize: size.height * 0.018),
                      ),
                      Text(
                        NumberFormat.simpleCurrency(
                            locale: 'pt-BR',
                            decimalDigits: 2)
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
                  mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(
                      width: 168,
                      child: PrimaryButton(
                        text: 'Confirmar',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                DefaultAlertDialog(
                                  title: 'Confirmar',
                                  body:
                                  'Você tem certeza que deseja aceitar o pedido?',
                                  confirmText: 'Sim',
                                  cancelText: 'Não',
                                  onConfirm: () {
                                    widget.controller
                                        .setConfirm(true);
                                    widget.controller
                                        .confirmOrder(context,
                                        widget.model.id!);
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
                            builder: (context) =>
                                DefaultAlertDialog(
                                  title: 'Recusar',
                                  body:
                                  'Você tem certeza que deseja recusar o pedido?',
                                  confirmText: 'Sim',
                                  cancelText: 'Não',
                                  onConfirm: () {
                                    widget.controller
                                        .confirmOrder(context,
                                        widget.model.id!);
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
    } else if (widget.model.status ==
        "comprovante anexado") {
      Size size = MediaQuery.of(context).size;
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Detalhe pedido #${widget.model.id}',
            style: kTitle2.copyWith(color: kPrimaryColor),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(
              kDefaultPadding - kSmallSize),
          height: size.height,
          child: Container(
            decoration: BoxDecoration(
              color:
              Colors.white, // Cor de fundo do Container
              borderRadius: BorderRadius.circular(
                  10), // Bordas arredondadas
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(
                      0.5), // Cor da sombra com transparência
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding:
              const EdgeInsets.all(kDefaultPadding),
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pedido #${widget.model.id.toString()}',
                        style: TextStyle(
                            fontSize: size.height * 0.018),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(
                            widget.model.dataPedido!),
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
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Cliente:',
                        style: TextStyle(
                            fontSize: size.height * 0.022,
                            color: kTextButtonColor),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional
                            .only(start: 10),
                        child: Text(
                          widget.model.consumidorName
                              .toString(),
                          style: TextStyle(
                              fontSize: size.height * 0.018,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox()
                    ],
                  ),
                  Divider(
                    height: size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Forma de pagamento:',
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            color: kTextButtonColor),
                      ),
                      Text(
                        widget.model.formaDePagamento!,
                        style: TextStyle(
                            fontSize: size.height * 0.018),
                      ),
                      widget.model.formaDePagamento == 'pix'
                          ? IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                AlertDialogComprovante(
                                  title: 'Comprovante',
                                  body:
                                  'Você quer visualizar ou baixar o comprovante?',
                                  viewText: 'Visualizar',
                                  downloadText: 'Baixar',
                                  view: () async {
                                    await widget
                                        .controller
                                        .fetchComprovanteBytes(
                                        widget.model
                                            .id!);
                                    if (widget.controller
                                        .comprovanteBytes !=
                                        null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                              FileViewScreen(
                                                comprovanteBytes: widget
                                                    .controller
                                                    .comprovanteBytes!,
                                                comprovanteType: widget
                                                    .controller
                                                    .comprovanteType!,
                                              ),
                                        ),
                                      );
                                    }
                                  },
                                  download: () async {
                                    await widget
                                        .controller
                                        .downloadComprovante(
                                        widget.model
                                            .id!);
                                    if (widget.controller
                                        .downloadPath !=
                                        null) {
                                      ScaffoldMessenger
                                          .of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Comprovante baixado com sucesso!')),
                                      );
                                    }
                                  },
                                  viewColor:
                                  kSuccessColor,
                                  downloadColor:
                                  kErrorColor,
                                ),
                          );
                        },
                        icon: const Icon(
                          Icons.image,
                          color: kPrimaryColor,
                        ),
                      )
                          : const Text('')
                    ],
                  ),
                  Divider(
                    height: size.height * 0.01,
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Tipo de entrega:',
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            color: kTextButtonColor),
                      ),
                      Text(
                        widget.model.tipoEntrega.toString(),
                        style: TextStyle(
                            fontSize: size.height * 0.018),
                      ),
                    ],
                  ),
                  Divider(
                    height: size.height * 0.02,
                    color: Colors.transparent,
                  ),
                  // const InformationHolder(),
                  Divider(
                    height: size.height * 0.02,
                    color: Colors.transparent,
                  ),
                  Expanded(
                    child: ItensPedidoWidget(
                        pedidoId: widget.model.id!),
                  ),
                  Divider(
                    height: size.height * 0.03,
                    color: Colors.transparent,
                  ),
                  // Row(
                  //   mainAxisAlignment:
                  //       MainAxisAlignment.spaceBetween,
                  //   children: <Widget>[
                  //     Text(
                  //       'Taxa de entrega',
                  //       style: TextStyle(
                  //           fontSize: size.height * 0.018),
                  //     ),
                  //     Text(
                  //       NumberFormat.simpleCurrency(
                  //               locale: 'pt-BR',
                  //               decimalDigits: 2)
                  //           .format(
                  //               widget.model.taxaEntrega),
                  //       style: TextStyle(
                  //           fontSize: size.height * 0.018),
                  //     ),
                  //   ],
                  // ),
                  Divider(
                    height: size.height * 0.015,
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Total do pedido',
                        style: TextStyle(
                            fontSize: size.height * 0.018),
                      ),
                      Text(
                        NumberFormat.simpleCurrency(
                            locale: 'pt-BR',
                            decimalDigits: 2)
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
                          builder: (context) =>
                              DefaultAlertDialog(
                                title: 'Confirmar',
                                body:
                                'O pedido está pronto para entrega/retirada?',
                                confirmText: 'Sim',
                                cancelText: 'Não',
                                onConfirm: () {
                                  widget.controller
                                      .confirmDeliver(context,
                                      widget.model.id!);
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
            'Detalhe pedido #${widget.model.id}',
            style: kTitle2.copyWith(color: kPrimaryColor),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(
              kDefaultPadding - kSmallSize),
          height: size.height,
          child: Container(
            decoration: BoxDecoration(
              color:
              Colors.white, // Cor de fundo do Container
              borderRadius: BorderRadius.circular(
                  10), // Bordas arredondadas
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(
                      0.5), // Cor da sombra com transparência
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding:
              const EdgeInsets.all(kDefaultPadding),
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pedido #${widget.model.id.toString()}',
                        style: TextStyle(
                            fontSize: size.height * 0.018),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(
                            widget.model.dataPedido!),
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
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Cliente:',
                        style: TextStyle(
                            fontSize: size.height * 0.022,
                            color: kTextButtonColor),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional
                            .only(start: 10),
                        child: Text(
                          widget.model.consumidorName
                              .toString(),
                          style: TextStyle(
                              fontSize: size.height * 0.018,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox()
                    ],
                  ),
                  Divider(
                    height: size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Forma de pagamento:',
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            color: kTextButtonColor),
                      ),
                      Text(
                        widget.model.formaDePagamento!,
                        style: TextStyle(
                            fontSize: size.height * 0.018),
                      ),
                      widget.model.formaDePagamento == "pix"
                          ? IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                AlertDialogComprovante(
                                  title: 'Comprovante',
                                  body:
                                  'Você quer visualizar ou baixar o comprovante?',
                                  viewText: 'Visualizar',
                                  downloadText: 'Baixar',
                                  view: () async {
                                    await widget
                                        .controller
                                        .fetchComprovanteBytes(
                                        widget.model
                                            .id!);
                                    if (widget.controller
                                        .comprovanteBytes !=
                                        null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                              FileViewScreen(
                                                comprovanteBytes: widget
                                                    .controller
                                                    .comprovanteBytes!,
                                                comprovanteType: widget
                                                    .controller
                                                    .comprovanteType!,
                                              ),
                                        ),
                                      );
                                    }
                                  },
                                  download: () async {
                                    await widget
                                        .controller
                                        .downloadComprovante(
                                        widget.model
                                            .id!);
                                    if (widget.controller
                                        .downloadPath !=
                                        null) {
                                      ScaffoldMessenger
                                          .of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Comprovante baixado com sucesso!')),
                                      );
                                    }
                                  },
                                  viewColor:
                                  kSuccessColor,
                                  downloadColor:
                                  kErrorColor,
                                ),
                          );
                        },
                        icon: const Icon(
                          Icons.image,
                          color: kPrimaryColor,
                        ),
                      )
                          : const Text('')
                    ],
                  ),
                  Divider(
                    height: size.height * 0.01,
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Tipo de entrega:',
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            color: kTextButtonColor),
                      ),
                      Text(
                        widget.model.tipoEntrega.toString(),
                        style: TextStyle(
                            fontSize: size.height * 0.018),
                      ),
                    ],
                  ),
                  Divider(
                    height: size.height * 0.02,
                    color: Colors.transparent,
                  ),
                  // const InformationHolder(),
                  Divider(
                    height: size.height * 0.02,
                    color: Colors.transparent,
                  ),
                  Expanded(
                    child: ItensPedidoWidget(
                        pedidoId: widget.model.id!),
                  ),

                  Divider(
                    height: size.height * 0.03,
                    color: Colors.transparent,
                  ),
                  // Row(
                  //   mainAxisAlignment:
                  //       MainAxisAlignment.spaceBetween,
                  //   children: <Widget>[
                  //     Text(
                  //       'Taxa de entrega',
                  //       style: TextStyle(
                  //           fontSize: size.height * 0.018),
                  //     ),
                  //     Text(
                  //       NumberFormat.simpleCurrency(
                  //               locale: 'pt-BR',
                  //               decimalDigits: 2)
                  //           .format(
                  //               widget.model.taxaEntrega),
                  //       style: TextStyle(
                  //           fontSize: size.height * 0.018),
                  //     ),
                  //   ],
                  // ),
                  Divider(
                    height: size.height * 0.015,
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Total do pedido',
                        style: TextStyle(
                            fontSize: size.height * 0.018),
                      ),
                      Text(
                        NumberFormat.simpleCurrency(
                            locale: 'pt-BR',
                            decimalDigits: 2)
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
