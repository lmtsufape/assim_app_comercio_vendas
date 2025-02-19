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
        ChangeNotifierProvider(create: (_) => SignInController()),
      ],
      builder: (context, child) {
        return Consumer<SignInController>(
          builder: (context, controller, child) => GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
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
                    final height = constraints.maxHeight;
                    final width = constraints.maxWidth;

                    return Stack(
                      children: [
                        // Header
                        const Positioned(
                          top: 30,
                          left: 0,
                          right: 0,
                          child: HeaderStartApp(),
                        ),
                        
                        // Form Container
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            width: width,
                            height: height * 0.65, // Ajustado para acomodar o BottomLogos
                            decoration: const BoxDecoration(
                              color: kBackgroundColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                            ),
                            child: Form(
                              key: controller.formKey,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(28.0, 30.0, 28.0, 80.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Email Field
                                    Text(
                                      'E-mail',
                                      style: TextStyle(
                                        color: kSecondaryColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: height * 0.018,
                                      ),
                                    ),
                                    CustomTextFormField(
                                      erroStyle: const TextStyle(fontSize: 12),
                                      validatorError: (value) {
                                        if (value.isEmpty) return 'Obrigatório';
                                        if (value.contains(' ')) return "Digite um e-mail válido";
                                        if (!value.contains('@')) return "Digite um e-mail válido";
                                        return null;
                                      },
                                      controller: controller.emailController,
                                    ),
                                    
                                    const VerticalSpacerBox(size: SpacerSize.small),
                                    
                                    // Password Field
                                    Text(
                                      'Senha',
                                      style: TextStyle(
                                        color: kSecondaryColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: height * 0.018,
                                      ),
                                    ),
                                    CustomTextFormField(
                                      erroStyle: const TextStyle(fontSize: 12),
                                      validatorError: (value) {
                                        if (value.isEmpty) return 'Obrigatório';
                                        return null;
                                      },
                                      controller: controller.passwordController,
                                      isPassword: true,
                                    ),
                                    
                                    SizedBox(height: height * 0.04),
                                    
                                    // Login Button
                                    if (controller.status == SignInStatus.loading)
                                      const Center(child: CircularProgressIndicator())
                                    else
                                      SizedBox(
                                        width: width,
                                        height: height * 0.06,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kPrimaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                                            ),
                                          ),
                                          onPressed: () {
                                            final isValidForm = controller.formKey.currentState!.validate();
                                            if (isValidForm) {
                                              controller.signIn(context);
                                            }
                                          },
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              'Entrar',
                                              style: kBody2.copyWith(color: kTextColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        // Bottom Logos
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: BottomLogos(150),
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