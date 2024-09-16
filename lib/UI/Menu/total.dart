import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen/getxController.dart/selection.dart';
import 'package:screen/widget_sheet/payment_option.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../api/Kios_API.dart';
import '../../getxController.dart/save_menu.dart';
import '../../timeControl/adtime.dart';
import '../../widget_sheet/myorder.dart';

class totalUI extends StatelessWidget {
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final SelectionController selectionController =
      Get.put(SelectionController());
  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final int admob_time = 60;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time: admob_time));
    final DateLog = _foodOptionController.formattedDate;
    String Back = 'Back Select a dining location page : ${DateLog}';
    return Container(
      color: Color.fromRGBO(246, 246, 246, 1),
      width: sizeWidth * 1,
      child: Container(
        height: sizeHeight * 0.12,
        width: sizeWidth * 0.7,
        color: Color.fromRGBO(246, 246, 246, 1),
        child: Row(
          children: [
            SizedBox(width: sizeWidth * 0.1,),
            Container(
              height: sizeHeight * 0.06,
              width: sizeWidth * 0.8,
               decoration: BoxDecoration(
              color: Colors.white, 
              boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25), 
                spreadRadius: 2, 
                blurRadius: 4, 
                offset: Offset(4, 4), 
                ),
              ],
              borderRadius: BorderRadius.circular(30), 
            ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Transform.translate(
                        offset: Offset(sizeWidth * 0.0, sizeHeight * 0.002),
                        child:Container(
                                height: sizeHeight * 0.022,
                                width: sizeWidth * 0.05,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: Obx(
                                  () =>Transform.translate(
                                    offset: Offset(
                                      sizeWidth * (
                                      selectionController.countAll.value > 99 ? 0.004 : 
                                      selectionController.countAll.value > 9 ? 0.0045  : 
                                      0.011 
                                        ),
                                      sizeHeight * (selectionController.countAll.value > 99 ? 0.003
                                     :0.0 )),
                                      child:  Container(
                                        height: sizeHeight * 0.022,
                                        width: sizeWidth * 0.05,
                                        child: Text(
                                        ' ${selectionController.countAll.value}',
                                        style: GoogleFonts.kanit(
                                            fontSize: sizeHeight * (selectionController.countAll.value > 99 ? 0.0115 :0.015),
                                            color: Colors.white),
                                              ),
                                      ),
                                ))
                      )),
                       GestureDetector(
                          onTap: () {
                            String moyorder =
                                'Open my food page : ${_foodOptionController.formattedDate}';
                            LogFile(moyorder);
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
                                        (OverscrollIndicatorNotification
                                            notification) {
                                      notification.disallowIndicator();
                                      return false;
                                    },
                                    child: MyOrder(),
                                  );
                                });
                          },
                            child: Transform.translate(
                          offset: Offset(sizeWidth * -0.025, sizeHeight * -0.01),
                          child: Image.asset(
                              'assets/basket.png',
                              height: sizeHeight * 0.037,
                              width: sizeWidth * 0.2,
                              fit: BoxFit.contain,
                            ),
                          ),
                  )],
                  ),
                  SizedBox(
                    width: sizeWidth * 0.13,
                  ),
                      Obx(
                          () => Container(
                            width: sizeWidth *0.25,
                            child: Text(
                            '${selectionController.totalPrice.value} ฿',
                              style: TextStyle(
                                fontSize: sizeWidth * 0.042,
                                fontFamily: 'SukhumvitSet-Medium',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                   ),
                    SizedBox(
                    width: sizeWidth * 0.025,
                  ),
                  GestureDetector(
              onTap: () {
                String payment =
                    'Open the payment options page : ${_foodOptionController.formattedDate}';
                LogFile(payment);
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
              child: Obx(() => Container(
                    height: sizeHeight * 0.042,
                    width: sizeWidth * 0.17,
                     decoration: BoxDecoration(
                    color: (selectionController.countAll.value > 0)
                    ? Color.fromARGB(255, 4, 193, 10)
                    : Color.fromRGBO(255, 0, 23, 1),
                    borderRadius: BorderRadius.all(
                    Radius.circular(sizeWidth*0.05),
                  ),
                    boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25), // สีของเงา
                      spreadRadius: 2, // การกระจายของเงา
                      blurRadius: 4, // ความฟุ้งของเงา
                      offset: Offset(4, 4), // การเลื่อนของเงา (x, y)
                      ),
                    ],
                  ),
                    child: Center(   
                        child: Text(
                          AppLocalizations.of(context)!.process3,
                          style: TextStyle(
                            fontSize: sizeWidth * 0.032,
                            fontFamily: 'SukhumvitSet-Medium',
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  )),
              ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
