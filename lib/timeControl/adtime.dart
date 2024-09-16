import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen/getxController.dart/selection.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/amount_food.dart';
import '../getxController.dart/save_menu.dart';
import '../printer/printer_USB.dart';
import '../screen/ads_screen.dart';
import '../widget_sheet/fail_payment.dart';
import '../widget_sheet/food_option.dart';
import '../widget_sheet/myorder.dart';

class AdMobTimeController extends GetxController {
  final int admob_time;
  RxInt remainingSeconds = 0.obs;
  Timer? timer;
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  AdMobTimeController({required this.admob_time});
  @override
  void onInit() {
    super.onInit();
    remainingSeconds.value = admob_time;
  }

  void stopTimerAndReset() {
    timer?.cancel();
    remainingSeconds.value = admob_time;
  }

  void startTimer(BuildContext context) {
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
        print('ทาร์มเอ้า ${remainingSeconds.value}');
      } else if (remainingSeconds.value == 0) {
        print('ทาร์มเอ้าElse ${remainingSeconds.value}');
        String Timeout =
            'Timeout(Advert): ${_foodOptionController.formattedDate}';
        LogFile(Timeout);
        timer.cancel();

        remainingSeconds.value = admob_time;
        stopTimerAndReset();
      Get.delete<FoodOptionController>();
        Get.delete<MyOrder>();
        Get.delete<UsbDeviceControllers>();
        Get.delete<FoodItem>();
        Get.delete<amount_food>();
        Get.delete<food_option>();
        Get.delete<fail_pay_screen>();
        Get.to( Ads_screen());
        Get.delete<SelectionController>();
    /*  Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return WillPopScope(
                  onWillPop: () async {
                    return false;
                  },
                  child: Ads_screen());
            },
          ),
        );*/
      }
    });
  }
 


  void reset() {
    remainingSeconds.value = admob_time;
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
