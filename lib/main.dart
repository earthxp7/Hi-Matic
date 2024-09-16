import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:screen/screen/loadOrder_screen.dart';
import 'package:screen/screen/notAvailable_screen.dart';
import 'package:screen/timeControl/connect_internet.dart';
import 'api/Kios_API.dart';
import 'l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

int connect = 300;
final connectNetwork _connectNetwork =
    Get.put(connectNetwork(connect: connect));

Future main() async {
  
  await _connectNetwork.checkInternetConnection();
  WidgetsFlutterBinding.ensureInitialized();
  HttpClient httpClient = HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final dataKios _dataKios = Get.put(dataKios());
  String HeadTextError = "ขออภัยในความไม่สะดวก";
  String TextError = "โปรดตรวจสอบสัญญาณอินเตอร์ของท่าน";

  @override
  Widget build(BuildContext context) {
    _connectNetwork.startTimer(context);
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        supportedLocales: L10n.all,
        locale: Locale('${_dataKios.language.value}'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        home: (_connectNetwork.isConnected.value == true)
            ? LoadData()
            : NotAvailable(HeadTextError, TextError));
  }
}
