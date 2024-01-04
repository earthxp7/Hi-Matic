import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/amount_food.dart';
import '../getxController.dart/save_menu.dart';
import '../printer/printer_getx.dart';
import '../screen/selection_screen.dart';
import '../widget_sheet/food_option.dart';
import 'adtime.dart';

import 'package:http/http.dart' as http;

int admob_time = 30;

class waiting_for_success extends GetxController {
  final UsbDeviceController usbDeviceController =
      Get.put(UsbDeviceController());
  final int successful_time;
  RxInt remainingSeconds = 0.obs;
  Timer timer;
  final dataKios _dataKios = Get.put(dataKios());
  waiting_for_success(this.successful_time);
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final admob_times = Get.put(AdMobTimeController(admob_time));

  @override
  void onInit() {
    super.onInit();
    remainingSeconds.value = successful_time;
  }

  void stopTimerAndReset() {
    timer?.cancel();
    remainingSeconds.value = successful_time;
  }

  void startTimer(BuildContext context) {
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
        print('susses ${remainingSeconds.value}');
      } else if (remainingSeconds.value == 0) {
        print('sussesEsle ${remainingSeconds.value}');
        String returns =
            'Return to the Select a dining location page : ${_foodOptionController.formattedDate}';
        LogFile(returns);
        timer?.cancel();
        stopTimerAndReset();
        admob_times.startTimer(context);
        Get.delete<amount_food>();
        Get.delete<FoodOptionController>();
        Get.delete<UsbDeviceController>();
        Get.delete<FoodItem>();
        Get.delete<food_option>();
        FoodItem foodItem = null;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: selection_screen(),
              );
            },
          ),
        );
      }
    });
  }

  void reset() {
    remainingSeconds.value = successful_time;
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
