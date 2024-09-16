import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen/getxController.dart/amount_food.dart';
import 'package:screen/widget_sheet/successful_payment.dart';
import '../getxController.dart/save_menu.dart';
import '../printer/printer_USB.dart';
import '../timeControl/adtime.dart';
import '../timeControl/waiting _for_success.dart';
import 'payment_option.dart';
import 'package:flutter/services.dart';

class cash_bottomsheet extends StatelessWidget {
  final amount_food _amount_food = Get.put(amount_food());
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());

  final UsbDeviceControllers usbDeviceController =
      Get.put(UsbDeviceControllers());
  final int IndexOrder;
  cash_bottomsheet({required this.IndexOrder});
  @override
  Widget build(BuildContext context) {
    final BottomSheetContent _bottomSheetContent =
        Get.put(BottomSheetContent());
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final int successful_time = 60;
    final successful_time_controller =
        Get.put(waiting_for_success(successful_time));
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final int admob_time = 30;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time: admob_time));
    return GestureDetector(
        onTap: () {
          adtimeController.reset();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: sizeHeight * 0.7,
                width: sizeWidth * 1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  children: [
                    Row(children: [
                      Container(
                        height: sizeHeight * 0.13,
                        width: sizeWidth * 1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 70, bottom: 100, right: 140, top: 100),
                              child: IconButton(
                                icon: Icon(Icons.arrow_back),
                                iconSize: sizeWidth * 0.05,
                                onPressed: () {
                                  Get.back();
                                  adtimeController.reset();
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 100, bottom: 10),
                              child: Column(
                                children: [
                                  Text(
                                    'Please Make A Payment',
                                    style: GoogleFonts.kanit(
                                      fontSize: sizeWidth * 0.045,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Please Proceed With Your Payment',
                                    style: GoogleFonts.kanit(
                                      fontSize: sizeWidth * 0.032,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 182, top: 182),
                      child: Container(
                        height: sizeHeight * 0.3,
                        width: sizeWidth * 0.6,
                        color: Colors.white,
                        child: Image.asset(
                          'assets/paycash.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          adtimeController.stopTimerAndReset();
                          successful_time_controller.startTimer(context);
                          /*if (usbDeviceController.connected.value) {
                            usbDeviceController.prints();
                          } else {
                            print('Printer is not connected.');
                          }*/
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useRootNavigator: true,
                              isDismissible: false,
                              enableDrag: false,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              builder: (context) {
                                return WillPopScope(
                                  onWillPop: () async {
                                    // Return false to prevent the bottom sheet from being closed
                                    return false;
                                  },
                                  child: successful_payment(),
                                );
                              });
                        },
                        child: Container(
                          height: sizeHeight * 0.08,
                          width: sizeWidth * 1,
                          color: Color.fromARGB(255, 225, 224, 223),
                          child: Center(
                              child: Obx(
                            () => Text(
                              'Total Payment        ${_foodOptionController.total_price.value} ฿',
                              style: GoogleFonts.kanit(
                                fontSize: sizeWidth * 0.042,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
