import 'dart:io';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:screen/getxController.dart/save_menu.dart';
import '../../api/Kios_API.dart';
import '../../timeControl/adtime.dart';
import '../../widget_sheet/food_option.dart';

class menuUI extends StatelessWidget {
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final dataKios _dataKios = Get.put(dataKios());
var clickedId;
  String removeDiacritics(String text) {
    return text.replaceAll(RegExp('[่ ้ ๊ ๋ ็ ั ์ ิ ี ึ ืุ ู]'), '');
  }

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final int admob_time = 60;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time: admob_time));
    final DateLog = _foodOptionController.formattedDate;
    String food = 'Open the food options page : ${DateLog}';    
   
    return Container(
          color: Color.fromRGBO(246, 246, 246, 1),
          height: sizeHeight * 0.52,
          width: sizeWidth * 1,
          child: Obx(() =>  ListView.builder(
              itemCount:_dataKios.mealNames.length,
              itemBuilder: (BuildContext context, int index) {
                final meal = _dataKios.mealNames[index];
                final mealNameID = meal['id'] ?? 0; 
                final mealNameTH = meal['name_th'] ?? ''; 
                final mealNameEN = meal['name_en'] ?? ''; 
                final mealNameCN = meal['name_cn'] ?? ''; 
                final mealImage = meal['image'] ?? ''; 
                final mealDescriptionTH = meal['description_th'] ?? '';
                final mealDescriptionEN = meal['description_en'] ?? ''; 
                final mealDescriptionCN = meal['description_cn'] ?? ''; 
                final mealPrice = meal['price'] ?? '0';
                
                    return  Column(
                        children: [
                          Row(
                            children: [
                          SizedBox(width: sizeWidth * 0.13,),
                              Container(
                                height: sizeHeight * 0.13,
                                width: sizeWidth * 0.22,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(sizeWidth *0.03),
                                  // color: Color.fromRGBO(255, 0, 23, 1)
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: GestureDetector(
                                        onTap: () {
                                          LogFile(food);
                                          _foodOptionController.tapCount.value = 0;
                                          adtimeController.reset();
                                          clickedId = index;
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
                                                  child: food_option(
                                                 indexs: clickedId,
                                                 meal: _dataKios.mealNames[clickedId],
                                                  mealname :mealNameID.toString(),// mealNameEN,
                                                   cat:_foodOptionController.namecat.value
                                                  ),
                                                );
                                              });
                                        },
                                        child:
                                        Image.file(
                                          File(mealImage),
                                          fit: BoxFit.cover,
                                        ))),
                              ),
                              Container(
                                color: Color.fromRGBO(246, 246, 246, 1),
                                height: sizeHeight * 0.18,
                                width: sizeWidth * 0.56,
                                child: Column(
                                  children: [
                                    SizedBox(height: sizeHeight *0.025,),
                                     Container(
                                        height: sizeHeight * 0.03,
                                        width: sizeWidth * 0.5,
                                        color: Color.fromRGBO(246, 246, 246, 1),
                                        child: GestureDetector(
                                          onTap: () {
                                            LogFile(food);
                                            _foodOptionController.tapCount.value = 0;
                                            adtimeController.reset();
                                            clickedId = index;
                                            showFlexibleBottomSheet(
                                                initHeight: 0.861,
                                                isDismissible: false,
                                                context: context,
                                                bottomSheetBorderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(sizeWidth*0.05),
                                                topRight: Radius.circular(sizeWidth*0.05),
                                                ),
                                                builder:
                                                    (context, controller, offset) {
                                                  return NotificationListener<
                                                      OverscrollIndicatorNotification>(
                                                    onNotification:
                                                        (OverscrollIndicatorNotification
                                                            notification) {
                                                      notification
                                                          .disallowIndicator();
                                                      return false;
                                                    },
                                                    child: food_option(
                                                        indexs: clickedId,
                                                         meal: _dataKios.mealNames[clickedId],
                                                         mealname :mealNameID.toString(), //mealNameEN,
                                                          cat:_foodOptionController.namecat.value
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Obx(() => Text(
                                                (_dataKios.language.value == 'en')
                                                    ? mealNameEN.length <= 70
                                                        ? mealNameEN
                                                        : '${mealNameEN.substring(0, 70)}...'
                                                    :(_dataKios.language.value == 'zh')
                                                      ? mealNameCN.length <= 40
                                                          ? mealNameCN
                                                          :'${mealNameCN.substring(0, 40)}...'
                                                      :mealNameTH.length <= 70
                                                          ? mealNameTH
                                                          : '${mealNameTH.substring(0, mealNameTH.length - 70)}...',
                                                style: TextStyle(
                                                    fontSize: sizeWidth * 0.036,
                                                    fontFamily: 'SukhumvitSet-Medium',
                                                    fontWeight: FontWeight.bold),
                                              )),
                                        ),
                                      ),
                                    
                                    Container(
                                      height: sizeHeight * 0.044,
                                      width: sizeWidth * 0.5,
                                      child: Obx(() => Text(
                                            (_dataKios.language.value == 'en')
                                                ? mealDescriptionEN.length <= 70
                                                    ? mealDescriptionEN
                                                    : '${mealDescriptionEN.substring(0, 70)}...'
                                                 :(_dataKios.language.value == 'zh')
                                                      ? mealDescriptionCN.length <= 35
                                                          ? mealDescriptionCN
                                                          :'${mealDescriptionCN.substring(0, 35)}...'
                                                   : mealDescriptionTH.length <= 70
                                                    ? mealDescriptionTH
                                                    : '${mealDescriptionTH.substring(0, 70)}...',
                                            style: TextStyle(
                                              fontSize: sizeWidth * 0.024,
                                              fontFamily: 'SukhumvitSet-Medium',
                                            ),
                                          )),
                                    ),
                                    SizedBox(height: sizeHeight * 0.035,),
                                    Row(
                                      children: [
                                        SizedBox(width: sizeWidth *0.025,),
                                         Container(
                                            height: sizeHeight * 0.04,
                                            width: sizeWidth * 0.35,
                                            child: Text(
                                              mealPrice.toString() +  ' ฿',
                                              style: TextStyle(
                                                fontSize: sizeWidth * 0.035,
                                                fontFamily: 'SukhumvitSet-Medium',
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        
                                          SizedBox( width: sizeWidth * 0.11,),
                                          Container(
                                            height: sizeHeight * 0.038,
                                            width: sizeWidth * 0.07,
                                            child: GestureDetector(
                                                    onTap: () {
                                                  LogFile(food);
                                                _foodOptionController.tapCount.value =
                                                    0;
                                                adtimeController.reset();
                                                clickedId = index;
                                                showFlexibleBottomSheet(
                                                    initHeight: 0.861,
                                                    isDismissible: false,
                                                    context: context,
                                                    bottomSheetBorderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(sizeWidth*0.05),
                                                    topRight: Radius.circular(sizeWidth*0.05),
                                                    ),
                                                    builder: (context, controller,
                                                        offset) {
                                                      return NotificationListener<
                                                          OverscrollIndicatorNotification>(
                                                        onNotification:
                                                            (OverscrollIndicatorNotification
                                                                notification) {
                                                          notification
                                                              .disallowIndicator();
                                                          return false;
                                                        },
                                                        child: food_option(
                                                            indexs: clickedId,
                                                            meal: _dataKios.mealNames[clickedId],
                                                            mealname : mealNameID.toString(),//mealNameEN,
                                                            cat:_foodOptionController.namecat.value
                                                                ),
                                                              );
                                                            });
                                                          },
                                                            child: Container(
                                                            height: sizeHeight * 0.04, 
                                                            width: sizeWidth * 0.07, 
                                                            child: Stack(
                                                            alignment: Alignment.center,
                                                            children: [
                                                           // วงกลมสีแดง
                                                          Container(
                                                            width: sizeWidth * 0.055, 
                                                            height: sizeHeight * 0.055, 
                                                            decoration: BoxDecoration(
                                                            color: Color.fromRGBO(255, 0, 23, 1),
                                                            shape: BoxShape.circle, 
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.black.withOpacity(0.4),
                                                                spreadRadius: 1,
                                                                blurRadius: 4,
                                                                offset: Offset(3, 3)
                                                              )
                                                            ]
                                                            ),
                                                           ),
                                                         // รูปบวก
                                                         Icon(
                                                         Icons.add,
                                                          color: Colors.white, 
                                                          size: sizeHeight * 0.025, 
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                            ),
                                                                     
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: sizeWidth *0.18,),
                         Container(
                              color: Color.fromRGBO(216, 217, 218, 1),
                              width: sizeWidth * 0.8,
                              height: sizeHeight * 0.0008,
                            ),
                        ],
                    );
                  },
                ),         
         ),
    );
  }
}
