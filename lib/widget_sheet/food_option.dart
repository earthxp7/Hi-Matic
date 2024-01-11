import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen/screen/menu_screen.dart';
import '../UI/Font/ColorSet.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/amount_food.dart';
import '../getxController.dart/save_menu.dart';
import '../getxController.dart/textbox_controller.dart';
import '../timeControl/adtime.dart';
import 'package:flutter/services.dart';

class food_option extends StatelessWidget {
  final amount_food _amount_food = Get.put(amount_food());
  final TextBoxExampleController textbox_controller =
      Get.put(TextBoxExampleController());
  final Function(List<FoodItem>) onFoodItemUpdated;
  final int currentIndex;
  final int selectedImageIndex;
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final String category;

  food_option(int index, String c,
      {this.onFoodItemUpdated,
      this.currentIndex,
      this.selectedImageIndex,
      this.category});

  void onSave(BuildContext context, int index, String cat) {
    final FoodOptionController _foodOptionController =
        Get.put(FoodOptionController());
    final int counts = (cat == 'Steak')
        ? _foodOptionController.countListCat1[index]
        : (cat == 'Drinks')
            ? _foodOptionController.countListCat2[index]
            : (cat == 'Foods')
                ? _foodOptionController.countListCat3[index]
                : (cat == 'Noodles')
                    ? _foodOptionController.countListCat4[index]
                    : _foodOptionController.countList[index];
    final selectedFoodItemsList = (cat == 'Steak')
        ? _foodOptionController.selectedFoodItemsCat1
        : (cat == 'Drinks')
            ? _foodOptionController.selectedFoodItemsCat2
            : (cat == 'Foods')
                ? _foodOptionController.selectedFoodItemsCat3
                : (cat == 'Noodles')
                    ? _foodOptionController.selectedFoodItemsCat4
                    : _foodOptionController.selectedFoodItems;
    if (selectedFoodItemsList[index].selectedOption != null &&
        selectedFoodItemsList[index].selectedlevel != null &&
        counts > 0) {
      _foodOptionController.pushorder(currentIndex, category);
      String addOrder =
          'Successfully added order : ${_foodOptionController.formattedDate}';
      LogFile(addOrder);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => menu_screen(
                  IndexOrder: currentIndex,
                  foodOptionCategory: category,
                )),
      );
    } else {
      String failedOrder =
          'Failed to add order : ${_foodOptionController.formattedDate}';
      LogFile(failedOrder);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(16), // Adjust the radius as needed
            ),
            title: Text('กรุณาเลือกรายละเอียดอาหารให้ครบถ้วน',
                style: Fonts(context, 0.035, true, Colors.red)),
            content: Text(
                'ตรวจสอบข้อมูลอาหารของท่าน(เช่น เนื้อสัตว์ ระดับความเผ็ด)',
                style: Fonts(context, 0.025, false, Colors.black)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('ตกลง',
                    style: Fonts(context, 0.03, true, Colors.white)),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final selectExtra = (category == 'Steak')
        ? _foodOptionController.selectedSpecialStatesCat1
        : (category == 'Drinks')
            ? _foodOptionController.selectedSpecialStatesCat2
            : (category == 'Foods')
                ? _foodOptionController.selectedSpecialStatesCat3
                : (category == 'Noodles')
                    ? _foodOptionController.selectedSpecialStatesCat4
                    : _foodOptionController.selectedSpecialStates;
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final TextBoxExampleController textbox_controller =
        Get.put(TextBoxExampleController());
    final int admob_time = 30;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time));
    final dataKios _dataKios = Get.put(dataKios());
    final meal = (category == 'Steak')
        ? _dataKios.steakList[currentIndex]
        : (category == 'Drinks')
            ? _dataKios.drinkList[currentIndex]
            : (category == 'Foods')
                ? _dataKios.foodList[currentIndex]
                : (category == 'Noodles')
                    ? _dataKios.noodleList[currentIndex]
                    : _dataKios.coffeeList[currentIndex];
    final mealId = meal.mealId;
    final mealNameTH = meal.mealNameTH;
    final mealNameEN = meal.mealNameEN;
    final mealImage = meal.mealImage;
    final mealDescriptionTH = meal.mealDescriptionTH;
    final mealDescriptionEN = meal.mealDescriptionEN;
    final mealPrice = meal.mealPrice;
    final optioncategory = meal.optioncategory;
    final mealOptionsCatLength = meal.mealOptionsCatLength;
    final mealOptionsCat = meal.mealOptionsCat;
    final mealOption = meal.mealOptions;
    final mealOptionprice = meal.mealOptionprice;
    final mealOptionname = meal.mealOptionname;
    final mealOptionsCatIndex1 = mealOptionsCat[1];
    final multipleSelect = meal.multipleSelect;
    final forcedChoice = meal.forcedChoice;

    // เจาะ Index ของ option อาหาร
    final mealOptionIndex1 =
        mealOption.length > 1 ? mealOption[1] : {'mealDetails': ''};
    final optioncategoryIndex1 =
        mealOption.length > 1 ? mealOption[1]['mealDetails'] : '';
    final mealOptionIndex2 =
        mealOption.length > 2 ? mealOption[2] : {'mealDetails': ''};
    final optioncategoryIndex2 =
        mealOption.length > 2 ? mealOption[2]['mealDetails'] : '';
    final mealOptionIndex3 =
        mealOption.length > 3 ? mealOption[3] : {'mealDetails': ''};
    final optioncategoryIndex3 =
        mealOption.length > 3 ? mealOption[3]['mealDetails'] : '';
    final toping = mealOptionIndex1['option'];
    final topinglengths = (toping != null) ? toping.length : 0;
    //โค้ดชื่อไข่
    final optionKai = mealOption.length > 2 ? mealOption[2] : {};
    final kaiIndex = optionKai.containsKey('option') ? optionKai['option'] : [];
    final kai = kaiIndex.isNotEmpty ? kaiIndex[0] : {};
    final kainame = kai.containsKey('name') ? kai['name'] : '';
    final kaiprice =
        kai.containsKey('price') ? kai['price'].toDouble() : 0.toDouble();

    final kai1 = kaiIndex.isNotEmpty ? kaiIndex[1] : {};
    final kainame1 = kai1.containsKey('name') ? kai1['name'] : '';
    final kaiprice1 =
        kai1.containsKey('price') ? kai1['price'].toDouble() : 0.toDouble();

    final kai2 = kaiIndex.isNotEmpty ? kaiIndex[2] : {};
    final kainame2 = kai2.containsKey('name') ? kai2['name'] : '';
    final kaiprice2 =
        kai2.containsKey('price') ? kai2['price'].toDouble() : 0.toDouble();
    //โค้ดพิเศษ
    final optionspecial = mealOption.length > 3 ? mealOption[3] : {};
    final specialIndex =
        optionspecial.containsKey('option') ? optionspecial['option'] : [];
    final selectedspecial = specialIndex.isNotEmpty ? specialIndex[0] : {};
    final selectedname =
        selectedspecial.containsKey('name') ? selectedspecial['name'] : '';
    final specialprice = selectedspecial.containsKey('price')
        ? selectedspecial['price'].toDouble()
        : 0.toDouble();

    return GestureDetector(
        onTap: () {
          adtimeController.reset(); // Reset the time countdown
        },
        child: FractionallySizedBox(
            heightFactor: 0.8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: ListView(children: [
                Column(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 100, left: 120, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: sizeHeight * 0.14,
                          width: sizeWidth * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(mealImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(200.0, -100.0),
                          child: Container(
                            child: Container(
                              height: sizeHeight * 0.05,
                              width: sizeWidth * 0.1,
                              child: IconButton(
                                icon: Icon(Icons.close, size: sizeWidth * 0.05),
                                onPressed: () {
                                  adtimeController.reset();
                                  String Back =
                                      'Go to menu page : ${_foodOptionController.formattedDate}';
                                  LogFile(Back);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => menu_screen(
                                              IndexOrder: currentIndex,
                                              foodOptionCategory: category,
                                            )),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Text(
                      (_dataKios.language.value == 'en')
                          ? mealNameEN
                          : mealNameTH,
                      style: TextStyle(
                        fontSize: sizeWidth * 0.045,
                        fontFamily: 'SukhumvitSet-Medium',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 100, right: 100),
                    child: Text(
                        (_dataKios.language.value == 'en')
                            ? mealDescriptionEN
                            : mealDescriptionTH,
                        style: Fonts(context, 0.025, false, Colors.black)),
                  ),
                  (optioncategory != '')
                      ? Padding(
                          padding: const EdgeInsets.only(
                              right: 100, left: 100, top: 10, bottom: 10),
                          child: Container(
                            color: Color.fromARGB(255, 0, 0, 0),
                            width: sizeWidth * 0.8,
                            height: sizeHeight * 0.0008,
                          ),
                        )
                      : Container(),
                  (optioncategory != '')
                      ? Padding(
                          padding: const EdgeInsets.only(top: 30, left: 100),
                          child: Container(
                            width: sizeWidth * 1,
                            child: Text('* ${optioncategory}',
                                style:
                                    Fonts(context, 0.03, false, Colors.black)),
                          ),
                        )
                      : Container(),
                  GestureDetector(
                      onTap: () {
                        adtimeController.reset(); // Reset the time countdown
                      },
                      child: (optioncategory != '')
                          ? Container(
                              height: sizeHeight * 0.15,
                              width: sizeWidth * 1,
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: mealOptionsCatLength,
                                itemBuilder: (context, index) {
                                  final MealOptions = mealOptionsCat[index];
                                  final mealOptionname = MealOptions['name'];
                                  final mealOptionprice =
                                      MealOptions['price'].toDouble();

                                  return Transform.scale(
                                    scale: 1.5,
                                    child: Obx(() => RadioListTile(
                                          title: Row(
                                            children: [
                                              Text(mealOptionname,
                                                  style: Fonts(context, 0.02,
                                                      false, Colors.black)),
                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                      '฿ ${mealOptionprice}',
                                                      style: Fonts(
                                                          context,
                                                          0.02,
                                                          false,
                                                          Colors.black)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 250),
                                          value: mealOptionname,
                                          groupValue: (category == 'Steak')
                                              ? _foodOptionController
                                                  .selectedFoodItemsCat1[
                                                      currentIndex]
                                                  .selectedOption
                                              : (category == 'Drinks')
                                                  ? _foodOptionController
                                                      .selectedFoodItemsCat2[
                                                          currentIndex]
                                                      .selectedOption
                                                  : (category == 'Foods')
                                                      ? _foodOptionController
                                                          .selectedFoodItemsCat3[
                                                              currentIndex]
                                                          .selectedOption
                                                      : (category == 'Noodles')
                                                          ? _foodOptionController
                                                              .selectedFoodItemsCat4[
                                                                  currentIndex]
                                                              .selectedOption
                                                          : _foodOptionController
                                                              .selectedFoodItems[
                                                                  currentIndex]
                                                              .selectedOption,
                                          onChanged: (value) {
                                            String Meal =
                                                'Select ${mealOptionname} : ${_foodOptionController.formattedDate}';
                                            LogFile(Meal);
                                            adtimeController.reset();
                                            final selectedFoodItem = (category ==
                                                    'Steak')
                                                ? _foodOptionController
                                                        .selectedFoodItemsCat1[
                                                    currentIndex]
                                                : (category == 'Drinks')
                                                    ? _foodOptionController
                                                            .selectedFoodItemsCat2[
                                                        currentIndex]
                                                    : (category == 'Foods')
                                                        ? _foodOptionController
                                                                .selectedFoodItemsCat3[
                                                            currentIndex]
                                                        : (category ==
                                                                'Noodles')
                                                            ? _foodOptionController
                                                                    .selectedFoodItemsCat4[
                                                                currentIndex]
                                                            : _foodOptionController
                                                                    .selectedFoodItems[
                                                                currentIndex];
                                            selectedFoodItem.selectedOption =
                                                value;
                                            selectedFoodItem.price =
                                                mealOptionprice.toDouble();
                                            _foodOptionController
                                                .selectFoodItem(
                                                    selectedFoodItem,
                                                    currentIndex,
                                                    category);
                                          },
                                        )),
                                  );
                                },
                              ),
                            )
                          : Container()),
                  (optioncategoryIndex1 != '')
                      ? Padding(
                          padding: const EdgeInsets.only(
                              right: 100, left: 100, top: 30, bottom: 10),
                          child: Container(
                            color: Color.fromARGB(255, 0, 0, 0),
                            width: sizeWidth * 0.8,
                            height: sizeHeight * 0.0008,
                          ),
                        )
                      : Container(),
                  (optioncategoryIndex1 != '')
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: 30, right: 400, left: 100),
                          child: Container(
                            width: sizeWidth * 1,
                            child: Text('* ${optioncategoryIndex1}',
                                style:
                                    Fonts(context, 0.03, false, Colors.black)),
                          ),
                        )
                      : Container(),
                  GestureDetector(
                      onTap: () {
                        adtimeController.reset(); // Reset the time countdown
                      },
                      child: (optioncategoryIndex1 != '')
                          ? Container(
                              height: sizeHeight * 0.12,
                              width: sizeWidth * 1,
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: topinglengths,
                                itemBuilder: (context, index) {
                                  final mealOptionIndex2 = mealOption[1];
                                  final optioncategoryIndex2 =
                                      mealOptionIndex2['option'];
                                  final MealOptions =
                                      optioncategoryIndex2[index];
                                  final spicinessOptionname =
                                      MealOptions['name'];
                                  final mealOptionprices =
                                      MealOptions['price'].toDouble();

                                  return Transform.scale(
                                      scale: 1.5,
                                      child: Obx(
                                        () => RadioListTile(
                                          title: Row(
                                            children: [
                                              Text(spicinessOptionname,
                                                  style: Fonts(context, 0.02,
                                                      false, Colors.black)),
                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                      '฿ ${mealOptionprices}',
                                                      style: Fonts(
                                                          context,
                                                          0.02,
                                                          false,
                                                          Colors.black)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 250),
                                          value: spicinessOptionname,
                                          groupValue: (category == 'Steak')
                                              ? _foodOptionController
                                                  .selectedFoodItemsCat1[
                                                      currentIndex]
                                                  .selectedlevel
                                              : (category == 'Drinks')
                                                  ? _foodOptionController
                                                      .selectedFoodItemsCat2[
                                                          currentIndex]
                                                      .selectedlevel
                                                  : (category == 'Foods')
                                                      ? _foodOptionController
                                                          .selectedFoodItemsCat3[
                                                              currentIndex]
                                                          .selectedlevel
                                                      : (category == 'Noodles')
                                                          ? _foodOptionController
                                                              .selectedFoodItemsCat4[
                                                                  currentIndex]
                                                              .selectedlevel
                                                          : _foodOptionController
                                                              .selectedFoodItems[
                                                                  currentIndex]
                                                              .selectedlevel,
                                          onChanged: (value) {
                                            String Spiciness =
                                                'Select ${spicinessOptionname} : ${_foodOptionController.formattedDate}';
                                            LogFile(Spiciness);
                                            adtimeController.reset();
                                            final selectedlevelFoodItem = (category ==
                                                    'Steak')
                                                ? _foodOptionController
                                                        .selectedFoodItemsCat1[
                                                    currentIndex]
                                                : (category == 'Drinks')
                                                    ? _foodOptionController
                                                            .selectedFoodItemsCat2[
                                                        currentIndex]
                                                    : (category == 'Foods')
                                                        ? _foodOptionController
                                                                .selectedFoodItemsCat3[
                                                            currentIndex]
                                                        : (category ==
                                                                'Noodles')
                                                            ? _foodOptionController
                                                                    .selectedFoodItemsCat4[
                                                                currentIndex]
                                                            : _foodOptionController
                                                                    .selectedFoodItems[
                                                                currentIndex];
                                            selectedlevelFoodItem
                                                .selectedlevel = value;
                                            selectedlevelFoodItem.level =
                                                mealOptionprices.toDouble();
                                            _foodOptionController
                                                .selectOption_Spiciness(
                                                    selectedlevelFoodItem,
                                                    currentIndex,
                                                    category);
                                          },
                                        ),
                                      ));
                                },
                              ),
                            )
                          : Container()),
                  (optioncategoryIndex2 != '')
                      ? Padding(
                          padding: const EdgeInsets.only(
                              right: 100, left: 100, top: 30, bottom: 10),
                          child: Container(
                            color: Color.fromARGB(255, 0, 0, 0),
                            width: sizeWidth * 0.8,
                            height: sizeHeight * 0.0008,
                          ),
                        )
                      : Container(),
                  (optioncategoryIndex2 != '')
                      ? Padding(
                          padding: const EdgeInsets.only(top: 30, left: 110),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(optioncategoryIndex2,
                                style:
                                    Fonts(context, 0.03, false, Colors.black)),
                          ))
                      : Container(),
                  (optioncategoryIndex2 != '')
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10, left: 110),
                          child: Container(
                            height: sizeHeight * 0.027,
                            width: sizeWidth * 1,
                            child: Row(
                              children: [
                                GetX<FoodOptionController>(
                                  init: _foodOptionController,
                                  builder: (controller) {
                                    return Transform.scale(
                                      scale: 1.5,
                                      child: Checkbox(
                                        value: (category == 'Steak')
                                            ? controller
                                                .isChecked1Cat1[currentIndex]
                                                .value
                                            : (category == 'Drinks')
                                                ? controller
                                                    .isChecked1Cat2[
                                                        currentIndex]
                                                    .value
                                                : (category == 'Foods')
                                                    ? controller
                                                        .isChecked1Cat3[
                                                            currentIndex]
                                                        .value
                                                    : (category == 'Noodles')
                                                        ? controller
                                                            .isChecked1Cat4[
                                                                currentIndex]
                                                            .value
                                                        : controller
                                                            .isChecked1[
                                                                currentIndex]
                                                            .value,
                                        onChanged: (value) {
                                          adtimeController.reset();
                                          controller.toggleCheckbox1(
                                              currentIndex, category);
                                        },
                                      ),
                                    );
                                  },
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween, // ชิดขวาสุด
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30),
                                        child: Text(kainame,
                                            style: Fonts(context, 0.02 * 1.5,
                                                false, Colors.black)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 100),
                                        child: Text('฿ ${kaiprice.toString()}',
                                            style: Fonts(context, 0.02 * 1.5,
                                                false, Colors.black)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  (optioncategoryIndex2 != '')
                      ? Padding(
                          padding: const EdgeInsets.only(left: 110, top: 10),
                          child: Container(
                            height: sizeHeight * 0.027,
                            width: sizeWidth * 1,
                            child: Row(
                              children: [
                                GetX<FoodOptionController>(
                                  init: _foodOptionController,
                                  builder: (controller) {
                                    return Transform.scale(
                                        scale: 1.5,
                                        child: Checkbox(
                                          value: (category == 'Steak')
                                              ? controller
                                                  .isChecked2Cat1[currentIndex]
                                                  .value
                                              : (category == 'Drinks')
                                                  ? controller
                                                      .isChecked2Cat2[
                                                          currentIndex]
                                                      .value
                                                  : (category == 'Foods')
                                                      ? controller
                                                          .isChecked2Cat3[
                                                              currentIndex]
                                                          .value
                                                      : (category == 'Noodles')
                                                          ? controller
                                                              .isChecked2Cat4[
                                                                  currentIndex]
                                                              .value
                                                          : controller
                                                              .isChecked2[
                                                                  currentIndex]
                                                              .value,
                                          onChanged: (value) {
                                            adtimeController.reset();
                                            controller.toggleCheckbox2(
                                                currentIndex, category);
                                          },
                                        ));
                                  },
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween, // ชิดขวาสุด
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30),
                                        child: Text(kainame1,
                                            style: Fonts(context, 0.02 * 1.5,
                                                false, Colors.black)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 100),
                                        child: Text('฿ ${kaiprice1.toString()}',
                                            style: Fonts(context, 0.02 * 1.5,
                                                false, Colors.black)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  (optioncategoryIndex2 != '')
                      ? Padding(
                          padding: const EdgeInsets.only(left: 110, top: 10),
                          child: Container(
                            height: sizeHeight * 0.027,
                            width: sizeWidth * 1,
                            child: Row(
                              children: [
                                GetX<FoodOptionController>(
                                  init: _foodOptionController,
                                  builder: (controller) {
                                    return Transform.scale(
                                        scale: 1.5,
                                        child: Checkbox(
                                          value: (category == 'Steak')
                                              ? controller
                                                  .isChecked3Cat1[currentIndex]
                                                  .value
                                              : (category == 'Drinks')
                                                  ? controller
                                                      .isChecked3Cat2[
                                                          currentIndex]
                                                      .value
                                                  : (category == 'Foods')
                                                      ? controller
                                                          .isChecked3Cat3[
                                                              currentIndex]
                                                          .value
                                                      : (category == 'Noodles')
                                                          ? controller
                                                              .isChecked3Cat4[
                                                                  currentIndex]
                                                              .value
                                                          : controller
                                                              .isChecked3[
                                                                  currentIndex]
                                                              .value,
                                          onChanged: (value) {
                                            adtimeController.reset();
                                            controller.toggleCheckbox3(
                                                currentIndex, category);
                                          },
                                        ));
                                  },
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween, // ชิดขวาสุด
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30),
                                        child: Text(kainame2,
                                            style: Fonts(context, 0.02 * 1.5,
                                                false, Colors.black)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 100),
                                        child: Text('฿ ${kaiprice2.toString()}',
                                            style: Fonts(context, 0.02 * 1.5,
                                                false, Colors.black)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  (optioncategoryIndex3 != '')
                      ? Padding(
                          padding: const EdgeInsets.only(
                              right: 100, left: 100, top: 30, bottom: 10),
                          child: Container(
                            color: Color.fromARGB(255, 0, 0, 0),
                            width: sizeWidth * 0.8,
                            height: sizeHeight * 0.0008,
                          ),
                        )
                      : Container(),
                  (optioncategoryIndex3 != '')
                      ? Padding(
                          padding: const EdgeInsets.only(top: 30, left: 110),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(optioncategoryIndex3,
                                  style: Fonts(
                                      context, 0.03, false, Colors.black))),
                        )
                      : Container(),
                  (optioncategoryIndex3 != '')
                      ? Obx(() => Padding(
                            padding: const EdgeInsets.only(left: 87, top: 10),
                            child: ListTile(
                              title: Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween, // ชิดขวาสุด
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Text(selectedname,
                                          style: Fonts(context, 0.02 * 1.5,
                                              false, Colors.black)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 85),
                                      child: Text(
                                          '${specialprice.toString()} ฿',
                                          style: Fonts(context, 0.02 * 1.5,
                                              false, Colors.black)),
                                    ),
                                  ],
                                ),
                              ),
                              leading: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: GestureDetector(
                                  onTap: () {
                                    adtimeController.reset();

                                    _foodOptionController.selectSpecial(
                                        selectedname, currentIndex, category);

                                    selectExtra[currentIndex] =
                                        !selectExtra[currentIndex];
                                  },
                                  child: Container(
                                    width: sizeWidth * 0.027,
                                    height: sizeHeight * 0.1,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: sizeWidth * 0.017,
                                        height: sizeHeight * 0.05,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: selectExtra[currentIndex]
                                                ? Colors.black
                                                : Colors.transparent),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 100, left: 100, top: 30, bottom: 10),
                    child: Container(
                      color: Color.fromARGB(255, 0, 0, 0),
                      width: sizeWidth * 0.8,
                      height: sizeHeight * 0.0008,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 30, left: 110),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('เพิ่มเติม', //'Note',
                            style: Fonts(context, 0.03, false, Colors.black)),
                      )),
                  Column(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 30),
                          child: Container(
                            width: sizeWidth * 0.8,
                            child: TextField(
                              style: Fonts(context, 0.035, false, Colors.black),
                              onChanged: (text) {},
                              decoration: InputDecoration(
                                labelText:
                                    '  เช่น ไม่ใส่ผัก', //'e.g. No Vegetables',
                                labelStyle: Fonts(context, 0.035, false,
                                    Color.fromRGBO(214, 214, 214, 1)),
                                border: OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 60),
                              ),
                              controller: TextEditingController(text: ''),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height:
                            sizeHeight * 0.03, // Set the desired height here
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 100, left: 100, top: 30),
                    child: Container(
                      color: Color.fromARGB(255, 0, 0, 0),
                      width: sizeWidth * 0.8,
                      height: sizeHeight * 0.0008,
                    ),
                  ),
                  Container(
                    width: sizeWidth * 0.8,
                    height: sizeHeight * 0.06,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 250, top: 40),
                      child: Row(
                        children: [
                          Container(
                            height: sizeHeight * 0.04,
                            width: sizeWidth * 0.08,
                            child: IconButton(
                              icon: Icon(
                                Icons.remove_circle_outline,
                                size: sizeWidth * 0.07,
                              ),
                              onPressed: () {
                                String remove =
                                    'Remove ${mealNameEN} -1 : ${_foodOptionController.formattedDate}';
                                LogFile(remove);
                                adtimeController.reset();
                                _foodOptionController.numordercheck.value =
                                    false;
                                _foodOptionController.cancelremove.value++;

                                double removeItemPrice = _foodOptionController
                                    .calculateTotal(currentIndex, category);
                                _foodOptionController.decrement(
                                    currentIndex, category);
                                int removeItem = (removeItemPrice /
                                        _foodOptionController
                                            .cancelremove.value)
                                    .toInt();
                              },
                            ),
                          ),
                          Obx(
                            () => Padding(
                              padding: const EdgeInsets.only(left: 40),
                              child: Container(
                                height: sizeHeight * 0.05,
                                width: sizeWidth * 0.15,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 40, top: 10),
                                  child: Text(
                                      " ${_foodOptionController.countValue(currentIndex, category)}",
                                      style: Fonts(
                                          context, 0.045, false, Colors.black)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: Container(
                              height: sizeHeight * 0.04,
                              width: sizeWidth * 0.07,
                              child: IconButton(
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  size: sizeWidth * 0.07,
                                ),
                                onPressed: () {
                                  String add =
                                      'Add ${mealNameEN} +1 : ${_foodOptionController.formattedDate}';
                                  LogFile(add);
                                  adtimeController.reset();
                                  _foodOptionController.numordercheck.value =
                                      false;
                                  _foodOptionController.cancelpush.value++;
                                  double plusItemPrice = _foodOptionController
                                      .calculateTotal(currentIndex, category);
                                  _foodOptionController.increment(
                                      currentIndex, category);
                                  int plusItem = (plusItemPrice /
                                          _foodOptionController
                                              .cancelpush.value)
                                      .toInt();

                                  _foodOptionController.cancelpushTotal.value =
                                      (plusItem *
                                          _foodOptionController
                                              .cancelpush.value);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 50, left: 30, right: 30, bottom: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: sizeWidth * 0.8,
                          child: ElevatedButton(
                            onPressed: () {
                              adtimeController.reset();
                              onSave(context, currentIndex, category);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(50, 80),
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              backgroundColor: Colors.black,
                              onPrimary: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 45),
                                  child: Obx(() {
                                    return Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 80),
                                        child: Text(
                                            /*'Add To List  */ 'เพิ่มไปยังรายการ          ${_foodOptionController.calculateTotal(currentIndex, category)} ฿',
                                            style: Fonts(context, 0.042, false,
                                                Colors.white)),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight * 0.04,
                  )
                ])
              ]),
            )));
  }
}
