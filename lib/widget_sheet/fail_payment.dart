import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    final FoodOptionController _foodOptionController =
        Get.put(FoodOptionController());
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final currentDate = DateTime.now();
    final int pay_time = 5;
    final controller = Get.put(waiting_for_payment(pay_time: pay_time));
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(currentDate);
    final int admob_time = 30;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time: admob_time));
    return GestureDetector(
        onTap: () {
          adtimeController.reset(); // Reset the time countdown
        },
        child: Container(
          height: sizeHeight * 0.87,
          width: sizeWidth * 1,
          color: Colors.white,
          child: Column(
            children: [
              Column(
                children: [
              SizedBox(height: sizeHeight *0.05,),
              Text('ชำระเงินล้มเหลว',style: Fonts(context, 0.05, true, Colors.black)),
                ],
              ),
            Text('Payment Failed!',style: Fonts(context, 0.038, true, Colors.black)),
             SizedBox( height: sizeHeight *0.01,),
             Text(formattedDate,style: Fonts(context, 0.042, false, Colors.black)),
             SizedBox( height: sizeHeight *0.08), 
             Image.asset('assets/Fail.gif',width: sizeWidth * 0.5,),
             SizedBox(height: sizeHeight *0.23),
              
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
                child: Container(
                  height: sizeHeight*0.065,
                  width: sizeWidth *0.7,
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
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('ลองใหม่อีกครั้ง',
                            style: Fonts(context, 0.045, true, Colors.black)),
                      ),
                    
                  ),
                
              )
            ],
          ),
        ));
  }
}
