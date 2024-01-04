import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/amount_food.dart';
import '../getxController.dart/save_menu.dart';
import '../printer/printer_getx.dart';
import '../screen/ads_screen.dart';
import '../widget_sheet/fail_payment.dart';
import '../widget_sheet/food_option.dart';
import '../widget_sheet/myorder.dart';

class AdMobTimeController extends GetxController {
  final int admob_time;
  RxInt remainingSeconds = 0.obs;
  Timer timer;
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  AdMobTimeController(this.admob_time);

  @override
  void onInit() {
    super.onInit();
    remainingSeconds.value = admob_time;
  }

  void stopTimerAndReset() {
    timer?.cancel();
    remainingSeconds.value = admob_time;
  }

// Assume that you have a variable `remainingSeconds` and `successful_time` defined somewhere.

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
        timer?.cancel();

        remainingSeconds.value = admob_time;
        stopTimerAndReset();
        Get.delete<FoodOptionController>();
        Get.delete<MyOrder>();
        Get.delete<UsbDeviceController>();
        Get.delete<FoodItem>();
        Get.delete<amount_food>();
        Get.delete<food_option>();
        Get.delete<fail_pay_screen>();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return WillPopScope(
                  onWillPop: () async {
                    // Return false to prevent the user from navigating back
                    return false;
                  },
                  child: Ads_screen());
            },
          ),
        );
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

  /* void checkKeyboardVisibility(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    if (isKeyboardVisible) {
      print('เปิด');
    } else {
      print('ปิด');
    }
  }*/

  /* void closeKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
    print('ปิดละ');
  }*/
}
