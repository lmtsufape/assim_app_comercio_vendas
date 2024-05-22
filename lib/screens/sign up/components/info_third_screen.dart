// import 'package:flutter/material.dart';
// import 'package:thunderapp/shared/constants/style_constants.dart';

// import '../../../components/forms/custom_text_form_field.dart';
// import '../../../components/utils/vertical_spacer_box.dart';
// import '../../../shared/constants/app_enums.dart';

// import '../sign_up_controller.dart';

// // ignore: must_be_immutable
// class InfoThirdScreen extends StatefulWidget {
//   late SignUpController controller;
//   InfoThirdScreen(this.controller, {super.key});

//   @override
//   State<InfoThirdScreen> createState() =>
//       _InfoThirdScreenState();
// }

// class _InfoThirdScreenState extends State<InfoThirdScreen> {
//   void _onItemTapped(int index) {
//     setState(() {
//       widget.controller.isSelected[index] =
//           !widget.controller.isSelected[index];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Nome',
//               style: TextStyle(
//                   color: kTextButtonColor,
//                   fontWeight: FontWeight.w500,
//                   fontSize: size.height * 0.014),
//             ),
//             /*CustomTextFormField(
//                           hintText: widget.bancaModel!.nome,
//                           icon: Icons.person,
//                           controller: controller.nomeBancaController,
//                         ),*/
//             SizedBox(
//               width: size.width,
//               child: Card(
//                 margin: EdgeInsets.zero,
//                 elevation: 0,
//                 child: ClipPath(
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(
//                               color: Colors.black, width: 1)),
//                     ),
//                     alignment: Alignment.center,
//                     child: Expanded(
//                       child: CustomTextFormField(
//                         hintText: 'nome',
//                         controller: widget.controller.nomeBancaController,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//         const VerticalSpacerBox(size: SpacerSize.small),
//         Text('Horário de Funcionamento',
//             style: kTitle1.copyWith(
//                 fontWeight: FontWeight.w500,
//                 fontSize: size.height * 0.014,
//                 color: kTextButtonColor)),
//         SizedBox(
//           width: size.width * 0.65,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Início',
//                     style: TextStyle(
//                         color: kSecondaryColor,
//                         fontWeight: FontWeight.w500,
//                         fontSize: size.height * 0.016),
//                   ),
//                   /*Expanded(
//                                 child: CustomTextFormField(
//                                   hintText: widget.bancaModel!
//                                       .horarioAbertura,
//                                   keyboardType:
//                                       TextInputType.number,
//                                   maskFormatter: controller
//                                       .timeFormatter,
//                                   icon: Icons.alarm_on,
//                                   controller: controller
//                                       .horarioAberturaController,
//                                 ),
//                               ),*/
//                   Divider(
//                     height: size.height * 0.006,
//                     color: Colors.transparent,
//                   ),
//                   SizedBox(
//                     height: size.height * 0.05,
//                     width: size.width * 0.25,
//                     child: Card(
//                       margin: EdgeInsets.zero,
//                       elevation: 0,
//                       child: ClipPath(
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             border: Border(
//                                 bottom: BorderSide(
//                                     color: Colors.black, width: 1)),
//                           ),
//                           alignment: Alignment.center,
//                           child: Expanded(
//                             child: CustomTextFormField(
//                               hintText: '06:35',
//                               keyboardType: TextInputType.number,
//                               maskFormatter:
//                               widget.controller.timeFormatter,
//                               controller: widget.controller
//                                   .horarioAberturaController,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               const VerticalSpacerBox(size: SpacerSize.small),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Fechamento',
//                     style: TextStyle(
//                         color: kSecondaryColor,
//                         fontWeight: FontWeight.w500,
//                         fontSize: size.height * 0.016),
//                   ),
//                   /*Expanded(
//                                 child: CustomTextFormField(
//                                   hintText: widget.bancaModel!
//                                       .horarioAbertura,
//                                   keyboardType:
//                                       TextInputType.number,
//                                   maskFormatter: controller
//                                       .timeFormatter,
//                                   icon: Icons.alarm_on,
//                                   controller: controller
//                                       .horarioAberturaController,
//                                 ),
//                               ),*/
//                   Divider(
//                     height: size.height * 0.006,
//                     color: Colors.transparent,
//                   ),
//                   SizedBox(
//                     height: size.height * 0.05,
//                     width: size.width * 0.25,
//                     child: Card(
//                       margin: EdgeInsets.zero,
//                       elevation: 0,
//                       child: ClipPath(
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             border: Border(
//                                 bottom: BorderSide(
//                                     color: Colors.black, width: 1)),
//                           ),
//                           alignment: Alignment.center,
//                           child: Expanded(
//                             child: CustomTextFormField(
//                               hintText: '23:59',
//                               keyboardType: TextInputType.number,
//                               maskFormatter:
//                               widget.controller.timeFormatter,
//                               controller: widget.controller
//                                   .horarioFechamentoController,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Divider(
//           height: size.height * 0.018,
//           color: Colors.transparent,
//         ),
//         Text('Formas de Pagamento',
//             style: kTitle1.copyWith(
//                 fontWeight: FontWeight.w500,
//                 fontSize: size.height * 0.018,
//                 color: kSecondaryColor)),
//         SizedBox(
//           width: size.width,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Flexible(
//                 child: CheckboxListTile(
//                   contentPadding: EdgeInsetsDirectional.zero,
//                   activeColor: kPrimaryColor,
//                   value: widget.controller.isSelected[0],
//                   title: Text(
//                     widget.controller.checkItems[0],
//                     style: TextStyle(fontSize: size.height * 0.018),
//                   ),
//                   checkboxShape: const CircleBorder(),
//                   controlAffinity: ListTileControlAffinity.leading,
//                   onChanged: (value) => widget.controller.onItemTapped(0),
//                 ),
//               ),
//               Flexible(
//                 child: CheckboxListTile(
//                   activeColor: kPrimaryColor,
//                   value: widget.controller.isSelected[1],
//                   title: Text(
//                     widget.controller.checkItems[1],
//                     style: TextStyle(fontSize: size.height * 0.018),
//                   ),
//                   checkboxShape: const CircleBorder(),
//                   controlAffinity: ListTileControlAffinity.leading,
//                   onChanged: (value) => widget.controller.onItemTapped(1),
//                 ),
//               ),
//               Flexible(
//                 child: CheckboxListTile(
//                   contentPadding: EdgeInsetsDirectional.zero,
//                   activeColor: kPrimaryColor,
//                   value: widget.controller.isSelected[2],
//                   title: Text(
//                     widget.controller.checkItems[2],
//                     style: TextStyle(fontSize: size.height * 0.018),
//                   ),
//                   checkboxShape: const CircleBorder(),
//                   controlAffinity: ListTileControlAffinity.leading,
//                   onChanged: (value) => widget.controller.onItemTapped(2),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         CheckboxListTile(
//             contentPadding:
//             const EdgeInsetsDirectional.only(start: 0),
//             title: Text('Realiza Entrega?',
//                 style: kTitle1.copyWith(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: kSecondaryColor)),
//             value: widget.controller.deliver,
//             checkboxShape: const CircleBorder(),
//             onChanged: (bool? value) {
//               widget.controller.setDeliver(value!);
//             }),
//         Divider(
//           height: size.height * 0.005,
//           color: Colors.transparent,
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Valor',
//                 style: kTitle1.copyWith(
//                     fontWeight: FontWeight.w500,
//                     fontSize: size.height * 0.014,
//                     color: kTextButtonColor)),
//             SizedBox(
//               height: size.height * 0.05,
//               width: size.width * 0.25,
//               child: Card(
//                 margin: EdgeInsets.zero,
//                 elevation: 0,
//                 child: ClipPath(
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(
//                               color: Colors.black, width: 1)),
//                     ),
//                     alignment: Alignment.center,
//                     child: Expanded(
//                       child: CustomTextFormField(
//                         hintText:
//                         'R\$ 0,00',
//                         controller: widget.controller.quantiaMinController,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
