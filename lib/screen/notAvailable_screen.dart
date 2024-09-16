import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../Appbar/language.dart';
import '../UI/Font/ColorSet.dart';
import '../timeControl/connect_internet.dart';
import 'package:flutter/services.dart';

class NotAvailable extends StatelessWidget {
  final HeadTextError;
  final TextError;
  NotAvailable(this.HeadTextError, this.TextError);

  @override
  Widget build(BuildContext context) {
    final int connect = 300;
    final connectnetwork = Get.put(connectNetwork(connect: connect));
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    connectnetwork.Internet.value = true;
    return Scaffold(
        body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(children: [
              Container(
                  height: sizeHeight * 0.045,
                  width: sizeWidth * 1,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(sizeWidth * 0.01),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: languageBar()),
              Container(
                height: sizeHeight * 0.955,
                width: sizeWidth * 1,
                color: Color.fromARGB(255, 212, 212, 212),
                child: Center(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 400),
                      child: Container(
                        height: sizeHeight * 0.25,
                        width: sizeWidth * 0.7,
                        child: Lottie.asset('assets/notAvailable.json'),
                      ),
                    ),
                    Text(HeadTextError,
                        style: Fonts(context, 0.085, false, Colors.red)),
                    Text(TextError,
                        style: Fonts(context, 0.05, false, Colors.black)),
                  ]),
                ),
              ),
            ])));
  }
}
