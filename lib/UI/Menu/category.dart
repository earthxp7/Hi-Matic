import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen/timeControl/adtime.dart';

import '../../api/Kios_API.dart';
import '../../getxController.dart/save_menu.dart';

class categoryUI extends StatelessWidget {
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final dataKios _dataKios = Get.put(dataKios());
  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final int admob_time = 60;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time));
    return Container(
        height: sizeHeight * 0.15,
        child: ListView.builder(
          itemCount: _dataKios.CatList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            final categorie = _dataKios.CatList[index];
            final categoryId = categorie.categoryId;
            final categoryNameTH = categorie.categoryNameTH;
            final categoryNameEN = categorie.categoryNameEN;
            final categoryDescriptionTH = categorie.categoryDescriptionTH;
            final categoryDescriptionEN = categorie.categoryDescriptionEN;
            final categoryImage = categorie.categoryImage;
            final colorsCat = _foodOptionController.namecat.value ==
                    _dataKios.CatList[index].categoryNameEN
                ? Colors.black
                : Colors.white;
            final colorsCatselect = _foodOptionController.namecat.value ==
                    _dataKios.CatList[index].categoryNameEN
                ? Color.fromRGBO(255, 152, 0, 1)
                : Colors.black;

            return Padding(
              padding: EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: () async {
                  String Category =
                      'Food category ${categoryNameEN} : ${_foodOptionController.formattedDate}';
                  LogFile(Category);
                  _foodOptionController.tapCount.value = 0;
                  _foodOptionController.namecat.value =
                      _dataKios.CatList[index].categoryNameEN;
                  print('Cat ${_foodOptionController.namecat.value}');
                  adtimeController.reset();
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.file(
                          File(categoryImage),
                          height: sizeHeight * 0.08,
                          width: sizeWidth * 0.2,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Obx(
                      () => AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: _foodOptionController.namecat.value ==
                                  _dataKios.CatList[index].categoryNameEN
                              ? Color.fromRGBO(255, 152, 0, 1)
                              : Colors.black,
                          borderRadius:
                              BorderRadius.circular(sizeHeight * 0.05),
                          border: Border.all(
                            color: Colors.transparent,
                            width: 2.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            (_dataKios.language.value == 'en')
                                ? categoryNameEN
                                : categoryNameTH,
                            style: TextStyle(
                              fontSize: sizeWidth * 0.032,
                              fontFamily: 'SukhumvitSet-Medium',
                              color: _foodOptionController.namecat.value ==
                                      _dataKios.CatList[index].categoryNameEN
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                        height: sizeHeight * 0.03,
                        width: sizeWidth * 0.25,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
