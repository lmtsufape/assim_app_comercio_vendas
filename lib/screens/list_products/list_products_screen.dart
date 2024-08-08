// import 'package:flutter/material.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';
// import 'package:thunderapp/screens/add_products/add_products_screen.dart';
// import 'package:thunderapp/screens/list_products/components/total_infos.dart';
// import '../../shared/constants/style_constants.dart';
// import 'list_products_controller.dart';
//
// class ListProductsScreen extends StatelessWidget {
//   const ListProductsScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return GetBuilder<ListProductsController>(
//       init: ListProductsController(),
//       builder: (controller) => Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: kPrimaryColor,
//           title: Center(
//             child: Text(
//               'Produtos',
//               style: kTitle2.copyWith(color: Colors.white),
//             ),
//           ),
//           iconTheme:
//               const IconThemeData(color: Colors.white),
//         ),
//         floatingActionButton: SizedBox(
//           // height: size.height * 0.085,
//           // width: size.width * 0.17,
//           child: FloatingActionButton(
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (_) => const AddProductsScreen()));
//             },
//             backgroundColor: kPrimaryColor,
//             heroTag: 'AddListProduct',
//             shape: const RoundedRectangleBorder(
//                 borderRadius:
//                     BorderRadius.all(Radius.circular(100))),
//             child: Icon(Icons.add,
//                 size: size.height * 0.06,
//                 color: Colors.white),
//           ),
//         ),
//         body: Container(
//           width: size.width,
//           height: size.height,
//           padding: const EdgeInsets.all(26),
//           child: ListView(
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Quantidade disponível',
//                     style: TextStyle(
//                       fontSize: size.height * 0.02,
//                       fontWeight: FontWeight.w700,
//                       color: kSecondaryColor,
//                     ),
//                   ),
//                   Divider(
//                     height: size.height * 0.014,
//                     color: Colors.transparent,
//                   ),
//                   TotalInfos(controller),
//                   Divider(
//                     height: size.height * 0.04,
//                     color: Colors.transparent,
//                   ),
//                   Text(
//                     'Produtos',
//                     style: TextStyle(
//                       fontSize: size.height * 0.02,
//                       fontWeight: FontWeight.w700,
//                       color: kSecondaryColor,
//                     ),
//                   ),
//                   Divider(
//                     height: size.height * 0.014,
//                     color: Colors.transparent,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                         children: controller.products
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thunderapp/screens/add_products/add_products_screen.dart';
import 'package:thunderapp/screens/list_products/components/total_infos.dart';
import '../../shared/constants/style_constants.dart';
import 'list_products_controller.dart';

class ListProductsScreen extends StatefulWidget {
  const ListProductsScreen({super.key});

  @override
  State<ListProductsScreen> createState() => _ListProductsScreenState();
}

class _ListProductsScreenState extends State<ListProductsScreen>
    with WidgetsBindingObserver {
  late ListProductsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ListProductsController());
    controller.fetchProducts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<ListProductsController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          title: Center(
            child: Text(
              'Produtos',
              style: kTitle2.copyWith(color: Colors.white),
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        floatingActionButton: SizedBox(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AddProductsScreen())).then((_) {
                controller.fetchProducts();
              });
            },
            backgroundColor: kPrimaryColor,
            heroTag: 'AddListProduct',
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child:
            Icon(Icons.add, size: size.height * 0.06, color: Colors.white),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => controller.populateCardsProductsList(),
          child: Container(
            width: size.width,
            height: size.height,
            padding: const EdgeInsets.all(26),
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantidade disponível',
                      style: TextStyle(
                        fontSize: size.height * 0.02,
                        fontWeight: FontWeight.w700,
                        color: kSecondaryColor,
                      ),
                    ),
                    Divider(
                      height: size.height * 0.014,
                      color: Colors.transparent,
                    ),
                    TotalInfos(controller),
                    Divider(
                      height: size.height * 0.04,
                      color: Colors.transparent,
                    ),
                    Text(
                      'Produtos',
                      style: TextStyle(
                        fontSize: size.height * 0.02,
                        fontWeight: FontWeight.w700,
                        color: kSecondaryColor,
                      ),
                    ),
                    Divider(
                      height: size.height * 0.014,
                      color: Colors.transparent,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: controller.products,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
