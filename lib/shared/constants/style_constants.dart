///This file should contain all the constants style used in the app
///like texts, fonts, colors, etc.
///you should use the standard naming convention for constants like the following:

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//**FONT CONFIGURATION*/
final kDefaultFontFamily = GoogleFonts.nunito().fontFamily;
const double kDefaultFontSize = 18;
const double kDefaultPaddingCardPedido = 17.0;
final kSecondaryFontFamily =
    GoogleFonts.nunito().fontFamily;
final kDescriptionFontFamily =
    GoogleFonts.firaSans().fontFamily;
//**LIGHT COLORS */

const Color kPrimaryColor = Color(0xFF008000);
const Color kBackgroundColor = Colors.white;
const Color kSecondaryColor = Color(0xFF435969);
const Color kDetailColor = Color(0xFF008000);
const Color kOnBackgroundColor = Color(0xFF212931);
const Color kTextColor = Colors.white;
const Color kOnSurfaceColor = Colors.white;
const Color kTextButtonColor = Colors.grey;
//**LIGHT COLORS */

//**DARK COLORS */
const Color kPrimaryDarkColor = Color(0xFF303841);
const Color kSecondaryDarkColor = Color(0xFF3A4750);
const Color kDarkTextColor = Color(0xFF212931);
//**DARK COLORS */

//*GENERAL COLORS*//
const Color kSuccessColor = Colors.green;
const Color kErrorColor = Colors.redAccent;
const Color kAlertColor = Colors.orangeAccent;
//*GENERAL COLORS*//

//**TEXT STYLES */
const TextStyle kTitle1 = TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.w500,
    color: kSecondaryColor);
const TextStyle kTitle2 = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.w500,
);
const TextStyle kBody1 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w500,
);
const TextStyle kBody2 =
    TextStyle(fontSize: 22, fontWeight: FontWeight.w500);
const TextStyle kBody3 = TextStyle(
  fontSize: 20,
);
const TextStyle kCaption1 = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
);
const TextStyle kCaption2 = TextStyle(
  fontSize: 18,
);
