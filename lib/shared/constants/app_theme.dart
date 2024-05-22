import 'package:flutter/material.dart';
import 'package:thunderapp/shared/constants/app_enums.dart';

import 'package:thunderapp/shared/constants/style_constants.dart' as style_constants;

class AppTheme with ChangeNotifier {
  CurrentAppTheme _currentAppTheme = CurrentAppTheme.light;
  CurrentAppTheme get currentAppTheme => _currentAppTheme;
  ThemeData getCurrentTheme(BuildContext context) {
    if (_currentAppTheme == CurrentAppTheme.light) {
      return getLightTheme(context);
    } else {
      return getDarkTheme(context);
    }
  }

  void toggleAppTheme() {
    if (_currentAppTheme == CurrentAppTheme.light) {
      _currentAppTheme = CurrentAppTheme.dark;
      notifyListeners();
    } else {
      _currentAppTheme = CurrentAppTheme.light;
      notifyListeners();
    }
  }

  static ThemeData getLightTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: style_constants.kBackgroundColor,
      useMaterial3: true,
      // fontFamily: kDefaultFontFamily,
      textTheme: TextTheme(
        titleMedium: style_constants.kBody3.copyWith(
            color: style_constants.kDarkTextColor,
            fontSize: kDefaultFontSize),
        titleLarge: style_constants.kBody3.copyWith(
            color: style_constants.kDarkTextColor,
            fontSize: kDefaultFontSize),
        bodySmall: style_constants.kBody2.copyWith(
            color: style_constants.kDarkTextColor,
            fontSize: kDefaultFontSize),
        bodyLarge: style_constants.kBody3.copyWith(
            color: style_constants.kDarkTextColor,
            fontSize: kDefaultFontSize),
        bodyMedium: style_constants.kBody3.copyWith(
            color: style_constants.kDarkTextColor,
            fontSize: kDefaultFontSize),
        headlineSmall: style_constants.kBody3.copyWith(
            color: style_constants.kDarkTextColor,
            fontSize: kDefaultFontSize),
        headlineMedium: style_constants.kBody3.copyWith(
            color: style_constants.kDarkTextColor,
            fontSize: kDefaultFontSize),
        headlineLarge: style_constants.kBody3.copyWith(
            color: style_constants.kDarkTextColor,
            fontSize: kDefaultFontSize),
      ),
      indicatorColor: style_constants.kPrimaryColor,
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(
              color: style_constants.kPrimaryColor),
      inputDecorationTheme: const InputDecorationTheme(
          hintStyle: style_constants.kCaption2,
          labelStyle: style_constants.kCaption2,
          counterStyle: style_constants.kCaption2,),
      appBarTheme: AppBarTheme.of(context).copyWith(
          iconTheme:
              const IconThemeData(color: style_constants.kDetailColor),
          elevation: 0,
          backgroundColor: Colors.transparent),
    );
  }

  static ThemeData getDarkTheme(BuildContext context) {
    return ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: style_constants.kPrimaryDarkColor,
        cardColor: style_constants.kSecondaryDarkColor,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            titleTextStyle: style_constants.kBody1,
            surfaceTintColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.white)),
        inputDecorationTheme: const InputDecorationTheme(
            hintStyle: style_constants.kCaption2),
        textTheme: TextTheme(
          titleMedium:
              style_constants.kBody3.copyWith(color: style_constants.kDarkTextColor),
          titleLarge:
              style_constants.kBody3.copyWith(color: style_constants.kDarkTextColor),
          bodySmall: style_constants.kBody2.copyWith(color: style_constants.kDarkTextColor),
          bodyLarge: style_constants.kBody3.copyWith(color: style_constants.kDarkTextColor),
          bodyMedium:
              style_constants.kBody3.copyWith(color: style_constants.kDarkTextColor),
          headlineSmall:
              style_constants.kBody3.copyWith(color: style_constants.kDarkTextColor),
          headlineMedium:
              style_constants.kBody3.copyWith(color: style_constants.kDarkTextColor),
          headlineLarge:
              style_constants.kBody3.copyWith(color: style_constants.kDarkTextColor),
        ));
  }
}
