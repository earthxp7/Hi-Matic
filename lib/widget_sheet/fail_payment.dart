import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../UI/Font/ColorSet.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/save_menu.dart';
import '../timeControl/adtime.dart';
import '../timeControl/waiting_for_payment.dart';
import 'package:flutter/services.dart';

class fail_pay_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final FoodOptionController _foodOptionController =
        Get.put(FoodOptionController());
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final currentDate = DateTime.now();
    final int pay_time = 5;
    final controller = Get.put(waiting_for_payment(pay_time));
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(currentDate);
    final int admob_time = 30;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time));
    return GestureDetector(
        onTap: () {
          adtimeController.reset(); // Reset the time countdown
        },
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          child: BottomSheet(
            onClosing: () {},
            builder: (context) {
              return ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                child: Container(
                  height: sizeHeight * 0.7,
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 16.0),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Text('ชำระเงินล้มเหลว',
                                style:
                                    Fonts(context, 0.045, true, Colors.black)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text('Payment Failed!',
                            style: Fonts(context, 0.032, true, Colors.black)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 40),
                        child: Text(formattedDate,
                            style: Fonts(context, 0.03, false, Colors.black)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 100),
                        child: Container(
                          height: sizeHeight * 0.3,
                          width: sizeWidth * 0.5,
                          child: Lottie.asset('assets/fail_payment.json'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          String Back =
                              'Try payment again : ${_foodOptionController.formattedDate}';
                          LogFile(Back);
                          adtimeController.reset();
                          Get.find<waiting_for_payment>();
                          controller.stopTimerAndReset();
                          Get.back();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                          child: Container(
                            height: sizeHeight * 0.065,
                            width: sizeWidth * 0.65,
                            color: Color.fromARGB(255, 225, 222, 222),
                            child: Center(
                              child: Text('ลองใหม่อีกครั้ง',
                                  style: Fonts(
                                      context, 0.04, false, Colors.black)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
