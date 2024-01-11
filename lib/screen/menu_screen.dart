import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Appbar/language.dart';
import '../UI/Menu/category.dart';
import '../UI/Menu/logo_bar.dart';
import '../UI/Menu/menu.dart';
import '../UI/Menu/total.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/amount_food.dart';
import '../getxController.dart/save_menu.dart';
import '../timeControl/adtime.dart';
import '../widget_sheet/myorder.dart';
import '../widget_sheet/payment_option.dart';
import '../widget_sheet/food_option.dart';
import 'package:flutter/services.dart';

import '../widget_sheet/successful_payment.dart';

class menu_screen extends StatelessWidget {
  final String foodOptionCategory;

  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  int clickedId = null;
  final int IndexOrder;
  menu_screen({this.IndexOrder, this.foodOptionCategory});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final int admob_time = 60;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time));
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification notification) {
              notification.disallowIndicator();
              return false;
            },
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      adtimeController.reset();
                      _foodOptionController.tapCount.value = 0;
                    },
                    child: Container(
                      height: sizeHeight * 0.045,
                      width: sizeWidth * 1,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(sizeWidth * 0.01),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: languageBar(),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      adtimeController.reset();
                      _foodOptionController.tapCount.value = 0;
                    },
                    child: Container(
                      color: Color.fromRGBO(245, 245, 245, 1),
                      height: sizeHeight * 0.21,
                      width: sizeWidth * 1,
                      child: Column(
                        children: [
                          logoUI(),
                          categoryUI(),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        adtimeController.reset();
                        _foodOptionController.tapCount.value = 0;
                      },
                      child: menuUI()),
                  GestureDetector(
                      onTap: () {
                        adtimeController.reset();
                        _foodOptionController.tapCount.value = 0;
                      },
                      child: totalUI())
                ],
              ),
            )));
  }
}
