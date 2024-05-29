import 'package:flutter/material.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';
import 'package:thunderapp/shared/core/navigator.dart';

class DefaultAlertDialog extends StatelessWidget {
  const DefaultAlertDialog({Key? key, required this.title, required this.body, required this.cancelText, required this.onConfirm, required this.confirmText, required this.confirmColor, required this.cancelColor}) : super(key: key);

  final String title;
  final String body;
  final String cancelText;
  final String confirmText;
  final VoidCallback onConfirm;
  final Color confirmColor;
  final Color cancelColor;

  @override
  Widget build(BuildContext context) {

    ButtonStyle styleConfirm = ElevatedButton.styleFrom(
      backgroundColor: confirmColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    );

   ButtonStyle styleCancel = ElevatedButton.styleFrom(
      backgroundColor: cancelColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    );

    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.3,
      child: AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        insetPadding:
        const EdgeInsets.symmetric(horizontal: 15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        title: Center(
          child: Text(
            title,
            style: kBody2,
          ),
        ),
        content: Text(
          body,
          style: kCaption2,
        ),
        actions:<Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    right: 28, bottom: 4),
                child: SizedBox(
                  width: size.width * 0.3,
                  height: size.height * 0.040,
                  child: ElevatedButton(
                    style: styleConfirm,
                    onPressed: onConfirm,
                    child: Text(
                      confirmText,
                      style: TextStyle(
                          color: kTextColor,
                          fontSize: size.height * 0.018,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SizedBox(
                  width: size.width * 0.3,
                  height: size.height * 0.040,
                  child: ElevatedButton(
                    style: styleCancel,
                    onPressed: (() => navigatorKey.currentState!.pop()),
                    child: Text(
                      cancelText,
                      style: TextStyle(
                          color: kTextColor,
                          fontSize: size.height * 0.018,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DefaultAlertDialogOneButton extends StatelessWidget {
  const DefaultAlertDialogOneButton({Key? key, required this.title, required this.body, required this.onConfirm, required this.confirmText, required this.buttonColor}) : super(key: key);

  final String title;
  final String body;
  final String confirmText;
  final VoidCallback onConfirm;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {

    ButtonStyle styleConfirm = ElevatedButton.styleFrom(
      backgroundColor: buttonColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    );

    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.3,
      child: AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        insetPadding:
        const EdgeInsets.symmetric(horizontal: 15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        title: Center(
          child: Text(
            title,
            style: kBody2,
          ),
        ),
        content: Container(
          alignment: Alignment.center,
          height: size.height * 0.1,
          padding: const EdgeInsetsDirectional.only(start: 8),
          child: Text(
            body,
            style: kCaption2,
          ),
        ),
        actions:<Widget>[
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: SizedBox(
                width: size.width * 0.3,
                height: size.height * 0.040,
                child: ElevatedButton(
                  style: styleConfirm,
                  onPressed: onConfirm,
                  child: Text(
                    confirmText,
                    style: TextStyle(
                        color: kTextColor,
                        fontSize: size.height * 0.018,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AlertDialogComprovante extends StatelessWidget {
  const AlertDialogComprovante({Key? key, required this.title, required this.body, required this.viewText, required this.view, required this.download, required this.downloadText, required this.viewColor, required this.downloadColor}) : super(key: key);

  final String title;
  final String body;
  final String viewText;
  final String downloadText;
  final VoidCallback view;
  final VoidCallback download;
  final Color viewColor;
  final Color downloadColor;

  @override
  Widget build(BuildContext context) {

    ButtonStyle styleConfirm = ElevatedButton.styleFrom(
      backgroundColor: viewColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    );

    ButtonStyle styleCancel = ElevatedButton.styleFrom(
      backgroundColor: downloadColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    );

    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.3,
      child: AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        insetPadding:
        const EdgeInsets.symmetric(horizontal: 15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        title: Center(
          child: Text(
            title,
            style: kBody2,
          ),
        ),
        content: Text(
          body,
          style: kCaption2,
        ),
        actions:<Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    right: 28, bottom: 4),
                child: SizedBox(
                  width: size.width * 0.3,
                  height: size.height * 0.040,
                  child: ElevatedButton(
                    style: styleConfirm,
                    onPressed: view,
                    child: Text(
                      viewText,
                      style: TextStyle(
                          color: kTextColor,
                          fontSize: size.height * 0.018,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SizedBox(
                  width: size.width * 0.3,
                  height: size.height * 0.040,
                  child: ElevatedButton(
                    style: styleCancel,
                    onPressed: download,
                    child: Text(
                      downloadText,
                      style: TextStyle(
                          color: kTextColor,
                          fontSize: size.height * 0.018,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}