import 'package:flutter/material.dart';
import 'package:thunderapp/components/utils/vertical_spacer_box.dart';
import 'package:thunderapp/screens/splash/splash_screen_controller.dart';
import 'package:thunderapp/shared/components/bottomLogos/bottom_logos.dart';
import 'package:thunderapp/shared/components/header_start_app/header_start_app.dart';
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
    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        setController();
        stopController();
        _controller.initApplication(() {});
      },
    );
  }

  void setController() async {
    await animController.repeat();
  }

  void stopController() async {
    Future.delayed(
      const Duration(milliseconds: 200),
          () {
        setState(
              () {
            opacity = 1;
          },
        );
        animController.stop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(kDefaultPadding),
            margin: const EdgeInsets.only(bottom: 245),
            decoration: const BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.zero,
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            width: size.width,
            child:  Column(
              children: [
                SizedBox(height: size.height * 0.12,),
                const HeaderStartApp(),
                const VerticalSpacerBox(
                    size: SpacerSize.huge),
                const CircularProgressIndicator(
                  color: Colors.white,
                )
              ],
            ),


          ),
          BottomLogos(150),
        ],
      ),
    );
  }
}
