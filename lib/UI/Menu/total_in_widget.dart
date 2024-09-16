import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen/api/Kios_API.dart';
import 'package:screen/getxController.dart/save_menu.dart';
import 'package:screen/getxController.dart/selection.dart';
import 'package:screen/timeControl/adtime.dart';
import 'package:screen/widget_sheet/payment_option.dart';
import '../Font/ColorSet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TotalWiget extends StatelessWidget {
  final dataKios _dataKios = Get.put(dataKios());
    final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final SelectionController selectionController =
      Get.put(SelectionController());
  @override
  Widget build(BuildContext context) {
    final int admob_time = 60;
    final AdMobTimeController adtimeController =
      Get.put(AdMobTimeController(admob_time: admob_time));
    final sizeWidth = MediaQuery.of(context).size.width;
    final sizeHeight = MediaQuery.of(context).size.height;
    return  Container(
              width: sizeWidth * 0.8,
              height: sizeHeight * 0.07,
              decoration: BoxDecoration(
              color: Color.fromRGBO(242, 242, 242, 1),
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
                      width: sizeWidth *0.6,
                      height:  sizeHeight * 0.07,
                      child: Row(
                        children: [ 
                          SizedBox(
                            width: sizeWidth*0.05,
                         ),
                        Container(
                          width: sizeWidth *0.3,
                          child: Text(AppLocalizations.of(context)!.total_payment,
                              style: Fonts(context, 0.035, false, Colors.black)),
                        ),
                        Obx(() => Container(
                          width: sizeWidth *0.22,
                          child: Text('${selectionController.totalPrice.value} ฿',
                              style: Fonts(context, 0.038, true, Colors.black)
                              ,textAlign: TextAlign.right,),
                        ))
                      ],     
                  ),
                  ),
                  GestureDetector(
                    onTap: () {
                      String payment =
                    'Open the payment options page : ${_foodOptionController.formattedDate}';
                LogFile(payment);
                Navigator.of(context).pop();
                _foodOptionController.tapCount.value = 0;
                adtimeController.reset();
                showFlexibleBottomSheet(
                    initHeight: 0.861,
                    isDismissible: false,
                    context: context,
                    bottomSheetBorderRadius: BorderRadius.only(
                    topLeft: Radius.circular(sizeWidth*0.05),
                    topRight: Radius.circular(sizeWidth*0.05),
                     ),
                    
                    builder: (context, controller, offset) {
                      return NotificationListener<
                              OverscrollIndicatorNotification>(
                          onNotification:
                              (OverscrollIndicatorNotification notification) {
                            notification.disallowIndicator();
                            return false;
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(sizeWidth*0.05),
                                  topRight: Radius.circular(sizeWidth*0.05),
                                ),
                              ),
                              child: BottomSheetContent()));
                    });
                    },
                    child: Container(       
                      height: sizeHeight * 0.07,
                      width: sizeWidth * 0.2,
                      decoration: BoxDecoration(
                      color: (selectionController.countAll.value > 0)
                      ? Color.fromARGB(255, 4, 193, 10)
                      : Color.fromRGBO(255, 0, 23, 1),
                      borderRadius: BorderRadius.only(
                       bottomRight: Radius.circular(sizeWidth*0.037),
                       topRight: Radius.circular(sizeWidth*0.037)
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
                      child: Center(   
                          child: Text(
                            AppLocalizations.of(context)!.process3,
                            style: TextStyle(
                              fontSize: sizeWidth * 0.038,
                              fontFamily: 'SukhumvitSet-Medium',
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                  ),
                ],
              ),
      );
  }
}
