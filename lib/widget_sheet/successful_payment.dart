import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:screen/timeControl/waiting%20_for_success.dart';
import 'package:screen/widget_sheet/food_option.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/amount_food.dart';
import '../getxController.dart/save_menu.dart';
import '../printer/printer_getx.dart';
import '../screen/selection_screen.dart';
import '../timeControl/adtime.dart';
import 'myorder.dart';
import 'package:flutter/services.dart';

class successful_payment extends StatelessWidget {
  final UsbDeviceController usbDeviceController =
      Get.put(UsbDeviceController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final int successful_time = 10;
    final int admob_time = 30;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time));
    String formatTimes(int seconds) {
      int minutes = (seconds ~/ 60);
      int remainingSeconds = (seconds % 60);
      return '${remainingSeconds.toString().padLeft(2, '0')}';
    }

    final FoodOptionController _foodOptionController =
        Get.put(FoodOptionController());
    final controller = Get.put(waiting_for_success(successful_time));
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final currentDate = DateTime.now();
    final dataKios _dataKios = Get.put(dataKios());
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(currentDate);
    String transaction =
        '${_dataKios.queue.value} The transaction was completed successfully : ${_foodOptionController.formattedDate}';
    LogFile(transaction);
    return GestureDetector(
        onTap: () {
          adtimeController.reset();
        },
        child: SingleChildScrollView(
            child: Container(
          height: sizeHeight * 0.7,
          width: sizeWidth * 1,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              children: [
                Text(
                  'Order Food And Make A Payment.',
                  style: GoogleFonts.kanit(
                    fontSize: sizeWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Completed !',
                  style: GoogleFonts.kanit(
                    fontSize: sizeWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Payment Successful!',
                  style: GoogleFonts.kanit(
                    fontSize: sizeWidth * 0.032,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    formattedDate,
                    style: GoogleFonts.kanit(
                      fontSize: sizeWidth * 0.032,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 40),
                  child: Image.asset(
                    'assets/กรุณารับใบเสร็จ.gif',
                    width: sizeWidth * 0.35,
                  ),
                ),
                Text(
                  'Please Wait For Your Receipt',
                  style: GoogleFonts.kanit(
                    fontSize: sizeWidth * 0.032,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    String returns =
                        'Return to the Select a dining location page : ${_foodOptionController.formattedDate}';
                    LogFile(returns);
                    final controllers = Get.find<waiting_for_success>();
                    adtimeController.startTimer(context);
                    Get.delete<FoodOptionController>();
                    controller.stopTimerAndReset();
                    Get.delete<MyOrder>();
                    Get.delete<UsbDeviceController>();
                    Get.delete<FoodItem>();
                    Get.delete<amount_food>();
                    Get.delete<food_option>();
                    FoodItem foodItem = null;
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
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 291),
                    child: Container(
                      height: sizeHeight * 0.09,
                      width: sizeWidth * 1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 10),
                              child: Text(
                                'Return To The Main Page',
                                style: GoogleFonts.kanit(
                                  fontSize: sizeWidth * 0.032,
                                ),
                              ),
                            ),
                          ),
                          Obx(() {
                            final success_controller =
                                Get.find<waiting_for_success>();
                            return Text(
                              '(${formatTimes(success_controller.remainingSeconds.value)})',
                              style: GoogleFonts.kanit(
                                fontSize: sizeWidth * 0.032,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )));
  }
}
