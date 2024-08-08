import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thunderapp/assets/index.dart';
import 'package:thunderapp/components/utils/vertical_spacer_box.dart';
import 'package:thunderapp/screens/screens_index.dart';
import 'package:thunderapp/screens/signin/sign_in_controller.dart';
import 'package:thunderapp/screens/start/start_controller.dart';
import 'package:thunderapp/shared/components/bottomLogos/bottom_logos.dart';
import 'package:thunderapp/shared/components/header_start_app/header_start_app.dart';
import 'package:thunderapp/shared/constants/app_number_constants.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';
import 'package:thunderapp/shared/core/navigator.dart';
import '../../shared/constants/app_enums.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              child: const HeaderStartApp(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                const EdgeInsets.all(kDefaultPadding),
                width: size.width,
                height: size.height * 0.6,
                decoration: const BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.zero,
                  ),
                ),
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Para começar, que tal entrar na sua conta?',
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400, color: Color.fromARGB(255, 74, 74, 74)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 80,),
                    SignInController().status ==
                        SignInStatus.loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(
                              315, 50),
                          backgroundColor:
                          kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                                8.0),
                          ),
                        ),
                        child: Padding(
                          padding:
                          const EdgeInsets.all(2.0),
                          child: Text('Continuar como ${controller.userName}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 14,fontWeight: FontWeight.bold,
                                color: kTextColor),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                        onPressed: () => controller
                            .startVeri(context)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            fixedSize: const Size(
                                315, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                  8.0),
                            ),
                            side: const BorderSide(
                                color: kPrimaryColor),
                          ),
                          child: Text(
                            'Não sou ${controller.userName}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 14,
                                color: kPrimaryColor, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                                context,
                                Screens.signin
                            );
                          },
                        ),
                        const SizedBox(height: 180,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BottomLogos(150)
          ],
        ),
      ),
    );
  }
}
