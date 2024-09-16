import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen/timeControl/adtime.dart';
import '../../api/Kios_API.dart';
import '../../getxController.dart/save_menu.dart';

class categoryUI extends StatelessWidget {
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final dataKios _dataKios = Get.put(dataKios());
  final int come = 0;

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final int admob_time = 60;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time: admob_time));
    final categories = _dataKios.categoryList;
    return Column(
      children: [
        Container(
          height: sizeHeight * 0.1,
          width: sizeWidth * 1,
          /*decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), // การทำมุมโค้ง (ปรับตามต้องการ)
          border: Border.all(
          color: Colors.black, // สีของขอบ
          width: 1, // ความหนาของขอบ
            ),
         ),*/
          child: Image.asset(
          'assets/banner.png',
         // alignment: Alignment.center,
          fit: BoxFit.cover,
          )/*Obx(() =>Image.file(
                File(categories[_foodOptionController.tapIndex.value]
                    .categoryImage),
                fit: BoxFit.contain,
              )),*/
        ),
        Container(
          height: sizeHeight * 0.07,
          child: ListView.builder(
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              final categorie = categories[index];
              final categoryNameTH = categorie.categoryName['th'] ?? '';
              final categoryNameEN = categorie.categoryName['en'] ?? '';
              final categoryNameCN = categorie.categoryName['cn'] ?? '';
             
              return Padding(
                padding: EdgeInsets.only(left: sizeWidth * 0.022),
                child: GestureDetector(
                  onTap: () async {
                    String Category =
                        'Food category ${categoryNameEN} : ${_foodOptionController.formattedDate}';
                    LogFile(Category);
                    _foodOptionController.tapCount.value = 0;
                    _foodOptionController.tapIndex.value = index;
                    _foodOptionController.namecat.value = categoryNameEN;
                    adtimeController.reset();
                    getMealNamesByCategoryName(
                        _foodOptionController.namecat.value);
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: sizeHeight * 0.025,
                      ),
                      Obx(
                        () => AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: _foodOptionController.namecat.value ==
                                    categoryNameEN
                                ? Color.fromRGBO(255, 0, 3, 1)
                               : _foodOptionController.namecat.value ==
                                    categoryNameCN
                                ? Color.fromRGBO(255, 0, 3, 1)
                                : Colors.white,
                            borderRadius:
                                BorderRadius.circular(sizeHeight * 0.05),
                            border: Border.all(
                              color: Colors.transparent,
                              width: 2.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.2), // ความเข้มของเงา
                                offset: Offset(4,
                                    4), // เลื่อนเงาไปในแนว x และ y (ขวาและล่าง)
                                blurRadius: 8, // เบลอของเงา
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              (_dataKios.language.value == 'en')
                                  ? categoryNameEN
                                : (_dataKios.language.value == 'zh')    
                                  ? categoryNameCN
                                  : categoryNameTH,
                              style: TextStyle(
                                fontSize: sizeWidth * 0.032,
                                fontFamily: 'SukhumvitSet-Medium',
                                color: _foodOptionController.namecat.value ==
                                        categoryNameEN
                                    ? Colors.white
                                   : _foodOptionController.namecat.value ==
                                        categoryNameCN
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          height: sizeHeight * 0.038,
                          width: sizeWidth * 0.24,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
