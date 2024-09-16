import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen/getxController.dart/payment.dart';
import 'package:screen/getxController.dart/selection.dart';
import 'package:screen/widget_sheet/myorder.dart';
import 'package:screen/widget_sheet/payment_option.dart';
import 'package:screen/widget_sheet/payment_scan.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/amount_food.dart';
import '../getxController.dart/save_menu.dart';
import '../printer/printer_USB.dart';
import '../screen/selection_screen.dart';
import '../widget_sheet/food_option.dart';
import 'adtime.dart';

int admob_time = 30;

class waiting_for_success extends GetxController {
  final FoodItem _Item = Get.put(FoodItem());
  final dataKios _dataKios = Get.put(dataKios());
  final UsbDeviceControllers usbDeviceController =
      Get.put(UsbDeviceControllers());
  final FoodItem resetfood = FoodItem();
  final int successful_time;
  RxInt remainingSeconds = 0.obs;
  Timer? timer;
  waiting_for_success(this.successful_time);
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final admob_times = Get.put(AdMobTimeController(admob_time: admob_time));

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
      if (remainingSeconds.value > 1) {
        remainingSeconds.value--;
        print('susses ${remainingSeconds.value}');
      } else if (remainingSeconds.value == 1) {
        String returns =
            'Return to the Select a dining location page : ${_foodOptionController.formattedDate}';
        LogFile(returns);
        admob_times.startTimer(context);
        stopTimerAndReset();
        Get.delete<amount_food>();
        Get.delete<FoodOptionController>();
        stopTimerAndReset();
        Get.delete<MyOrder>();
        Get.delete<UsbDeviceControllers>();
        Get.delete<FoodItem>();
        Get.delete<amount_food>();
        Get.delete<food_option>();
        Get.delete<Payment_controller>();
        Get.delete<SelectionController>();
        _dataKios.status.value = '';
        if (_Item.selectedlevel == '') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return WillPopScope(
                  onWillPop: () async {
                    // Return false to prevent the user from navigating back
                    return false;
                  },
                  child: selection_screen(),
                );
              },
            ),
          );
        }
      }
    });

    void reset() {
      remainingSeconds.value = successful_time;
    }

    @override
    void onClose() {
      timer?.cancel();
      super.onClose();
    }
  }
}
