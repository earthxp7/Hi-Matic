import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:screen/getxController.dart/payment.dart';
import 'package:screen/getxController.dart/selection.dart';
import 'package:screen/printer/printer_LAN.dart';
import 'package:screen/timeControl/waiting%20_for_success.dart';
import 'package:screen/widget_sheet/food_option.dart';
import '../UI/Font/ColorSet.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/amount_food.dart';
import '../getxController.dart/save_menu.dart';
import '../printer/printer_USB.dart';
import '../screen/selection_screen.dart';
import '../timeControl/adtime.dart';
import 'myorder.dart';

class successful_payment extends StatelessWidget {
  final UsbDeviceControllers usbDeviceController =
      Get.put(UsbDeviceControllers());
  final FoodItem resetfood = FoodItem();
  final dataKios _dataKios = Get.put(dataKios());

  @override
  Widget build(BuildContext context) {
    final int successful_time = 10;
    final int admob_time = 30;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time: admob_time));
    final waiting_for_success success_controller =
        Get.put(waiting_for_success(successful_time));
    String formatTimes(int seconds) {
      int minutes = (seconds ~/ 60);
      int remainingSeconds = (seconds % 60);
      return '${remainingSeconds.toString().padLeft(2, '0')}';
    }
    final FoodOptionController _foodOptionController =
        Get.put(FoodOptionController());
    final FoodItem _Item = Get.put(FoodItem());
    final controller = Get.put(waiting_for_success(successful_time));
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final currentDate = DateTime.now();
    final dataKios _dataKios = Get.put(dataKios());
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(currentDate);
    String transaction =
        '${_dataKios.queue.value} The transaction was completed successfully : ${_foodOptionController.formattedDate}';
    LogFile(transaction);
    if (_dataKios.printer_on.value == true) {
      Printer();
    }
    return GestureDetector(
        onTap: () {
          adtimeController.reset();
        },
        child: SingleChildScrollView(
            child: Container(
          height: sizeHeight * 0.87,
          width: sizeWidth * 1,
          child:  Column(
              children: [
                SizedBox(height: sizeHeight *0.05,),
                Text('สั่งอาหารและชำเงิน',style: Fonts(context, 0.05, true, Colors.black)),
                Text('เสร็จสมบูรณ์ !',style: Fonts(context, 0.05, true, Colors.black)),
                Text('Payment Successful!',style: Fonts(context, 0.038, true, Colors.black)),
                SizedBox( height: sizeHeight *0.01,),
                Text(formattedDate, style: Fonts(context, 0.04, true, Colors.black)),
                SizedBox( height: sizeHeight *0.025),
                Image.asset('assets/Succeed.gif',width: sizeWidth * 0.45,),
                SizedBox(height: sizeHeight *0.01 ),
                Text('กรุณารอรับใบเสร็จ', style: Fonts(context, 0.055, true, Colors.black)),
                SizedBox(height: sizeHeight *0.01),
                Text('หมายเลขคิวของคุณ',style: Fonts(context, 0.04, true, Colors.black)),
                SizedBox(height: sizeHeight *0.01),
                Container(
                  height: sizeHeight*0.07,
                  width: sizeWidth *0.3,
                  decoration: BoxDecoration(
                  color: Color.fromRGBO(242, 242, 242, 1,),
                  borderRadius:
                  BorderRadius.circular(
                  sizeWidth * 0.02),
                  ),
                  child:  Align(
                    alignment: Alignment.center,
                    child: Text(_dataKios.que.value ,style: Fonts(context, 0.065, true, Colors.black))),
                ),
                  SizedBox(height: sizeHeight *0.06),
                GestureDetector(
                  onTap: () async {
                    String returns =
                        'Return to the Select a dining location page : ${_foodOptionController.formattedDate}';
                    LogFile(returns);
                    adtimeController.startTimer(context);
                    controller.stopTimerAndReset();
                    Get.delete<amount_food>();
                    Get.delete<FoodOptionController>();
                    controller.stopTimerAndReset();
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
                  },
                  child: Container(
                  height: sizeHeight*0.085,
                  width: sizeWidth *0.5,
                  decoration: BoxDecoration(
                  color: Color.fromRGBO(206, 206, 206, 1,),
                  borderRadius:
                  BorderRadius.circular(
                  sizeWidth * 0.02),
                  boxShadow: [
                    BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2, blurRadius: 4,offset:const Offset(6, 6),
                      ),
                    ],
                  ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: sizeHeight*0.01,
                          ),
                          Text('กลับสู่หน้าหลัก', style: Fonts( context, 0.042, true, Colors.black)),
                          SizedBox(
                            height: sizeHeight*0.005,
                          ),
                          Obx(() {
                            return Text(
                                '(${formatTimes(success_controller.remainingSeconds.value)})',
                                style:
                                    Fonts(context, 0.042, true, Colors.black));
                          }),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }

  void Printer() async {
    if (_dataKios.connected.value == true) {
   //   await usbDeviceController.prints();
      await printToNetworkPrinter();
      _dataKios.printer_on.value = false;
    }
  }
}
