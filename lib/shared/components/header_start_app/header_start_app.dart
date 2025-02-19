import 'package:flutter/material.dart';
import 'package:thunderapp/assets/index.dart';
import 'package:thunderapp/components/utils/vertical_spacer_box.dart';
import 'package:thunderapp/shared/constants/app_enums.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';

class HeaderStartApp extends StatelessWidget {
  const HeaderStartApp({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            Assets.logo,
            width: 160,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Column(
          children: [
            Text(
              'ASSIM AGROECOLÓGICA',
              textAlign: TextAlign.center,
              style: kTitle1.copyWith(
                  color: kOnSurfaceColor,
                  fontSize: size.height * 0.030),
            ),
            Text(
              '(aplicativo vendedor/a)',
              textAlign: TextAlign.center,
              style: kTitle1.copyWith(
                  color: kOnSurfaceColor,
                  fontSize: size.height * 0.019),
            ),
          ],
        ),
        const VerticalSpacerBox(size: SpacerSize.huge),
      ],
    );
  }
}
