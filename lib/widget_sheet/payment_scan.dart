import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:screen/UI/Font/ColorSet.dart';
import 'package:screen/api/Kios_API.dart';
import 'package:screen/api/payment.dart';
import 'package:screen/getxController.dart/payment.dart';
import 'package:screen/getxController.dart/printer_setting.dart';
import 'package:screen/getxController.dart/selection.dart';
import 'package:screen/screen/setting_screen.dart';
import 'package:screen/timeControl/waiting_for_payment.dart';
import '../getxController.dart/save_menu.dart';
import '../printer/printer_USB.dart';
import '../timeControl/adtime.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final pinter_test printer_Test = Get.put(pinter_test());
final int pay_time = 180;
class pay_scan_bottomsheet extends StatelessWidget {
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final UsbDeviceControllers usbDeviceController =
      Get.put(UsbDeviceControllers());
  final dataKios _dataKios = Get.put(dataKios());
  final set_printer = Setting_Screen();
  final int IndexOrder;
  final SelectionController selectionController =
      Get.put(SelectionController());
  final Payment_controller payment_controller = Get.put(Payment_controller());
  pay_scan_bottomsheet({
    required this.IndexOrder,
  });
   
  String formatTime(int seconds) {
    int minutes = (seconds ~/ 60);
    int remainingSeconds = (seconds % 60);
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
     List<Map<String, dynamic>> payment = Payments.PayMentItem(context);
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(currentDate);
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final int admob_time = 60;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time: admob_time));
   final pay_time_controller =
        Get.put(waiting_for_payment(pay_time: pay_time));
    return GestureDetector(
        onTap: () {
          adtimeController.reset();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: sizeHeight * 0.87,
                width: sizeWidth * 1,  
                child: Column(
                  children: [
                    Row(children: [
                      Container(
                        height: sizeHeight * 0.277,
                        width: sizeWidth * 1,
                        child: Row(
                          children: [
                            SizedBox(width: sizeWidth *0.12,),
                            Container(
                                  height: sizeHeight * 0.2,
                                  width: sizeWidth * 0.08,
                                 // color: Colors.yellow,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.arrow_back,
                                        size: sizeHeight * 0.032,
                                        color: Colors.black,
                                        
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    16), // Adjust the radius as needed
                                              ),
                                              title: Text(AppLocalizations.of(context)!.head_cancel_payment,
                                                  style: Fonts(context, 0.045,
                                                      true, Colors.red)),
                                              content: Text(
                                                  AppLocalizations.of(context)!.detail_cancel_payment,
                                                  style: Fonts(context, 0.028,
                                                      false, Colors.black)),
                                              actions: [
                                                Row(
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                                vertical: 12,
                                                                horizontal: 24),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      child: Text(AppLocalizations.of(context)!.cancel,
                                                          style: Fonts(
                                                              context,
                                                              0.034,
                                                              false,
                                                              Colors.white)),
                                                    ),
                                                    SizedBox(
                                                      width: sizeWidth * 0.25,
                                                    ),
                                                    TextButton(
                                                      onPressed: () {                                              
                                                       pay_time_controller
                                                            .stopTimerAndReset();
                                                       // adtimeController.startTimer(context);
                                                        // payment_controller.timer?.cancel();
                                                        Navigator.of(context)
                                                            .pop();
                                                         Navigator.of(context)
                                                            .pop();
                                                        _foodOptionController.payment_times.value  = 0;
                                                        String back =
                                                            'Return to the payment channels page : ${selectionController.paymentsName.value} ${_foodOptionController.formattedDate}';
                                                        LogFile(back);
                                                        _dataKios.Qrpayment = [];
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.blue,
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                                vertical: 12,
                                                                horizontal: 24),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      child: Text(AppLocalizations.of(context)!.agree,
                                                          style: Fonts(
                                                              context,
                                                              0.034,
                                                              false,
                                                              Colors.white)),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            );
                                          },
                                        );
                                        adtimeController.reset();
                                      },
                                    ),
                                  )),
                            SizedBox(width: sizeWidth *0.03,),
                            Container(
                              height: sizeHeight * 0.2,
                              child: Column(
                                children: [
                                  Container(
                                    child: Text('กรุณาชำระเงิน',
                                          style: Fonts(
                                              context, 0.05, true, Colors.black)),
                                    ),
                                   Text('Please scan QR code',
                                        style: Fonts(
                                            context, 0.038, false, Colors.black)),
                                  SizedBox(height: sizeHeight * 0.065,),
                                  Row(
                                      children: [
                                      SizedBox(width: sizeWidth *0.015,),
                                      Text('กรุณาชำระเงินภายใน',
                                              style: Fonts(context, 0.04, true,
                                                  Colors.black)),
                                      SizedBox(width: sizeWidth *0.02,),
                                        Container(
                                          height: sizeHeight * 0.048,
                                          width: sizeWidth * 0.2,
                                          color:
                                              Color.fromARGB(255, 239, 238, 235),
                                          child: Center(
                                            child: Obx(() {
                                              final controller =
                                                  Get.find<waiting_for_payment>();
                                              return Text(
                                                formatTime(controller
                                                    .remainingSeconds.value),
                                                style: GoogleFonts.kanit(
                                                  fontSize: sizeWidth * 0.042,
                                                ),
                                              );
                                            }),
                                          ),
                                        )
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ]),
                    Container(
                      height: sizeHeight * 0.3,
                      width: sizeWidth * 0.55,
                      decoration: BoxDecoration(
                      color: payment[IndexOrder]['color'], 
                      borderRadius: BorderRadius.circular(sizeWidth * 0.035),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: sizeHeight * 0.02,
                          ),
                         Container(
                          height: sizeHeight * 0.045,
                          width: sizeWidth * 0.32,
                          decoration: BoxDecoration(
                          color: Colors.white, 
                          borderRadius: BorderRadius.circular(sizeWidth * 0.01), 
                          ),
                           child: Image.asset(
                                  payment[IndexOrder]['image'],
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                  width: sizeWidth * 0.45,
                                  height:sizeHeight * 0.05, 
                                ),
                              ),  
                            SizedBox(
                            height: sizeHeight * 0.02,
                            ),
                            Container(
                              height: sizeHeight * 0.2,
                              width: sizeWidth * 0.45,
                              decoration: BoxDecoration(
                              color: Colors.white, 
                              borderRadius: BorderRadius.circular(sizeWidth * 0.035), 
                               ),
                              child: FutureBuilder<Image>(
                              future: payment_controller.CovertQR(),
                              builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                              return Image(
                              image: snapshot.data!.image,
                              width: sizeWidth *0.001, 
                              height: sizeHeight *0.001, 
                              
                             // color: Colors.amber,
                               );
                              } else {
                              return CircularProgressIndicator();
                                 }
                                },
                              )
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                  height: sizeHeight * 0.15,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(sizeWidth *0.03),
                  ),
                  child: GestureDetector(
                     onTap: () async{
                      print('TetsPrinter');
                   await usbDeviceController.prints();
                     },
                    child: Container(
                      height: sizeHeight * 0.069,
                      width: sizeWidth * 0.9,
                      decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 0, 23, 1),
                      borderRadius: BorderRadius.all(
                      Radius.circular(sizeWidth*0.04),
                        ),
                      boxShadow: [
                      BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2, 
                      blurRadius: 8, 
                      offset: Offset(0, 4), 
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: sizeHeight *0.069,
                            width: sizeWidth * 0.6,
                           // color: Colors.blue,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(AppLocalizations.of(context)!.total_payment,
                              textAlign: TextAlign.center,
                                  style: Fonts(context, 0.045, true, Colors.white,
                                  )),
                            ),
                          ),SizedBox(
                            height: sizeHeight * 0.1,
                          ),
                          Obx(() => Container(
                            width: sizeWidth * 0.3,
                            height: sizeHeight * 0.069,
                            //color: Colors.green,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('${selectionController.totalPrice.value} ฿',
                                  style: Fonts(context, 0.045, true, Colors.white)
                                  ,),
                            ),
                          ))
                        ],
                      ),
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
