import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thunderapp/components/buttons/custom_text_button.dart';
import 'package:thunderapp/components/buttons/primary_button.dart';
import 'package:thunderapp/components/buttons/secondary_button.dart';

import 'package:thunderapp/components/utils/vertical_spacer_box.dart';
import 'package:thunderapp/screens/screens_index.dart';
import 'package:thunderapp/screens/signin/sign_in_controller.dart';
import 'package:thunderapp/screens/start/start_controller.dart';
import 'package:thunderapp/shared/constants/app_number_constants.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';
import 'package:thunderapp/shared/core/navigator.dart';

import '../../shared/constants/app_enums.dart';

class StartScreen extends StatelessWidget {


  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /**Declare this variable to get the Media Query of the screen in the current context */
    Size size = MediaQuery.of(context).size;
    return GetBuilder<StartController>(
      init: StartController(),
      builder: (controller) => Scaffold(
        body: Stack(
          children: [
            Container(
              color: kPrimaryColor,
              width: size.width,
              padding:
                  const EdgeInsets.all(kDefaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, Seja bem vindo(a) ${controller.userName}',
                    textAlign: TextAlign.center,
                    style:
                        kTitle1.copyWith(color: kTextColor),
                  ),
                  SizedBox(
                    height: size.height * 0.3,
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    const EdgeInsets.all(kDefaultPadding),
                width: size.width,
                height: size.height * 0.5,
                decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius:
                        BorderRadius.circular(30)),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Para começar, que tal entrar na sua conta?',
                      style: kTitle2.copyWith(fontSize: size.height * 0.028),
                      textAlign: TextAlign.center,
                    ),
                    const VerticalSpacerBox(
                        size: SpacerSize.huge),
                    SignInController().status ==
                            SignInStatus.loading
                        ? const CircularProgressIndicator()
                        : PrimaryButton(
                            text:
                                'Continuar como ${controller.userName}',
                            onPressed: () => controller.StartVeri(context)),
                    SizedBox(
                      width: size.width,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.center,
                        children: <Widget>[
                          SignInController().errorMessage !=
                                  null
                              ? Text(
                                  SignInController()
                                      .errorMessage!,
                                  style: kCaption1,
                                )
                              : const SizedBox(),
                          const VerticalSpacerBox(
                              size: SpacerSize.small),
                          SecondaryButton(
                              text:
                                  'Não sou ${controller.userName}',
                              onPressed: () {
                                navigatorKey.currentState!
                                    .pushReplacementNamed(
                                        Screens.signin);
                              }),
                          const VerticalSpacerBox(
                              size: SpacerSize.small),
                        
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
