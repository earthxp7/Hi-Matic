import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen/getxController.dart/selection.dart';
import 'package:screen/screen/selection_screen.dart';
import '../UI/Font/ColorSet.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/save_menu.dart';
import '../getxController.dart/textbox_controller.dart';
import '../timeControl/adtime.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class food_option extends StatelessWidget {
  final Map<String, String> meal;
  final SelectionController selectionController = Get.put(SelectionController());
  final TextBoxExampleController textbox_controller = Get.put(TextBoxExampleController());
  final FoodOptionController _foodOptionController = Get.put(FoodOptionController());
  final dataKios _dataKios = Get.put(dataKios());    
  food_option({
    required this.indexs,
    required this.meal,
    required this.mealname,
    required this.cat,
  });
  var mealname;
  var cat;
  var indexs;
  final int admob_time = 30;
  final count = 1;
  @override
  Widget build(BuildContext context) {
    List<Map<dynamic, dynamic>> mealOptions;
    final mealsId = meal['id'] ?? '';
    final mealImage = meal['image'] ?? '';
    final mealNameTH = meal['name_th'] ?? '';
    final mealNameEN = meal['name_en'] ?? '';
    final mealNameCN = meal['name_cn'] ?? '';
    final mealDescriptionTH = meal['description_th'] ?? '';
    final mealDescriptionEN = meal['description_en'] ?? '';
    final mealDescriptionCN = meal['description_cn'] ?? '';
    final mealPrice = int.tryParse(meal['price'] ?? '0') ?? 0;
    final mealOptionsString = meal['mealOptions'] ?? '[]';
    
    //print('mealOptionsString : ${mealOptionsString}');
    try {
      final decodedOptions = jsonDecode(mealOptionsString) as List<dynamic>;
      mealOptions = decodedOptions.cast<Map<dynamic, dynamic>>();
      //print('Decoded mealOptions: $mealOptions');
    } catch (e) {
      mealOptions = [];
      //print('Error decoding mealOptions: $e');
    }
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final AdMobTimeController adtimeController = Get.put(AdMobTimeController(admob_time: admob_time));

    var Test = <String, dynamic>{}; 
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return GestureDetector(
      onTap: () {
        adtimeController.reset();
      },
      child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(height: sizeHeight *0.05,),
                 Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: sizeWidth *0.11,),
                     Container(
                      height: sizeHeight * 0.2,
                      width: sizeWidth * 0.4,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sizeWidth * 0.05),
                       ),
                      child: ClipRRect(
                      borderRadius: BorderRadius.circular(sizeWidth * 0.05),
                      child: Image.file(
                      File(mealImage),
                      fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(sizeWidth * 0.11, sizeHeight * -0.085),
                        child: Container(
                          height: sizeHeight * 0.05,
                          width: sizeWidth * 0.1,
                          child: IconButton(
                            icon: Icon(Icons.close, size: sizeWidth * 0.07),
                            onPressed: () {
                              adtimeController.reset();
                              // final check = selectionController.selectedValues[Category]![mealNameEN]!['Choose']
                              String Back =
                                  'Go to menu page : ${_foodOptionController.formattedDate}';
                              LogFile(Back);
                              /*     if(selectionController.selectedValues[Category]![mealNameEN]!['Choose'] != true){
                              selectionController.updateFood(Category,  mealNameEN , false);
                              }*/
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                 SizedBox(
                      height: sizeHeight * 0.01,
                    ),
                Container(
                  child: Text(
                    (_dataKios.language.value == 'en')
                        ? mealNameEN
                       : (_dataKios.language.value == 'zh')
                          ? mealNameCN
                          : mealNameTH,
                    style: TextStyle(
                      fontSize: sizeWidth * 0.045,
                      fontFamily: 'SukhumvitSet-Medium',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                 SizedBox(
                      height: sizeHeight * 0.01,
                    ),
                Container(
                  width: sizeWidth *0.8,
                  child: Text(
                        (_dataKios.language.value == 'en')
                            ? mealDescriptionEN
                             : (_dataKios.language.value == 'zh')
                            ? mealDescriptionCN
                            : mealDescriptionTH,
                        style: Fonts(context, 0.025, false, Colors.black)),
                ),
                SizedBox(
                      height: sizeHeight * 0.02,
                    ),
                 Container(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: sizeWidth * 0.8,
                    height: sizeHeight * 0.0008,
                  ),
                   SizedBox(
                      height: sizeHeight * 0.02,
                    ),
                Column(
                  children: [
                    Container(
                      width: sizeWidth * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: mealOptions.length,
                        itemBuilder: (BuildContext context, int index) {
                          final mealOption = mealOptions[index];
                          final mealDetail = mealOption['mealDetails'] as Map<String, dynamic>;       
                          mealDetail.forEach((key, value) {
                          Test[key] = value; // เพิ่มข้อมูลจาก mealDetail เข้าไปใน Test
                       
                          });
                          final mealDetailsTH = mealOption['mealDetails']['th'] ?? '';
                          final mealDetailsEN = mealOption['mealDetails']['en'] ?? '';
                          final mealDetailsCN = mealOption['mealDetails']['cn'] ?? '';
                          final mealDetails = ( _dataKios.language.value == 'en')
                                                  ? mealDetailsEN 
                                                  : (_dataKios.language.value == 'zh'
                                                      ? mealDetailsCN
                                                       : mealDetailsTH);
                          final bool multipleSelect = mealOption['multipleSelect'] ?? false;
                          final bool forcedChoice = mealOption['forcedChoice'] ?? false;
                          final List<Map<String, dynamic>> options = List<Map<String, dynamic>>.from(mealOption['option'] ?? []);    
                         // final options = mealOption['option'] as List<dynamic>;
                          final forcetext = forcedChoice == true ? '*' : '';
                          
                          return Container(
                            width: sizeWidth * 0.8,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "$forcetext $mealDetails",
                                    style: Fonts(context, 0.033, true, Colors.black),
                                  ),
                                ),
                              Column(
                                  children:options.map<Widget>((option) {
                                      final nameS = option['name'] as Map<String, dynamic>;
                                      final nameTH = option['name']['th'] ?? '';
                                      final nameEN = option['name']['en'] ?? '';
                                      final nameCN = option['name']['cn'] ?? '';
                                      final price = option['price'] ?? 0;
                                      final name = (_dataKios.language.value == 'en')
                                                      ? nameEN
                                                      : (_dataKios.language.value == 'zh')
                                                        ? nameCN
                                                        : nameTH;
                                      return multipleSelect
                                        ? ListTile(
                                            leading: Transform.scale(
                                            scale: 2.0,
                                            child: Obx(() {
                                                final valuesList = selectionController.selectedValues[cat]?[mealname]?['mealoption']?[mealDetails]?['values'] as List<Map<String, dynamic>>? ?? [];
                                                final isSelected = valuesList.any((map) => mapEquals(map, nameS));
                                             
                                             if (forcedChoice == true) {
                                                if (valuesList.isNotEmpty) {
                                                selectionController.forced_choice(cat, mealname, true, mealDetails);
                                                 } else {
                                                 selectionController.forced_choice(cat, mealname, false, mealDetails);
                                               }
                                               } else {
                                              selectionController.forced_choice(cat, mealname, true, mealDetails);
                                              }

                                              return Checkbox(
                                              value: isSelected,
                                              onChanged: (bool? value) {
                                           // print('nameS ${nameS}');
                                              selectionController.updateMultipleSelection(cat, mealname, mealDetail, nameS, value == true, price, mealPrice);
                                              },
                                              activeColor: Colors.black, 
                                              checkColor: Colors.white,
                                                );
                                              }),
                                              ),
                                            title: Row(
                                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    final valuesList = selectionController.selectedValues[cat]?[mealname]?['mealoption']?[mealDetails]?['values'] as List<Map<String, dynamic>>? ??[];
                                                    final isSelected = valuesList.contains(name);
                                                    selectionController.updateMultipleSelection(cat,mealname,mealDetail,nameS,!isSelected,price,mealPrice);
                                                  },
                                                  child: Text(
                                                    name,
                                                    style: Fonts(context, 0.030,false,Colors.black),
                                                  ),
                                                ),
                                                 Text(
                                                    '${price} ฿',
                                                     style: Fonts(context, 0.032,true, Colors.black),
                                                ),
                                              ],
                                            ),
                                          )
                                        : ListTile(
                                            title: Row(
                                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Transform.scale(
                                                      scale: 2.0,
                                                      child: Obx(() {
                                                       final valuesList = selectionController.selectedValues[cat]?[mealname]?['mealoption']?[mealDetails]?['values'] as List<Map<String, dynamic>>? ?? [];
                                                       final isSelected = valuesList.any((map) => mapEquals(map, nameS));
                                                        if (forcedChoice == true) {
                                                          if (valuesList.isNotEmpty) {
                                                            selectionController.forced_choice(cat,mealname,true,mealDetailsEN);
                                                          } else {
                                                            selectionController.forced_choice(cat,mealname,false,mealDetailsEN);
                                                          }
                                                        } else {
                                                          selectionController.forced_choice(cat,mealname,true,mealDetailsEN);
                                                        }

                                                        return Radio<String?>(
                                                          value: name,
                                                          activeColor: Colors.black, 
                                                          groupValue :isSelected ?  name : null,
                                                          onChanged: (value) {
                                                            selectionController.updateSingleSelection(cat,mealname,mealDetail,nameS,price,mealPrice);
                                                          },
                                                        );
                                                      }),
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            sizeWidth * 0.01),
                                                    GestureDetector(
                                                      onTap: () {
                                                        selectionController.updateSingleSelection(cat,mealname,mealDetail,nameS,price,mealPrice);
                                                      },
                                                      child: Text(
                                                        name, style: Fonts(context, 0.030,false,Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                    '${price} ฿', style: Fonts(context, 0.032,true, Colors.black),
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              selectionController.updateSingleSelection(cat,mealname,mealDetail,nameS,price,mealPrice);
                                            },
                                          );
                                  }).toList(),
                                ),
                                SizedBox(
                                  height: sizeHeight*0.015,
                                ),
                                 Container(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    width: sizeWidth * 1,
                                    height: sizeHeight * 0.0008,
                                  ),
                                 SizedBox(
                                  height: sizeHeight*0.015,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
                 Row(
                   children: [
                     SizedBox(width: sizeWidth *0.11,),
                     Text(
                    '${AppLocalizations.of(context)!.note}', //'Note',
                     style: Fonts(context, 0.038, false, Colors.black)),
                   ],
                 ),
                    
                Column(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 30),
                        child: Obx(() => Container(
                              width: sizeWidth * 0.8,
                              decoration: BoxDecoration(
                              color: Colors.white, 
                              border: Border.all(
                              color: Colors.black, 
                              width: 2.5, 
                              ),
                             borderRadius: BorderRadius.circular(10), // มุมโค้งของ Container (ถ้าต้องการ)
                            ),
                              child: TextField(
                                style:
                                    Fonts(context, 0.035, false, Colors.black),
                                onChanged: (text) {
                                  selectionController.updateDetails(cat, mealname, text);
                                },
                                decoration: InputDecoration(
                                  labelText:'  ${AppLocalizations.of(context)!.ex}',
                                  labelStyle: Fonts(context, 0.035, false,
                                      Color.fromRGBO(214, 214, 214, 1)),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 60),
                                  
                                ),
                                controller: selectionController.getTextEditingController(cat, mealname),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: sizeHeight * 0.03,
                    ),
                  ],
                ),
                 Container(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: sizeWidth * 0.8,
                    height: sizeHeight * 0.0008,
                  ),
                
                Container(
                  width: sizeWidth * 0.8,
                  height: sizeHeight * 0.06,
                  child: Row(
                    children: [
                      SizedBox(width: sizeWidth *0.27,),
                      Container(
                        height: sizeHeight * 0.04,
                        width: sizeWidth * 0.08,
                        child: IconButton(
                          icon: Icon(
                            Icons.remove_circle_outline,
                            size: sizeWidth * 0.07,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            String remove =
                                'Remove ${mealname} -1 : ${_foodOptionController.formattedDate}';
                            LogFile(remove);
                            adtimeController.reset();
                            if (selectionController.foodAmount(cat, mealname) >
                                1) {
                              selectionController.reduceFood(
                                  cat, mealname);
                            }
                          },
                        ),
                      ),
                      Container(
                          height: sizeHeight * 0.05,
                          width: sizeWidth * 0.1,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Obx(() => Text(
                                  ("${selectionController.foodAmount(cat, mealname)}"),
                                  style: Fonts(
                                      context, 0.045, false, Colors.black),
                                )),
                          )),
                      Container(
                        height: sizeHeight * 0.04,
                        width: sizeWidth * 0.07,
                        child: IconButton(
                          icon: Icon(
                            Icons.add_circle_outline,
                            size: sizeWidth * 0.07,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            String add =
                                'Add ${mealname} +1 : ${_foodOptionController.formattedDate}';
                            LogFile(add);
                            adtimeController.reset();
                            selectionController.addFood(cat,mealname);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.03,
                ),
                Container(
                  width: sizeWidth * 0.8,
                  height: sizeHeight * 0.05,
                  child: ElevatedButton(
                    onPressed: () async {
                      adtimeController.reset();
                      if (selectionController.forcedchoice.value == false) {
                        selectionController.calculateTotalPriceForAll(cat, mealname, mealPrice,mealImage,mealNameTH,mealNameEN,mealNameCN,mealsId,mealOptionsString,indexs,Test);
                        await selectionController.updateFood(cat, mealname, true);
                        selectionController.getTotalAll(Test);
                        selectionController.getCountAll(Test);
                        final selectedMeals = selectionController.getAllFoods();
                        selectionController.allMeals.assignAll(selectedMeals);
                        Navigator.of(context).pop();
                      } else {
                        String failedOrder = 'Failed to add order : ${_foodOptionController.formattedDate}';
                        LogFile(failedOrder);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), 
                              ),
                              title: Text(
                                  AppLocalizations.of(context)!.important_details,
                                  style: Fonts(context, 0.035, true, Colors.red)),
                              content: Text(
                                  AppLocalizations.of(context)!.check_food_list,
                                  style: Fonts(context, 0.025, false, Colors.black)),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text( 
                                    AppLocalizations.of(context)!.agree,
                                    style: Fonts(context, 0.03, true, Colors.white)),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(50, 80),
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Color.fromRGBO(255, 0, 23, 1),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: sizeWidth * 0.35,
                            child: Text(
                              '${AppLocalizations.of(context)!.add_order}',
                              textAlign: TextAlign.left,
                              style: Fonts(context, 0.042, false, Colors.white),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: sizeWidth * 0.35,
                            child: Obx(() => Text(
                                  '${selectionController.calculateTotalPriceForMeal(cat,mealname, mealPrice,Test)} ฿',
                                  textAlign: TextAlign.right,
                                  style:
                                      Fonts(context, 0.042, false, Colors.white),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.05,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
