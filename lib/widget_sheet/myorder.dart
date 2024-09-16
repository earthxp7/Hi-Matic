import 'dart:io';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen/getxController.dart/selection.dart';
import 'package:screen/getxController.dart/textbox_controller.dart';
import 'package:screen/widget_sheet/food_option.dart';
import '../UI/Font/ColorSet.dart';
import '../UI/Menu/total_in_widget.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/save_menu.dart';
import '../timeControl/adtime.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyOrder extends StatelessWidget {
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final TextBoxExampleController textbox_controller =
      Get.put(TextBoxExampleController());
  final dataKios _dataKios = Get.put(dataKios());
  final SelectionController selectionController =
      Get.put(SelectionController());
 var clickedId;
  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
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
            child: Column(children: [
              Column(children: [
                SizedBox( height: sizeHeight *0.025,),
                Row(
                    children: [
                      SizedBox( width: sizeWidth *0.3,),
                      Text("รายการอาหารของฉัน",
                              style: Fonts(context, 0.048, true, Colors.black)),
                      SizedBox(width:sizeWidth * 0.1),
                     Container(
                          height: sizeHeight * 0.05,
                          width: sizeWidth * 0.1,
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              size: sizeWidth * 0.07,
                            ),
                            onPressed: () {
                              String Back =
                                  'Go to menu page : ${_foodOptionController.formattedDate}';
                              LogFile(Back);
                              adtimeController.reset();
                              getMealNamesByCategoryName(
                             _foodOptionController.namecat.value);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                    
                    ],
                  
            ),
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15, left: 10),
                    child: Text("My Order",
                        style: Fonts(context, 0.035, false, Colors.black)),
                  ),
                  Obx(() => selectionController.countAll.value  < 1
                      ? Container(
                          color: Colors.white,
                          height: sizeHeight * 0.63,
                          child: Center(
                            child: Text(AppLocalizations.of(context)!.please_choose_food,
                                style: Fonts(context, 0.045, true,Color.fromARGB(255, 131, 129, 129))),
                          ),
                        )
                      : Container(
                          color: Colors.white,
                          height: sizeHeight * 0.63,
                          child: Obx(() {
                               return ListView.builder(
                            itemCount: selectionController.allMeals.length,
                            itemBuilder: (BuildContext context, int index) {
                              final meal = selectionController.allMeals[index];
                              final category = meal['category'];
                              final mealID = meal['mealId'];
                              final mealImage = meal['mealImage'];
                              final mealNameEN = meal['mealNameEN'];
                              final mealNameTH = meal['mealNameTH'];
                              final mealNameCN = meal['mealNameCN'];
                              final mealOptions = meal['mealoption'] ?? [];
                              final mealindexs = meal['mealindexs'];
                              final foodPrice = meal['foodPrice'];
                              final amount = meal['amount'];
                             
                              return 
                                  Column(
                                    children: [
                                      SizedBox(width:sizeWidth * 0.1),
                                      GestureDetector(
                                        onTap: () {
                                         getMealNamesByCategoryName(
                                         category);
                                          //LogFile(food);
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
                                                return NotificationListener<OverscrollIndicatorNotification>(
                                                  onNotification:(OverscrollIndicatorNotification notification) {
                                                    notification.disallowIndicator();
                                                    return false;
                                                  },
                                                  child: food_option(
                                                  indexs: mealindexs,
                                                  meal:_dataKios.mealNames[mealindexs],
                                                  mealname:mealID.toString(), //mealNameEN,
                                                  cat:category
                                                  ),
                                                );
                                              });
                                        },
                                     child:  Row(
                                        children: [
                                          SizedBox(width:sizeWidth * 0.11),
                                          Container(
                                                height: sizeHeight * 0.145,
                                                width: sizeWidth * 0.25,
                                                decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(sizeWidth *0.03),
                                               ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(sizeWidth*0.05),
                                                  child: Image.file(
                                                    File(mealImage),
                                                    fit: BoxFit.cover,
                                                  ),
                                                )),
                                       
                                          Container(
                                            height: sizeHeight * 0.18,
                                            width: sizeWidth * 0.6,
                                            child: Column(
                                              children: [
                                                  SizedBox(height:sizeHeight * 0.033),
                                                Row(
                                                    children: [
                                                      SizedBox(width:sizeWidth * 0.017),
                                                      Container(
                                                        width: sizeWidth * 0.47,
                                                        child: Text(
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
                                                            style: Fonts(context,0.038,true,Colors.black)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: sizeWidth *0.005,),
                                              Container(
                                              height: sizeHeight * 0.047,
                                              width: sizeWidth * 0.56,
                                              child: Text(
                                              _buildOptionsText(mealOptions),
                                              style: Fonts(context, 0.028, false, Colors.black),
                                                 ),
                                                ),
                                              
                                                Container(
                                                  height: sizeHeight * 0.06,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: sizeWidth*0.02,),
                                                      Container(
                                                            height: sizeHeight *0.7,
                                                            width: sizeWidth * 0.2, 
                                                            child: Align(
                                                              alignment: Alignment.bottomLeft,
                                                              child: Text(
                                                                  '${foodPrice} ฿',style: Fonts(context,0.04,true, Colors.black)),
                                                            ),
                                                          ),
                                                      Container(
                                                        height: sizeHeight *0.08,
                                                        width:  sizeWidth *0.35,
                                                        child: Row(
                                                          children: [
                                                              SizedBox(width: sizeWidth*0.015,),
                                                        Container(
                                                          height: sizeHeight *0.08,
                                                          width: sizeWidth *0.08,
                                                          child: Align(
                                                            alignment: Alignment.bottomCenter,
                                                            child:GestureDetector(
                                                           onTap: () {
                                                                int price = (foodPrice / amount).toInt();
                                                                String remove = 'Remove ${mealNameEN} -1(MyOrder) : ${_foodOptionController.formattedDate}';
                                                                LogFile(remove);
                                                                adtimeController.reset();
                                                                if (amount >
                                                                    1) {
                                                                      meal['foodPrice'] -= price;
                                                                      meal['amount']--;
                                                                      selectionController.allMeals[index] = meal;
                                                                      selectionController.countAll.value -= 1 ; 
                                                                      selectionController.totalprices.value -= price;
                                                                   //   selectionController.updateAmount(category,mealID.toString(), meal['amount'],meal['foodPrice']) ;
                                                                     //  print('ลดจำนวน : ${meal['amount']}');
                                                                }else{
                                                                  meal['foodPrice'] -= price;
                                                                  meal['amount']--;
                                                                  selectionController.allMeals[index] = meal;
                                                                  selectionController.countAll.value -= 1 ; 
                                                                  selectionController.totalprices.value -= price;
                                                                //  selectionController.updateAmount(category,mealID.toString(), meal['amount'],meal['foodPrice']) ;
                                                                  selectionController.deleteMealByConditions(mealID.toString());
                                                                  selectionController.deleteMealByCondition(mealID.toString());
                                                                }                           
                                                              },
                                                            child: Container(
                                                              height: sizeHeight * 0.04, 
                                                              width: sizeWidth * 0.07, 
                                                                child: Stack(
                                                                alignment: Alignment.center,
                                                                children: [
                                                          
                                                          Container(
                                                            width: sizeWidth * 0.055, 
                                                            height: sizeHeight * 0.055, 
                                                            decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape.circle, 
                                                              border: Border.all(
                                                              color: Color.fromRGBO(160, 161, 163, 1), 
                                                              width: 4.0, // ความกว้างของขอบ
                                                          ),
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
                                                         Icon(
                                                         Icons.remove,
                                                          color: Color.fromRGBO(160, 161, 163, 1), 
                                                          size: sizeHeight * 0.025, 
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                            ),
                                                          ),
                                                        ),
                                                        //จำนวนอาหาร
                                                        Container(
                                                            height: sizeHeight *0.08,
                                                            width:
                                                                sizeWidth * 0.07,
                                                            color: Colors.white,
                                                            child: Align(
                                                              alignment: Alignment.bottomCenter,
                                                                child:Text("${meal['amount']}",style: Fonts(context,0.038,true,Colors.black)
                                                                    )),
                                                          ),
                                                        
                                                        //เพิ่มจำนวนอาหาร
                                                        Container(
                                                          height: sizeHeight *0.08,
                                                          width: sizeWidth *0.08,
                                                          child: Align(
                                                            alignment: Alignment.bottomCenter,
                                                            child:GestureDetector(
                                                            onTap: () {
                                                                String add =
                                                                    'Add ${mealNameEN} +1(MyOrder) : ${_foodOptionController.formattedDate}';
                                                                LogFile(add);
                                                                  int price = (foodPrice / amount).toInt(); // แปลงเป็น int
                                                                      meal['foodPrice'] += price;
                                                                      meal['amount']++;
                                                                      selectionController.allMeals[index] = meal; 
                                                                      selectionController.countAll.value += 1 ; 
                                                                      selectionController.totalprices.value += price;           
                                                                 //     selectionController.updateAmount(category,mealID.toString(), meal['amount'],meal['foodPrice']) ;
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
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox( width: sizeWidth * 0.015,),
                                                    Container(
                                                      height: sizeHeight *0.08,
                                                      width: sizeWidth *0.087,
                                                      //color: Colors.blue,
                                                      child: GestureDetector(
                                                      onTap: () {
                                                            String delete = 'Delete order : ${_foodOptionController.formattedDate}';
                                                          LogFile(delete);
                                                          selectionController.countAll.value -= (meal['amount'] as int);
                                                          selectionController.totalPrice.value -=  (meal['foodPrice'] as int);
                                                          selectionController.deleteMealByConditions(mealID.toString());
                                                          selectionController.deleteMealByCondition(mealID.toString());
                                                          adtimeController.reset();
                                                        },
                                                        child: Align(
                                                          alignment: Alignment.bottomCenter,
                                                          child: Image.asset('assets/Remove.png'),
                                                        ) ,
                                                      ) )
                                                        ],
                                                        ),
                                                      ),
                                              ]),
                                               
                                            )],
                                            ),
                                          ),
                                        ],
                                      ),
                                      ),
                                       SizedBox(width: sizeWidth *0.18,),
                                       Container(
                                        color: Colors.black,
                                        width: sizeWidth * 0.8,
                                        height: sizeHeight * 0.0008,
                                      ),
                                    ],
                                  );
                            },
                          );
                      }   ))
              )]),
              SizedBox(
                height: sizeHeight *0.025,
              ),
                TotalWiget(),
              ])
            ])));
  }
}

String _buildOptionsText(List<Map<String, dynamic>> mealOptions) {
 final dataKios _dataKios = Get.put(dataKios());
 if (mealOptions == null || mealOptions.isEmpty) {
    return '...';
  }

  // แยกค่า 'Extra' หรือ 'พิเศษ' ออกจากค่าที่เหลือ
  final regularOptions = <String>[];
  final specialOptions = <String>[];

  for (final option in mealOptions) {
    final value = option['value'] ?? '';

    // ตรวจสอบว่าค่า value เป็น Map<String, dynamic>
    if (value is Map<String, dynamic>) {
      // ใช้ค่าจากภาษาไทยหรือภาษาอื่น ๆ ตามต้องการ
      final displayValue =   (_dataKios.language.value == 'en') ? value['en'] :(_dataKios.language.value == 'zh') ? value['cn'] :value['th'];
      
      if (displayValue == 'Extra' || displayValue == 'พิเศษ') {
        specialOptions.add('*$displayValue');
      } else {
        regularOptions.add(displayValue);
      }
    } else {
      // กรณีที่ value เป็น String ธรรมดา
      if (value == 'Extra' || value == 'พิเศษ') {
        specialOptions.add('*$value');
      } else {
        regularOptions.add(value);
      }
    }
  }

  // รวมค่าปกติและค่าพิเศษ
  final optionsText = [...regularOptions, ...specialOptions].join(' / ');

  return optionsText;
}


