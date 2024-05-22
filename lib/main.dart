import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:thunderapp/app.dart';
import 'dart:io';
import 'package:timezone/data/latest_all.dart' as tz;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ByteData data =
  await PlatformAssetBundle().load('lib/assets/images/ufape-edu-br.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(
      data.buffer.asUint8List());
  tz.initializeTimeZones();
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {});
  runApp(DevicePreview(
      enabled:
          defaultTargetPlatform == TargetPlatform.android
              ? false
              : true,
      builder: (context) => const App()));
}