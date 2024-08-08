import 'package:flutter/material.dart';
import 'package:thunderapp/screens/my_store/my_store_controller.dart';

import '../../../components/utils/horizontal_spacer_box.dart';
import '../../../shared/constants/app_enums.dart';
import '../../../shared/constants/style_constants.dart';

// ignore: must_be_immutable
class CircleImageProfile extends StatefulWidget {
  late MyStoreController controller;

  CircleImageProfile(this.controller, {super.key});

  @override
  State<CircleImageProfile> createState() =>
      _CircleImageProfileState();
}

class _CircleImageProfileState
    extends State<CircleImageProfile> {
  @override
  Widget build(BuildContext context) {
    final heightScreen = MediaQuery.of(context).size.height;
    final widthScreen = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 15),
      child: SizedBox(
        width: widthScreen * 0.24,
        height: heightScreen * 0.12,
        child: FloatingActionButton(
            heroTag: 'Photo',
            backgroundColor: kBackgroundColor,
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: ((builder) =>
                      bottomSheet(widget.controller)));
            },
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: CircleAvatar(
                radius: 65,
                backgroundColor: kBackgroundColor,
                backgroundImage: widget
                            .controller.selectedImage !=
                        null
                    ? FileImage(
                        widget.controller.selectedImage!)
                    : null,
                child: widget.controller.selectedImage ==
                        null
                    ? const Icon(
                        Icons.person_outline,
                        color: kSecondaryColor,
                        size: 50,
                      )
                    : null)),
      ),
    );
  }
}

Widget bottomSheet(MyStoreController controller) {
  MyStoreController controller0 = controller;
  return Container(
    height: 130.0,
    width: 500,

    margin: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 20,
    ),
    child: Column(
      children: <Widget>[
        const Text(
          "Escolha a foto da banca",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 23),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                    icon: const Icon(Icons.camera, size: 30,),
                    onPressed: () {
                      controller0.selectImageCam();
                    },
                    label: const Text("Camera", style: TextStyle(fontSize: 23),),
                  ),
                
                const HorizontalSpacerBox(
                    size: SpacerSize.small),
                ElevatedButton.icon(
                  icon: const Icon(Icons.image, size: 30,),
                  onPressed: () {
                    controller0.selectImage();
                  },
                  label: const Text("Gallery", style: TextStyle(fontSize: 23),),
                ),
              ]),
        )
      ],
    ),
  );
}
