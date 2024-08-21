import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thunderapp/components/forms/custom_text_form_field.dart';
import 'package:thunderapp/components/utils/vertical_spacer_box.dart';
import 'package:thunderapp/screens/signin/sign_in_controller.dart';
import 'package:thunderapp/shared/components/bottomLogos/bottom_logos.dart';
import 'package:thunderapp/shared/components/header_start_app/header_start_app.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';
import '../../shared/constants/app_enums.dart';
import '../../shared/constants/app_number_constants.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => SignInController()),
      ],
      builder: (context, child) {
        return Consumer<SignInController>(
          builder: (context, controller, child) =>
              GestureDetector(
            onTap: () {
              FocusScope.of(context)
                  .requestFocus(FocusNode());
            },
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF008000),
                    Color(0xFF63A355),
                  ],
                ),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    double height = constraints.maxHeight;
                    double width = constraints.maxWidth;

                    return CustomScrollView(
                      reverse: true,
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Form(
                            key: controller.formKey,
                            child: Stack(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                      top: 30),
                                  child: HeaderStartApp(),
                                ),
                                SizedBox(
                                  height: height * 0.97,
                                ),
                                Align(
                                  alignment: Alignment
                                      .bottomCenter,
                                  child: Container(
                                    width: width,
                                    height: height * 0.6,
                                    margin: EdgeInsets.only(
                                        top: height * 0.03),
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                            horizontal:
                                                28.0,
                                            vertical: 30.0),
                                    decoration:
                                        const BoxDecoration(
                                      color:
                                          kBackgroundColor,
                                      borderRadius:
                                          BorderRadius.only(
                                        topLeft:
                                            Radius.circular(
                                                40),
                                        topRight:
                                            Radius.circular(
                                                40),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Text(
                                          'E-mail',
                                          style: TextStyle(
                                            color:
                                                kSecondaryColor,
                                            fontWeight:
                                                FontWeight
                                                    .w700,
                                            fontSize:
                                                height *
                                                    0.018,
                                          ),
                                        ),
                                        Card(
                                          margin: EdgeInsets
                                              .zero,
                                          elevation: 0,
                                          child:
                                              CustomTextFormField(
                                            erroStyle:
                                                const TextStyle(
                                                    fontSize:
                                                        12),
                                            validatorError:
                                                (value) {
                                              if (value
                                                  .isEmpty) {
                                                return 'Obrigatório';
                                              } else if (value
                                                  .contains(
                                                      ' ')) {
                                                return "Digite um e-mail válido";
                                              } else if (!value
                                                  .contains(
                                                      '@')) {
                                                return "Digite um e-mail válido";
                                              }
                                              return null;
                                            },
                                            controller:
                                                controller
                                                    .emailController,
                                          ),
                                        ),
                                        const VerticalSpacerBox(
                                            size: SpacerSize
                                                .small),
                                        Text(
                                          'Senha',
                                          style: TextStyle(
                                            color:
                                                kSecondaryColor,
                                            fontWeight:
                                                FontWeight
                                                    .w700,
                                            fontSize:
                                                height *
                                                    0.018,
                                          ),
                                        ),
                                        Card(
                                          margin: EdgeInsets
                                              .zero,
                                          elevation: 0,
                                          child:
                                              CustomTextFormField(
                                            erroStyle:
                                                const TextStyle(
                                                    fontSize:
                                                        12),
                                            validatorError:
                                                (value) {
                                              if (value
                                                  .isEmpty) {
                                                return 'Obrigatório';
                                              }
                                              return null;
                                            },
                                            controller:
                                                controller
                                                    .passwordController,
                                            isPassword:
                                                true,
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              height * 0.04,
                                        ),
                                        controller.status ==
                                                SignInStatus
                                                    .loading
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : SizedBox(
                                                width:
                                                    width,
                                                height:
                                                    height *
                                                        0.06,
                                                child:
                                                    ElevatedButton(
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    backgroundColor:
                                                        kPrimaryColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(kDefaultBorderRadius),
                                                    ),
                                                  ),
                                                  onPressed:
                                                      () {
                                                    final isValidForm = controller
                                                        .formKey
                                                        .currentState!
                                                        .validate();
                                                    if (isValidForm) {
                                                      controller
                                                          .signIn(context);
                                                    }
                                                  },
                                                  child:
                                                      FittedBox(
                                                    fit: BoxFit
                                                        .scaleDown,
                                                    child:
                                                        Text(
                                                      'Entrar',
                                                      style:
                                                          kBody2.copyWith(color: kTextColor),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: BottomLogos(150),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
