import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thunderapp/components/buttons/primary_button.dart';
import 'package:thunderapp/components/forms/custom_text_form_field.dart';
import 'package:thunderapp/components/utils/vertical_spacer_box.dart';
import 'package:thunderapp/screens/signin/sign_in_controller.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';

import '../../assets/index.dart';
import '../../shared/constants/app_enums.dart';
import '../../shared/constants/app_number_constants.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SignInController()),
        ],
        builder: (context, child) {
          return Consumer<SignInController>(
            builder: (context, controller, child) => GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFF008000),
                    Color(0xFF63A355),
                    //Colors.deepOrangeAccent,
                    //Colors.orangeAccent,
                  ]),
                ),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: CustomScrollView(
                    reverse: true,
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Form(
                          key: controller.formKey,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: size.width,
                                  height: size.height * 0.58,
                                  margin:
                                      EdgeInsets.only(top: size.height * 0.03),
                                  padding: const EdgeInsets.only(
                                      top: 30, left: 28, bottom: 0, right: 28),
                                  decoration: BoxDecoration(
                                      color: kBackgroundColor,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                          bottomLeft: Radius.zero,
                                          bottomRight: Radius.zero)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Center(
                                      //   child: Text(
                                      //     'Entrar',
                                      //     style: TextStyle(
                                      //         fontWeight: FontWeight.w700,
                                      //         fontSize: size.height * 0.032),
                                      //   ),
                                      // ),
                                      // Divider(
                                      //   height: size.height * 0.02,
                                      //   color: Colors.transparent,
                                      // ),
                                      Column(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'E-mail',
                                                style: TextStyle(
                                                    color: kSecondaryColor,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        size.height * 0.018),
                                              ),
                                              IntrinsicWidth(
                                                stepWidth: size.width,
                                                child: Card(
                                                  margin: EdgeInsets.zero,
                                                  elevation: 0,
                                                  child: ClipPath(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child:
                                                          CustomTextFormField(
                                                        erroStyle:
                                                            const TextStyle(
                                                                fontSize: 12),
                                                        validatorError:
                                                            (value) {
                                                          if (value.isEmpty) {
                                                            return 'Obrigatório';
                                                          } else if (value
                                                                  .contains(
                                                                      ' ') ==
                                                              true) {
                                                            return "Digite um e-mail válido";
                                                          } else if (value
                                                                  .contains(
                                                                      '@') ==
                                                              false) {
                                                            return "Digite um e-mail válido";
                                                          }
                                                        },
                                                        controller: controller
                                                            .emailController,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const VerticalSpacerBox(
                                              size: SpacerSize.small),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Senha',
                                                style: TextStyle(
                                                    color: kSecondaryColor,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        size.height * 0.018),
                                              ),
                                              IntrinsicWidth(
                                                stepWidth: size.width,
                                                child: Card(
                                                  margin: EdgeInsets.zero,
                                                  elevation: 0,
                                                  child: ClipPath(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child:
                                                          CustomTextFormField(
                                                        erroStyle:
                                                            const TextStyle(
                                                                fontSize: 12),
                                                        validatorError:
                                                            (value) {
                                                          if (value.isEmpty) {
                                                            return 'Obrigatório';
                                                          }
                                                        },
                                                        controller: controller
                                                            .passwordController,
                                                        isPassword: true,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Divider(
                                            height: size.height * 0.04,
                                            color: Colors.transparent,
                                          ),
                                          controller.status ==
                                                  SignInStatus.loading
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                          const Color(0XFF798E1E),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        kDefaultBorderRadius))),
                                                    onPressed: () {
                                                      final isValidForm =
                                                          controller.formKey
                                                              .currentState!
                                                              .validate();
                                                      if (isValidForm) {
                                                        controller
                                                            .signIn(context);
                                                      }
                                                    },
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        'Entrar',
                                                        style: kBody2.copyWith(
                                                            color: kTextColor),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                      Divider(
                                        height: size.height * 0.040,
                                        color: Colors.transparent,
                                      ),
                                      SizedBox(
                                        width: size.width,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Desenvolvido por',
                                              style: TextStyle(
                                                  fontSize: size.height * 0.018,
                                                  fontWeight: FontWeight.w700,
                                                  color: kSecondaryColor),
                                            ),
                                            Divider(
                                              height: size.height * 0.018,
                                              color: Colors.transparent,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  Assets.ufape,
                                                  height: size.height * 0.09,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8),
                                                  child: Image.asset(
                                                    Assets.lmts,
                                                    height: size.height * 0.06,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Divider(
                                    height: size.height * 0.085,
                                    color: Colors.transparent,
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          Assets.logo,
                                          width: size.width * 0.45,
                                        ),
                                        Divider(
                                            height: size.height * 0.007,
                                            color: Colors.transparent),
                                        Text(
                                          textAlign: TextAlign.center,
                                          'ASSIM',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: size.height * 0.032,
                                              color: kBackgroundColor),
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          '(aplicativo vendedor/a)',
                                          style: TextStyle(
                                            fontSize: size.height * 0.024,
                                            fontWeight: FontWeight.w500,
                                            color: kBackgroundColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.97,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
