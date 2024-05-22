import 'package:flutter/material.dart';

import '../../../shared/constants/style_constants.dart';

class ItemCardHolder extends StatelessWidget {
  const ItemCardHolder({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.sizeIcon,
    required this.sizeText,
  }) : super(key: key);
  final String title;
  final IconData icon;
  final Function()? onTap;
  final double sizeIcon;
  final double sizeText;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            Icon(
              icon,
              size: sizeIcon,
              color: kPrimaryColor,
            ),
            Divider(
              height: size.height * 0.001,
              color: Colors.transparent,
            ),
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: sizeText),
            )
          ],
        ),
      ),
    );
  }
}
