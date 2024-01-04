import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen/getxController.dart/save_menu.dart';
import '../../api/Kios_API.dart';
import '../../timeControl/adtime.dart';
import '../../widget_sheet/food_option.dart';

class menuUI extends StatelessWidget {
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final dataKios _dataKios = Get.put(dataKios());
  int clickedId = null;

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final int admob_time = 60;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time));
    final DateLog = _foodOptionController.formattedDate;
    String food = 'Open the food options page : ${DateLog}';
    return Container(
        color: Colors.white,
        height: sizeHeight * 0.67,
        child: Obx(
          () => ListView.builder(
            itemCount: (_foodOptionController.namecat.value == 'Steak')
                ? _dataKios.steakList.length
                : (_foodOptionController.namecat.value == 'Drinks')
                    ? _dataKios.drinkList.length
                    : (_foodOptionController.namecat.value == 'Foods')
                        ? _dataKios.foodList.length
                        : (_foodOptionController.namecat.value == 'Noodles')
                            ? _dataKios.noodleList.length
                            : _dataKios.coffeeList.length,
            itemBuilder: (BuildContext context, int index) {
              final meal = (_foodOptionController.namecat.value == 'Steak')
                  ? _dataKios.steakList[index]
                  : (_foodOptionController.namecat.value == 'Drinks')
                      ? _dataKios.drinkList[index]
                      : (_foodOptionController.namecat.value == 'Foods')
                          ? _dataKios.foodList[index]
                          : (_foodOptionController.namecat.value == 'Noodles')
                              ? _dataKios.noodleList[index]
                              : _dataKios.coffeeList[index];

              final mealId = meal.mealId;
              final mealNameTH = meal.mealNameTH;
              final mealNameEN = meal.mealNameEN;
              final mealImage = meal.mealImage;
              final mealDescriptionTH = meal.mealDescriptionTH;
              final mealDescriptionEN = meal.mealDescriptionEN;
              final mealPrice = meal.mealPrice;

              return Padding(
                padding: const EdgeInsets.only(left: 150, right: 50),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: sizeHeight * 0.13,
                          width: sizeWidth * 0.22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: GestureDetector(
                                  onTap: () {
                                    LogFile(food);
                                    _foodOptionController.tapCount.value = 0;
                                    adtimeController.reset();
                                    clickedId = index;
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        isDismissible: false,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                        ),
                                        builder: (context) {
                                          return NotificationListener<
                                              OverscrollIndicatorNotification>(
                                            onNotification:
                                                (OverscrollIndicatorNotification
                                                    notification) {
                                              notification.disallowIndicator();
                                              return false;
                                            },
                                            child: food_option(
                                              clickedId,
                                              _foodOptionController
                                                  .namecat.value,
                                              currentIndex: clickedId,
                                              category: _foodOptionController
                                                  .namecat.value,
                                            ),
                                          );
                                        });
                                  },
                                  child: Image.file(
                                    File(mealImage),
                                    fit: BoxFit.cover,
                                  ))),
                        ),
                        Container(
                          color: Colors.white,
                          height: sizeHeight * 0.18,
                          width: sizeWidth * 0.56,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: Container(
                                  height: sizeHeight * 0.03,
                                  width: sizeWidth * 0.5,
                                  color: Colors.white,
                                  child: GestureDetector(
                                    onTap: () {
                                      LogFile(food);
                                      _foodOptionController.tapCount.value = 0;
                                      adtimeController.reset();
                                      clickedId = index;
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          isDismissible: false,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          builder: (context) {
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
                                                clickedId,
                                                _foodOptionController
                                                    .namecat.value,
                                                currentIndex: clickedId,
                                                category: _foodOptionController
                                                    .namecat.value,
                                              ),
                                            );
                                          });
                                    },
                                    child: Obx(() => Text(
                                          (_dataKios.language.value == 'en')
                                              ? mealNameEN.length <= 40
                                                  ? mealNameEN
                                                  : '${mealNameEN.substring(0, 70)}...'
                                              : mealNameTH.length <= 40
                                                  ? mealNameTH
                                                  : '${mealNameTH.substring(0, 70)}...',
                                          style: TextStyle(
                                              fontSize: sizeWidth * 0.036,
                                              fontFamily: 'SukhumvitSet-Medium',
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                ),
                              ),
                              Container(
                                height: sizeHeight * 0.044,
                                width: sizeWidth * 0.5,
                                child: Obx(() => Text(
                                      (_dataKios.language.value == 'en')
                                          ? mealDescriptionEN.length <= 40
                                              ? mealDescriptionEN
                                              : '${mealDescriptionEN.substring(0, 70)}...'
                                          : mealDescriptionTH.length <= 40
                                              ? mealDescriptionTH
                                              : '${mealDescriptionTH.substring(0, 70)}...',
                                      style: TextStyle(
                                        fontSize: sizeWidth * 0.024,
                                        fontFamily: 'SukhumvitSet-Medium',
                                      ),
                                    )),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 70, left: 30),
                                    child: Container(
                                      height: sizeHeight * 0.04,
                                      width: sizeWidth * 0.35,
                                      child: Text(
                                        '฿ ' + mealPrice.toString(),
                                        style: TextStyle(
                                          fontSize: sizeWidth * 0.035,
                                          fontFamily: 'SukhumvitSet-Medium',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Transform.translate(
                                      offset: Offset(70.0, 35.0),
                                      child: Builder(
                                        builder: (context) => GestureDetector(
                                            onTap: () {
                                              LogFile(food);
                                              _foodOptionController
                                                  .tapCount.value = 0;
                                              adtimeController.reset();
                                              clickedId = index;
                                              showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  isDismissible: false,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      top: Radius.circular(20),
                                                    ),
                                                  ),
                                                  builder: (context) {
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
                                                        clickedId,
                                                        _foodOptionController
                                                            .namecat.value,
                                                        currentIndex: clickedId,
                                                        category:
                                                            _foodOptionController
                                                                .namecat.value,
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: Container(
                                              height: sizeHeight * 0.04,
                                              width: sizeWidth * 0.07,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons
                                                      .add_circle_outline_outlined,
                                                  size: sizeHeight * 0.032,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 100),
                      child: Container(
                        color: Color.fromARGB(255, 0, 0, 0),
                        width: sizeWidth * 0.8,
                        height: sizeHeight * 0.0008,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
