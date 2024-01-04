import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen/screen/loadOrder_screen.dart';
import 'package:flutter/services.dart';
import 'api/Kios_API.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpClient httpClient = HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final dataKios _dataKios = Get.put(dataKios());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          radioTheme: RadioThemeData(
            fillColor: MaterialStateProperty.all(Colors.black),
          ),
        ),
        home: LoadData());
  }
}
