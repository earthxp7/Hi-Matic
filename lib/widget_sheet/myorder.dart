import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen/getxController.dart/amount_food.dart';
import 'package:screen/getxController.dart/textbox_controller.dart';
import '../UI/Font/ColorSet.dart';
import '../UI/Menu/total_in_widget.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/save_menu.dart';
import '../timeControl/adtime.dart';
import 'package:flutter/services.dart';

class MyOrder extends StatelessWidget {
  final amount_food _amount_food = Get.put(amount_food());
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final TextBoxExampleController textbox_controller =
      Get.put(TextBoxExampleController());
  final dataKios _dataKios = Get.put(dataKios());
  final String IndexOrder;
  MyOrder({
    this.IndexOrder,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final int admob_time = 30;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time));

    return GestureDetector(
        onTap: () {
          adtimeController.reset(); // Reset the time countdown
        },
        child: SingleChildScrollView(
            child: Container(
                height: sizeHeight * 0.7,
                width: sizeWidth * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Column(children: [
                  Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Row(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 340, right: 130, top: 80),
                              child: Text("รายการอาหารของฉัน",
                                  style: Fonts(
                                      context, 0.045, true, Colors.black)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 80, left: 30),
                            child: Container(
                              height: sizeHeight * 0.045,
                              width: sizeWidth * 0.1,
                              child: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: sizeWidth * 0.05,
                                ),
                                onPressed: () {
                                  String Back =
                                      'Go to menu page : ${_foodOptionController.formattedDate}';
                                  LogFile(Back);
                                  adtimeController.reset();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, left: 10),
                        child: Text("My Order",
                            style: Fonts(context, 0.035, false, Colors.black)),
                      ),
                      Obx(() => _foodOptionController.numorder.value <= 0
                          ? Container(
                              color: Colors.white,
                              height: sizeHeight * 0.4895,
                              child: Center(
                                child: Text('โปรดเลือกอาหารที่ท่านต้องการ',
                                    style: Fonts(context, 0.045, true,
                                        Color.fromARGB(255, 131, 129, 129))),
                              ),
                            )
                          : Container(
                              color: Colors.white,
                              height: sizeHeight * 0.4895,
                              child: Obx(
                                () => ListView.builder(
                                  itemCount:
                                      _foodOptionController.orders.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    int currentIndex =
                                        _foodOptionController.orders[index];
                                    double totalForIndex =
                                        _foodOptionController.calculateTotal(
                                            currentIndex,
                                            _foodOptionController
                                                .categoryValues[index]);

                                    final count = (_foodOptionController
                                                .categoryValues[index] ==
                                            'Steak')
                                        ? _foodOptionController
                                            .countListCat1[currentIndex]
                                        : (_foodOptionController
                                                    .categoryValues[index] ==
                                                'Drinks')
                                            ? _foodOptionController
                                                .countListCat2[currentIndex]
                                            : (_foodOptionController
                                                            .categoryValues[
                                                        index] ==
                                                    'Foods')
                                                ? _foodOptionController
                                                    .countListCat3[currentIndex]
                                                : (_foodOptionController
                                                                .categoryValues[
                                                            index] ==
                                                        'Noodles')
                                                    ? _foodOptionController
                                                            .countListCat4[
                                                        currentIndex]
                                                    : _foodOptionController
                                                            .countList[
                                                        currentIndex];
                                    final meal = (_foodOptionController
                                                .categoryValues[index] ==
                                            'Steak')
                                        ? _dataKios.steakList[currentIndex]
                                        : (_foodOptionController
                                                    .categoryValues[index] ==
                                                'Drinks')
                                            ? _dataKios.drinkList[currentIndex]
                                            : (_foodOptionController
                                                            .categoryValues[
                                                        index] ==
                                                    'Foods')
                                                ? _dataKios
                                                    .foodList[currentIndex]
                                                : (_foodOptionController
                                                                .categoryValues[
                                                            index] ==
                                                        'Noodles')
                                                    ? _dataKios.noodleList[
                                                        currentIndex]
                                                    : _dataKios.coffeeList[
                                                        currentIndex];
                                    final mealId = meal.mealId;
                                    final mealNameTH = meal.mealNameTH;
                                    final mealNameEN = meal.mealNameEN;
                                    final mealImage = meal.mealImage;
                                    final mealDescriptionTH =
                                        meal.mealDescriptionTH;
                                    final mealDescriptionEN =
                                        meal.mealDescriptionEN;
                                    final mealPrice = meal.mealPrice;
                                    return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, bottom: 10),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 120, right: 10),
                                                  child: Container(
                                                      height: sizeHeight * 0.13,
                                                      width: sizeWidth * 0.22,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Image.file(
                                                          File(mealImage),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )),
                                                ),
                                                Container(
                                                  color: Colors.white,
                                                  height: sizeHeight * 0.18,
                                                  width: sizeWidth * 0.6,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 5,
                                                                left: 10,
                                                                top: 60),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: sizeWidth *
                                                                  0.47,
                                                              child: Text(
                                                                  (_dataKios.language
                                                                              .value ==
                                                                          'en')
                                                                      ? mealNameEN.length <=
                                                                              30
                                                                          ? mealNameEN
                                                                          : '${mealNameEN.substring(0, 25)}...'
                                                                      : mealNameTH.length <=
                                                                              30
                                                                          ? mealNameTH
                                                                          : '${mealNameTH.substring(0, 25)}...',
                                                                  style: Fonts(
                                                                      context,
                                                                      0.036,
                                                                      true,
                                                                      Colors
                                                                          .black)),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: IconButton(
                                                                icon: Icon(
                                                                  Icons
                                                                      .cancel_outlined,
                                                                  size:
                                                                      sizeWidth *
                                                                          0.045,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                onPressed: () {
                                                                  String
                                                                      delete =
                                                                      'Delete order : ${_foodOptionController.formattedDate}';
                                                                  LogFile(
                                                                      delete);
                                                                  adtimeController
                                                                      .reset();
                                                                  int removedIndex =
                                                                      currentIndex;

                                                                  double
                                                                      removedItemPrice =
                                                                      _foodOptionController.calculateTotal(
                                                                          currentIndex,
                                                                          _foodOptionController
                                                                              .categoryValues[index]);
                                                                  _foodOptionController
                                                                          .total_price
                                                                          .value -=
                                                                      removedItemPrice;
                                                                  int removedItemCount =
                                                                      count;
                                                                  _foodOptionController
                                                                          .numorder
                                                                          .value -=
                                                                      removedItemCount;
                                                                  _foodOptionController
                                                                      .orders
                                                                      .removeAt(
                                                                          index);
                                                                  _foodOptionController
                                                                      .categoryValues
                                                                      .removeAt(
                                                                          index);
                                                                  _foodOptionController
                                                                      .checkorders
                                                                      .removeAt(
                                                                          index);
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 80),
                                                        child: Container(
                                                          height: sizeHeight *
                                                              0.047,
                                                          width:
                                                              sizeWidth * 0.5,
                                                          child: Text(
                                                              (_dataKios.language
                                                                          .value ==
                                                                      'en')
                                                                  ? mealDescriptionEN
                                                                              .length <=
                                                                          35
                                                                      ? mealDescriptionEN
                                                                      : '${mealDescriptionEN.substring(0, 70)}...'
                                                                  : mealDescriptionTH
                                                                              .length <=
                                                                          35
                                                                      ? mealDescriptionTH
                                                                      : '${mealDescriptionTH.substring(0, 70)}...',
                                                              style: Fonts(
                                                                  context,
                                                                  0.024,
                                                                  false,
                                                                  Colors
                                                                      .black)),
                                                        ),
                                                      ),
                                                      Obx(
                                                        () => Container(
                                                          height: sizeHeight *
                                                              0.035,
                                                          child: Row(
                                                            children: [
                                                              //ลดจำนวนอาหาร
                                                              IconButton(
                                                                icon: Icon(
                                                                  Icons
                                                                      .remove_circle_outline,
                                                                  size:
                                                                      sizeWidth *
                                                                          0.04,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                onPressed: () {
                                                                  String
                                                                      remove =
                                                                      'Remove ${mealNameEN} -1(MyOrder) : ${_foodOptionController.formattedDate}';
                                                                  LogFile(
                                                                      remove);
                                                                  adtimeController
                                                                      .reset();
                                                                  _foodOptionController
                                                                      .numordercheck
                                                                      .value = true;
                                                                  _foodOptionController
                                                                      .removeCount
                                                                      .value++;

                                                                  double
                                                                      removedItemPrice =
                                                                      _foodOptionController.calculateTotal(
                                                                          currentIndex,
                                                                          _foodOptionController
                                                                              .categoryValues[index]);
                                                                  int counts = (_foodOptionController.categoryValues[
                                                                              index] ==
                                                                          'Steak')
                                                                      ? _foodOptionController
                                                                              .countListCat1[
                                                                          currentIndex]
                                                                      : (_foodOptionController.categoryValues[index] ==
                                                                              'Drinks')
                                                                          ? _foodOptionController
                                                                              .countListCat2[currentIndex]
                                                                          : (_foodOptionController.categoryValues[index] == 'Foods')
                                                                              ? _foodOptionController.countListCat3[currentIndex]
                                                                              : (_foodOptionController.categoryValues[index] == 'Noodles')
                                                                                  ? _foodOptionController.countListCat4[currentIndex]
                                                                                  : _foodOptionController.countList[currentIndex];
                                                                  int deleteItem =
                                                                      (removedItemPrice /
                                                                              counts)
                                                                          .toInt();
                                                                  //
                                                                  _foodOptionController
                                                                      .removeTotallist
                                                                      .add((deleteItem *
                                                                          _foodOptionController
                                                                              .removeCount
                                                                              .value));
                                                                  //
                                                                  _foodOptionController
                                                                      .removeTotal
                                                                      .value += _foodOptionController
                                                                          .removeTotallist[
                                                                      index];
                                                                  print(
                                                                      "removeTotal ${_foodOptionController.removeTotal.value}");
                                                                  print(
                                                                      "removeTotallist ${_foodOptionController.removeTotallist[index]}");
                                                                  //ลดจำนวนอาหารทีละ 1
                                                                  _foodOptionController.decrement(
                                                                      currentIndex,
                                                                      _foodOptionController
                                                                              .categoryValues[
                                                                          index]);

                                                                  if ((_foodOptionController.categoryValues[
                                                                              index] ==
                                                                          'Steak')
                                                                      ? _foodOptionController.countListCat1[
                                                                              currentIndex] <
                                                                          1
                                                                      : (_foodOptionController.categoryValues[index] ==
                                                                              'Drinks')
                                                                          ? _foodOptionController.countListCat2[currentIndex] <
                                                                              1
                                                                          : (_foodOptionController.categoryValues[index] == 'Foods')
                                                                              ? _foodOptionController.countListCat3[currentIndex] < 1
                                                                              : (_foodOptionController.categoryValues[index] == 'Noodles')
                                                                                  ? _foodOptionController.countListCat4[currentIndex] < 1
                                                                                  : _foodOptionController.countList[currentIndex] < 1) {
                                                                    _foodOptionController
                                                                        .orders
                                                                        .removeAt(
                                                                            index);
                                                                    _foodOptionController
                                                                        .categoryValues
                                                                        .removeAt(
                                                                            index);
                                                                    _foodOptionController
                                                                        .checkorders
                                                                        .removeAt(
                                                                            index);
                                                                  }

                                                                  //ลดราคาทีละ 1
                                                                  _foodOptionController
                                                                          .total_price
                                                                          .value -=
                                                                      deleteItem;

                                                                  //ลดจำนวนอาหารในตะกร้าทั้งหมด
                                                                  _foodOptionController
                                                                      .numorder--;

                                                                  print(
                                                                      'categoryValues${_foodOptionController.categoryValues}');
                                                                },
                                                              ),
                                                              //จำนวนอาหาร
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10),
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      sizeHeight *
                                                                          0.025,
                                                                  width:
                                                                      sizeWidth *
                                                                          0.07,
                                                                  color: Colors
                                                                      .white,
                                                                  child: Center(
                                                                    child: Text(
                                                                      "${_foodOptionController.countValue(currentIndex, _foodOptionController.categoryValues[index])}",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            sizeWidth *
                                                                                0.035,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              //เพิ่มจำนวนอาหาร
                                                              IconButton(
                                                                icon: Icon(
                                                                  Icons
                                                                      .add_circle_outline,
                                                                  size:
                                                                      sizeWidth *
                                                                          0.04,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                onPressed: () {
                                                                  String add =
                                                                      'Add ${mealNameEN} +1(MyOrder) : ${_foodOptionController.formattedDate}';
                                                                  LogFile(add);
                                                                  _foodOptionController
                                                                      .pushCount
                                                                      .value++;

                                                                  _foodOptionController
                                                                      .numordercheck
                                                                      .value = true;

                                                                  adtimeController
                                                                      .reset();
                                                                  int counts = (_foodOptionController.categoryValues[
                                                                              index] ==
                                                                          'Steak')
                                                                      ? _foodOptionController
                                                                              .countListCat1[
                                                                          currentIndex]
                                                                      : (_foodOptionController.categoryValues[index] ==
                                                                              'Drinks')
                                                                          ? _foodOptionController
                                                                              .countListCat2[currentIndex]
                                                                          : (_foodOptionController.categoryValues[index] == 'Foods')
                                                                              ? _foodOptionController.countListCat3[currentIndex]
                                                                              : (_foodOptionController.categoryValues[index] == 'Noodles')
                                                                                  ? _foodOptionController.countListCat4[currentIndex]
                                                                                  : _foodOptionController.countList[currentIndex];
                                                                  double
                                                                      plusItemPrice =
                                                                      _foodOptionController.calculateTotal(
                                                                          currentIndex,
                                                                          _foodOptionController
                                                                              .categoryValues[index]);
                                                                  int plusItem =
                                                                      (plusItemPrice /
                                                                              counts)
                                                                          //
                                                                          .toInt();
                                                                  _foodOptionController
                                                                      .pushTotallist
                                                                      .add((plusItem *
                                                                          _foodOptionController
                                                                              .pushCount
                                                                              .value));
                                                                  //
                                                                  _foodOptionController
                                                                          .pushTotal +=
                                                                      _foodOptionController
                                                                              .pushTotallist[
                                                                          index];
                                                                  print(
                                                                      "pushTotal ${_foodOptionController.pushTotal.value}");
                                                                  print(
                                                                      "pushTotallist ${_foodOptionController.pushTotallist[index]}");
                                                                  //เพิ่มจำนวนอาหารทีละ 1
                                                                  _foodOptionController.increment(
                                                                      currentIndex,
                                                                      _foodOptionController
                                                                              .categoryValues[
                                                                          index]);
                                                                  //เพิ่มราคาทีละ 1
                                                                  _foodOptionController
                                                                          .total_price
                                                                          .value +=
                                                                      plusItem;

                                                                  //เพิ่มจำนวนอาหารในตะกร้าทั้งหมด
                                                                  _foodOptionController
                                                                      .numorder++;
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Obx(() => Row(
                                                            children: [
                                                              SizedBox(
                                                                width:
                                                                    sizeWidth *
                                                                        0.01,
                                                              ),
                                                              Container(
                                                                height:
                                                                    sizeHeight *
                                                                        0.03,
                                                                width:
                                                                    sizeWidth *
                                                                        0.24,
                                                                child: Text(
                                                                    '฿ ${_foodOptionController.calculateTotal(currentIndex, _foodOptionController.categoryValues[index])}',
                                                                    style: Fonts(
                                                                        context,
                                                                        0.035,
                                                                        false,
                                                                        Colors
                                                                            .black)),
                                                              ),
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 120,
                                                  left: 120,
                                                  top: 10),
                                              child: Container(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                width: sizeWidth * 0.8,
                                                height: sizeHeight * 0.0008,
                                              ),
                                            ),
                                          ],
                                        ));
                                  },
                                ),
                              ),
                            ))
                    ]),
                    Container(
                      height: sizeHeight * 0.0795,
                      width: sizeWidth * 1,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 200, 194, 194),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25), // วงรีด้านบนซ้าย
                          topRight: Radius.circular(25), // วงรีด้านบนขวา
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                              height: sizeHeight * 0.2,
                              width: sizeWidth * 1,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 200, 194, 194),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0), // ซ้ายบน
                                  topRight: Radius.circular(20.0), // ขวาบน
                                ),
                              ),
                              child: TotalWiget()),
                        ],
                      ),
                    )
                  ])
                ]))));
  }
}
