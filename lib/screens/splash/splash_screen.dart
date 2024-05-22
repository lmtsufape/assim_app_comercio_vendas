import 'package:flutter/material.dart';

import 'package:thunderapp/components/utils/vertical_spacer_box.dart';

import 'package:thunderapp/screens/splash/splash_screen_controller.dart';
import 'package:thunderapp/shared/constants/app_enums.dart';

import 'package:thunderapp/shared/constants/app_number_constants.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final SplashScreenController _controller;
  late final AnimationController animController;
  double opacity = 0;
  @override
  void initState() {
    super.initState();
    animController = AnimationController(
        vsync: this, duration: const Duration(seconds: 2));
    _controller = SplashScreenController(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setController();
      stopController();
      _controller.initApplication(() {});
    });
  }

  void setController() async {
    await animController.repeat();
  }

  void stopController() async {
    Future.delayed(const Duration(milliseconds: 200), () {
     
      setState(() {
        opacity = 1;
      });
      animController.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //         onPressed: () async {
      //           animController.repeat();
      //           stopController();
      //         },
      //         icon: Icon(Icons.add))
      //   ],
      // ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(kDefaultPadding),
            margin: const EdgeInsets.only(bottom: 128),
            decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(60)),
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Lottie.asset(
                //     width: 220,
                //     height: 220,
                //     controller: animController,
                //     Assets.introLottie,
                //     fit: BoxFit.fill),
                AnimatedOpacity(
                  duration:
                      const Duration(milliseconds: 200),
                  opacity: opacity,
                  child: Text(
                    'ASSIM Vendedor'
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    style: kTitle1.copyWith(
                        color: kOnSurfaceColor, fontSize: size.height * 0.038),
                  ),
                ),
                const VerticalSpacerBox(
                    size: SpacerSize.huge),
                const CircularProgressIndicator(
                  color: Colors.white,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'LMTS - Laboratório Multidisciplinar de Tecnologias Sociais',
                textAlign: TextAlign.center,
                style:
                    kBody2.copyWith(fontFamily: 'Roboto', fontSize: size.height * 0.022),
              ),
            ),
          )
        ],
      ),
    );
  }
}