import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thunderapp/screens/carrousel/carrousel_screen.dart';
import 'package:thunderapp/screens/edit_products/edit_products_screen.dart';
import 'package:thunderapp/screens/list_products/list_products_screen.dart';
import 'package:thunderapp/screens/orders/orders_screen.dart';
import 'package:thunderapp/screens/payments/payments_screen.dart';
import 'package:thunderapp/screens/add_products/add_products_screen.dart';
import 'package:thunderapp/screens/report/report_screen.dart';
import 'package:thunderapp/screens/screens_index.dart';
import 'package:thunderapp/screens/start/start_screen.dart';
import 'package:thunderapp/shared/constants/app_theme.dart';
import 'package:thunderapp/shared/core/navigator.dart';
import 'screens/home/home_screen.dart';
import 'screens/my store/add_store_screen.dart';
import 'screens/signin/sign_in_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowMaterialGrid: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('pt, BR')
      ],
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      navigatorKey: navigatorKey,
      builder: (context, widget) {
        return DevicePreview.appBuilder(
          context,
          widget!,
        );
      },
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: AppTheme().getCurrentTheme(context),
      routes: {
        Screens.splash: (BuildContext context) =>
            const SplashScreen(),
        Screens.carrousel: (BuildContext context) =>
            const CarrouselScreen(),
        Screens.start: (context) => const StartScreen(),
        Screens.home: (BuildContext context) =>
            const HomeScreen(),
        Screens.signin: (BuildContext context) =>
            const SignInScreen(),
        Screens.addStore: (BuildContext context) =>
            const AddStoreScreen(),
        Screens.orders: (BuildContext context) =>
            const OrdersScreen(),
        //Screens.orderDetail: (BuildContext context) =>
        // OrderDetailScreen(),
        Screens.payments: (context) =>
            const PaymentsScreen(),
        Screens.report: (context) => const ReportScreen(),
        Screens.listProducts: (context) =>
            ListProductsScreen(),
      },
    );
  }
}
