import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:intl/intl.dart';

import '../api/Kios_API.dart';

final dataKios _dataKios = Get.put(dataKios());

class FoodOptionController extends GetxController {
  final selectedFoodItems = <FoodItem>[].obs;
  final selectedFoodItemsCat1 = <FoodItem>[].obs;
  final selectedFoodItemsCat2 = <FoodItem>[].obs;
  final selectedFoodItemsCat3 = <FoodItem>[].obs;
  final selectedFoodItemsCat4 = <FoodItem>[].obs;
  final selectedFoodItemssecond = <FoodItem>[].obs;
  final selectedOptions = <String>[].obs;
  final selectedlevelOptions = <FoodItem>[].obs;
  final selectedlevel = <String>[].obs;
  Map<int, List<int>> indexToListMap = {};
  RxString printerValue = ''.obs;
  late Timer timer;
  Rx<Image?> images = Rx<Image?>(null);
  List<FoodItem> foodItemsForIndex = [];
  final List<bool> selectedSpecial = <bool>[].obs;
  final List<bool> selectedSpecialCat1 = <bool>[].obs;
  final List<bool> selectedSpecialCat2 = <bool>[].obs;
  final List<bool> selectedSpecialCat3 = <bool>[].obs;
  final List<bool> selectedSpecialCat4 = <bool>[].obs;
  final List<RxBool> isChecked = [];
  final List<RxBool> isChecked1 = [];
  final List<RxBool> isChecked1Cat1 = [];
  final List<RxBool> isChecked1Cat2 = [];
  final List<RxBool> isChecked1Cat3 = [];
  final List<RxBool> isChecked1Cat4 = [];
  final List<RxBool> isChecked2 = [];
  final List<RxBool> isChecked2Cat1 = [];
  final List<RxBool> isChecked2Cat2 = [];
  final List<RxBool> isChecked2Cat3 = [];
  final List<RxBool> isChecked2Cat4 = [];
  final List<RxBool> isChecked3 = [];
  final List<RxBool> isChecked3Cat1 = [];
  final List<RxBool> isChecked3Cat2 = [];
  final List<RxBool> isChecked3Cat3 = [];
  final List<RxBool> isChecked3Cat4 = [];
  final List<bool> selectedSpecialStates = <bool>[].obs;
  final List<bool> selectedSpecialStatesCat1 = <bool>[].obs;
  final List<bool> selectedSpecialStatesCat2 = <bool>[].obs;
  final List<bool> selectedSpecialStatesCat3 = <bool>[].obs;
  final List<bool> selectedSpecialStatesCat4 = <bool>[].obs;
  final List<int> countList = <int>[].obs;
  final List<int> countListCat1 = <int>[].obs;
  final List<int> countListCat2 = <int>[].obs;
  final List<int> countListCat3 = <int>[].obs;
  final List<int> countListCat4 = <int>[].obs;
  final RxBool showSkeleton = false.obs;
  final List<int> food_prices = <int>[].obs;
  Map<int, int> totalMap = {};
  int maxNumberOfIndices = 20;
  var FileLog = DateFormat('dd/MM/yyyy HH:mm:').format(DateTime.now());
  var food_price = 150.obs;
  var count = 1.obs;
  //var c = 0.obs;
  RxInt payment_times = 0.obs;
  var tapCount = 0.obs;
  var tapIndex = 0.obs;
  String total = '';
  RxString choose = ''.obs;
  RxString cancel = ''.obs;
 
  var alltotal = 0.obs;
  RxDouble total_price = 0.0.obs;
  RxInt numorder = 0.obs;
  var numordercheck = false.obs;
  var VAT = 0.obs;
  final RxList<int> orders = <int>[].obs;
  final RxList<String> checkorders = <String>[].obs;
  var currentTotal = 0.obs;
  Map<double, double> calculatedTotalMap = {};
  Map<double, double> Canceltotal = {};
  Map<int, int> amountFoodMap = {};
  final List<int> pushCountlist = <int>[0].obs;
  final List<int> removeCountlist = <int>[0].obs;
  final List<int> pushTotallist = <int>[0].obs;
  final List<int> removeTotallist = <int>[0].obs;
  final List<String> categoryValues = <String>[].obs;
  var pushCount = 0.obs;
  var removeCount = 0.obs;
  var pushTotal = 0.obs;
  var removeTotal = 0.obs;
  var namecat = ''.obs;
  String formattedDate = DateFormat('HH:mm:ss').format(DateTime.now());
  /* var cancelpush = 0.obs;
  var cancelremove = 0.obs;*/
  var cancelpush = 0.obs;
  var cancelremove = 0.obs;
  var cancelpushTotal = 0.obs;
  var cancelremoveTotal = 0.obs;
  final List<int> categoryList = <int>[0].obs;
  final List<int> diff_amountlist = <int>[].obs;

  @override
  void onInit() {
    super.onInit();

    if (maxNumberOfIndices != null) {
      selectedFoodItems
          .addAll(List.generate(maxNumberOfIndices, (_) => FoodItem()));
      selectedlevelOptions
          .addAll(List.generate(maxNumberOfIndices, (_) => FoodItem()));
      selectedFoodItemsCat1
          .addAll(List.generate(maxNumberOfIndices, (_) => FoodItem()));
      selectedFoodItemsCat2
          .addAll(List.generate(maxNumberOfIndices, (_) => FoodItem()));
      selectedFoodItemsCat3
          .addAll(List.generate(maxNumberOfIndices, (_) => FoodItem()));
      selectedFoodItemsCat4
          .addAll(List.generate(maxNumberOfIndices, (_) => FoodItem()));
      isChecked1
          .addAll(List.generate(maxNumberOfIndices, (_) => RxBool(false)));
      isChecked1Cat1
          .addAll(List.generate(maxNumberOfIndices, (_) => RxBool(false)));
      isChecked1Cat2
          .addAll(List.generate(maxNumberOfIndices, (_) => RxBool(false)));
      isChecked1Cat3
          .addAll(List.generate(maxNumberOfIndices, (_) => RxBool(false)));
      isChecked1Cat4
          .addAll(List.generate(maxNumberOfIndices, (_) => RxBool(false)));
      isChecked2
          .addAll(List.generate(maxNumberOfIndices, (_) => RxBool(false)));
      isChecked2Cat1
          .addAll(List.generate(maxNumberOfIndices, (_) => RxBool(false)));
      isChecked2Cat2
          .addAll(List.generate(maxNumberOfIndices, (_) => RxBool(false)));
      isChecked2Cat3
          .addAll(List.generate(maxNumberOfIndices, (_) => RxBool(false)));
      isChecked2Cat4
          .addAll(List.generate(maxNumberOfIndices, (_) => RxBool(false)));
      isChecked3
          .addAll(List.generate(maxNumberOfIndices, (_) => RxBool(false)));
      isChecked3Cat1
          .addAll(List.generate(maxNumberOfIndices, (_) => RxBool(false)));
      isChecked3Cat2
          .addAll(List.generate(maxNumberOfIndices, (_) => RxBool(false)));
      isChecked3Cat3
          .addAll(List.generate(maxNumberOfIndices, (_) => RxBool(false)));
      isChecked3Cat4
          .addAll(List.generate(maxNumberOfIndices, (_) => RxBool(false)));
      selectedSpecialStates
          .addAll(List.generate(maxNumberOfIndices, (_) => false));
      selectedSpecialStatesCat1
          .addAll(List.generate(maxNumberOfIndices, (_) => false));
      selectedSpecialStatesCat2
          .addAll(List.generate(maxNumberOfIndices, (_) => false));
      selectedSpecialStatesCat3
          .addAll(List.generate(maxNumberOfIndices, (_) => false));
      selectedSpecialStatesCat4
          .addAll(List.generate(maxNumberOfIndices, (_) => false));
      foodItemsForIndex =
          List.generate(maxNumberOfIndices, (index) => FoodItem());
      countList.addAll(List.generate(maxNumberOfIndices, (_) => 1));
      countListCat1.addAll(List.generate(maxNumberOfIndices, (_) => 1));
      countListCat2.addAll(List.generate(maxNumberOfIndices, (_) => 1));
      countListCat3.addAll(List.generate(maxNumberOfIndices, (_) => 1));
      countListCat4.addAll(List.generate(maxNumberOfIndices, (_) => 1));
    }

    ever(selectedOptions, (
      List<String> options,
    ) {
      final selectedFoodItem = (namecat == 'Steak')
          ? selectedFoodItemsCat1
          : (namecat == 'Drinks')
              ? selectedFoodItemsCat2
              : (namecat == 'Foods')
                  ? selectedFoodItemsCat3
                  : (namecat == 'Noodles')
                      ? selectedFoodItemsCat4
                      : selectedFoodItems;
      for (int index = 0; index < selectedFoodItem.length; index++) {
        FoodItem foodItem = selectedFoodItem[index];
        final meal = (namecat == 'Steak')
            ? _dataKios.steakList[index]
            : (namecat == 'Drinks')
                ? _dataKios.drinkList[index]
                : (namecat == 'Foods')
                    ? _dataKios.foodList[index]
                    : (namecat == 'Noodles')
                        ? _dataKios.noodleList[index]
                        : _dataKios.coffeeList[index];
        final mealOptions = meal.mealOptions;

        final mealOption = mealOptions[index];
        final mealOptionname = mealOption['name'];
        final mealOptionprice = mealOption['price'].toDouble();
        if (options.contains(mealOptionname)) {
          foodItem.price = mealOptionprice;
        } else {
          foodItem.price = 0;
        }
      }
    });
    ever(selectedOptions, (
      List<String> levels,
    ) {
      final selectedFoodItem = (namecat.value == 'Steak')
          ? selectedFoodItemsCat1
          : (namecat.value == 'Drinks')
              ? selectedFoodItemsCat2
              : (namecat.value == 'Foods')
                  ? selectedFoodItemsCat3
                  : (namecat.value == 'Noodles')
                      ? selectedFoodItemsCat4
                      : selectedFoodItems;
      for (int index = 0; index < selectedFoodItem.length; index++) {
        FoodItem foodItem = selectedFoodItem[index];
        final meal = (namecat.value == 'Steak')
            ? _dataKios.steakList[index]
            : (namecat.value == 'Drinks')
                ? _dataKios.drinkList[index]
                : (namecat.value == 'Foods')
                    ? _dataKios.foodList[index]
                    : (namecat.value == 'Noodles')
                        ? _dataKios.noodleList[index]
                        : _dataKios.coffeeList[index];

        final mealOptions = meal.mealOptions;
        final mealOptionIndex2 = mealOptions[1];
        final optioncategoryIndex2 = mealOptionIndex2['option'];
        final MealOptions = optioncategoryIndex2[index];
        final spicinessOptionname = MealOptions['name'];
        final mealOptionprices = MealOptions['price'].toDouble();

        if (levels.contains(spicinessOptionname)) {
          foodItem.level = mealOptionprices;
        } else {
          foodItem.level = 0;
        }
      }
    });
  }

  void startTimer(BuildContext context) {
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (timer) {
      if (payment_times.value > 0) {
        payment_times.value--;
        print('จ่ายได้ในอีก : ${payment_times.value}');
      } else if (payment_times.value == 0) {
        timer.cancel;
      }
    });
  }

  void selectFoodItem(FoodItem foodItem, int index, String cat) {
    final selectedFoodItem = (cat == 'Steak')
        ? selectedFoodItemsCat1
        : (cat == 'Drinks')
            ? selectedFoodItemsCat2
            : (cat == 'Foods')
                ? selectedFoodItemsCat3
                : (cat == 'Noodles')
                    ? selectedFoodItemsCat4
                    : selectedFoodItems;
    selectedFoodItem[index] = foodItem;
  }

  void selectOption_Spiciness(FoodItem options, int index, String cat) {
    final selectedFoodItem = (cat == 'Steak')
        ? selectedFoodItemsCat1
        : (cat == 'Drinks')
            ? selectedFoodItemsCat2
            : (cat == 'Foods')
                ? selectedFoodItemsCat3
                : (cat == 'Noodles')
                    ? selectedFoodItemsCat4
                    : selectedFoodItems;
    selectedFoodItem[index] = options;
  }

  void FromHere() {
    choose.value = 'Dine-in';
  }

  void TakeHome() {
    choose.value = 'Take Away';
  }

  //โค้ดเลือกไข่
  void toggleCheckbox1(int index, String cat) {
    final selectedFoodItem = (cat == 'Steak')
        ? selectedFoodItemsCat1
        : (cat == 'Drinks')
            ? selectedFoodItemsCat2
            : (cat == 'Foods')
                ? selectedFoodItemsCat3
                : (cat == 'Noodles')
                    ? selectedFoodItemsCat4
                    : selectedFoodItems;
    final Check1 = (cat == 'Steak')
        ? isChecked1Cat1[index].toggle()
        : (cat == 'Drinks')
            ? isChecked1Cat2[index].toggle()
            : (cat == 'Foods')
                ? isChecked1Cat3[index].toggle()
                : (cat == 'Noodles')
                    ? isChecked1Cat4[index].toggle()
                    : isChecked1[index].toggle();

    if (index >= 0 && index < selectedFoodItem.length) {
      FoodItem foodItem = selectedFoodItem[index];
      Check1;
      final meal = (cat == 'Steak')
          ? _dataKios.steakList[index]
          : (cat == 'Drinks')
              ? _dataKios.drinkList[index]
              : (cat == 'Foods')
                  ? _dataKios.foodList[index]
                  : (cat == 'Noodles')
                      ? _dataKios.noodleList[index]
                      : _dataKios.coffeeList[index];
      final mealOption = meal.mealOptions;
      final optionKai = mealOption[2];
      final kaiIndex = optionKai['option'];
      final kai = kaiIndex[0];
      final kainame = kai['name'];
      final kaiprice = kai['price'].toDouble();

      if ((cat == 'Steak')
          ? isChecked1Cat1[index].value
          : (cat == 'Drinks')
              ? isChecked1Cat2[index].value
              : (cat == 'Foods')
                  ? isChecked1Cat3[index].value
                  : (cat == 'Noodles')
                      ? isChecked1Cat4[index].value
                      : isChecked1[index].value) {
        selectedFoodItem[index].egg1 = kaiprice;
        foodItem.Kai1 = kainame;
        String Select = 'Add ${kainame} : ${formattedDate}';
        LogFile(Select);
      } else {
        String notSlect = 'Cancel adding ${kainame} : ${formattedDate}';
        LogFile(notSlect);
        selectedFoodItem[index].egg1 = 0;
        foodItem.Kai1 = '';
      }
      selectedFoodItem[index] = foodItem;
      update();
    }
  }

  void toggleCheckbox2(int index, String cat) {
    final selectedFoodItem = (cat == 'Steak')
        ? selectedFoodItemsCat1
        : (cat == 'Drinks')
            ? selectedFoodItemsCat2
            : (cat == 'Foods')
                ? selectedFoodItemsCat3
                : (cat == 'Noodles')
                    ? selectedFoodItemsCat4
                    : selectedFoodItems;
    final Check2 = (cat == 'Steak')
        ? isChecked2Cat1[index].toggle()
        : (cat == 'Drinks')
            ? isChecked2Cat2[index].toggle()
            : (cat == 'Foods')
                ? isChecked2Cat3[index].toggle()
                : (cat == 'Noodles')
                    ? isChecked2Cat4[index].toggle()
                    : isChecked2[index].toggle();

    if (index >= 0 && index < selectedFoodItem.length) {
      FoodItem foodItem = selectedFoodItem[index];
      Check2;
      final meal = (cat == 'Steak')
          ? _dataKios.steakList[index]
          : (cat == 'Drinks')
              ? _dataKios.drinkList[index]
              : (cat == 'Foods')
                  ? _dataKios.foodList[index]
                  : (cat == 'Noodles')
                      ? _dataKios.noodleList[index]
                      : _dataKios.coffeeList[index];
      final mealOption = meal.mealOptions;
      final optionKai = mealOption[2];
      final kaiIndex = optionKai['option'];
      final kai1 = kaiIndex[1];
      final kainame1 = kai1['name'];
      final kaiprice1 = kai1['price'].toDouble();
      //
      if ((cat == 'Steak')
          ? isChecked2Cat1[index].value
          : (cat == 'Drinks')
              ? isChecked2Cat2[index].value
              : (cat == 'Foods')
                  ? isChecked2Cat3[index].value
                  : (cat == 'Noodles')
                      ? isChecked2Cat4[index].value
                      : isChecked2[index].value) {
        selectedFoodItem[index].egg2 = kaiprice1;
        foodItem.Kai2 = kainame1;
        String Select1 = 'Add ${kainame1} : ${formattedDate}';
        LogFile(Select1);
      } else {
        String notSlect1 = 'Cancel adding ${kainame1} : ${formattedDate}';
        LogFile(notSlect1);
        selectedFoodItem[index].egg2 = 0;
        foodItem.Kai2 = '';
      }
      selectedFoodItem[index] = foodItem;
      update();
    }
  }

  void toggleCheckbox3(int index, String cat) {
    final selectedFoodItem = (cat == 'Steak')
        ? selectedFoodItemsCat1
        : (cat == 'Drinks')
            ? selectedFoodItemsCat2
            : (cat == 'Foods')
                ? selectedFoodItemsCat3
                : (cat == 'Noodles')
                    ? selectedFoodItemsCat4
                    : selectedFoodItems;
    final Check3 = (cat == 'Steak')
        ? isChecked3Cat1[index].toggle()
        : (cat == 'Drinks')
            ? isChecked3Cat2[index].toggle()
            : (cat == 'Foods')
                ? isChecked3Cat3[index].toggle()
                : (cat == 'Noodles')
                    ? isChecked3Cat4[index].toggle()
                    : isChecked3[index].toggle();
    if (index >= 0 && index < selectedFoodItem.length) {
      FoodItem foodItem = selectedFoodItem[index];
      Check3;
      final meal = (cat == 'Steak')
          ? _dataKios.steakList[index]
          : (cat == 'Drinks')
              ? _dataKios.drinkList[index]
              : (cat == 'Foods')
                  ? _dataKios.foodList[index]
                  : (cat == 'Noodles')
                      ? _dataKios.noodleList[index]
                      : _dataKios.coffeeList[index];
      final mealOption = meal.mealOptions;
      final optionKai = mealOption[2];
      final kaiIndex = optionKai['option'];
      final kai2 = kaiIndex[2];
      final kainame2 = kai2['name'];
      final kaiprice2 = kai2['price'].toDouble();
      //
      if ((cat == 'Steak')
          ? isChecked3Cat1[index].value
          : (cat == 'Drinks')
              ? isChecked3Cat2[index].value
              : (cat == 'Foods')
                  ? isChecked3Cat3[index].value
                  : (cat == 'Noodles')
                      ? isChecked3Cat4[index].value
                      : isChecked3[index].value) {
        selectedFoodItem[index].egg3 = kaiprice2;
        foodItem.Kai3 = kainame2;
        String Select2 = 'Add ${kainame2} : ${formattedDate}';
        LogFile(Select2);
      } else {
        String notSlect2 = 'Cancel adding ${kainame2} : ${formattedDate}';
        LogFile(notSlect2);
        selectedFoodItem[index].egg3 = 0;
        foodItem.Kai3 = '';
      }
      selectedFoodItem[index] = foodItem;
      update();
    }
  }

  void selectSpecial(String total, int index, String cat) {
    final selectedFoodItem = (cat == 'Steak')
        ? selectedFoodItemsCat1
        : (cat == 'Drinks')
            ? selectedFoodItemsCat2
            : (cat == 'Foods')
                ? selectedFoodItemsCat3
                : (cat == 'Noodles')
                    ? selectedFoodItemsCat4
                    : selectedFoodItems;
    FoodItem foodItem = selectedFoodItem[index];
    if (index >= 0 && index < selectedFoodItems.length) {
      FoodItem foodItem = selectedFoodItem[index];
      final meal = (cat == 'Steak')
          ? _dataKios.steakList[index]
          : (cat == 'Drinks')
              ? _dataKios.drinkList[index]
              : (cat == 'Foods')
                  ? _dataKios.foodList[index]
                  : (cat == 'Noodles')
                      ? _dataKios.noodleList[index]
                      : _dataKios.coffeeList[index];
      final mealOption = meal.mealOptions;
      final optionspecial = mealOption.length > 3 ? mealOption[3] : {};
      final specialIndex =
          optionspecial.containsKey('option') ? optionspecial['option'] : [];
      final selectedspecial = specialIndex.isNotEmpty ? specialIndex[0] : {};
      final selectedname =
          selectedspecial.containsKey('name') ? selectedspecial['name'] : '';
      final specialprice = selectedspecial.containsKey('price')
          ? selectedspecial['price'].toDouble()
          : 0.toDouble();
      if (foodItem.selectedValue == total) {
        foodItem.selectedValue = '';
        foodItem.special = 0;
        String selectExtra = 'Extra order : ${formattedDate}';
        LogFile(selectExtra);
      } else {
        String notExtra = 'Cancel Extra order : ${formattedDate}';
        LogFile(notExtra);
        foodItem.selectedValue = total;
        foodItem.special = specialprice;
      }

      selectedFoodItem[index] = foodItem;
      update();
    }
  }

  void increment(int index, String cat) {
    final counts = (cat == 'Steak')
        ? countListCat1
        : (cat == 'Drinks')
            ? countListCat2
            : (cat == 'Foods')
                ? countListCat3
                : (cat == 'Noodles')
                    ? countListCat4
                    : countList;
    if (index >= 0 && index < counts.length) {
      counts[index]++;
    } else {
      count.value++;
    }
  }

  int countValue(int index, String cat) {
    int cancelOrder = cancelpush.value + cancelremove.value;
    final counts = (cat == 'Steak')
        ? countListCat1
        : (cat == 'Drinks')
            ? countListCat2
            : (cat == 'Foods')
                ? countListCat3
                : (cat == 'Noodles')
                    ? countListCat4
                    : countList;
    if (index >= 0 && index < counts.length) {
      return counts[index];
    } else {
      if (cat == 'Steak') {
        countListCat1.add(count.value);
        return count.value;
      } else if (cat == 'Drinks') {
        countListCat2.add(count.value);
        return count.value;
      } else if (cat == 'Foods') {
        countListCat3.add(count.value);
        return count.value;
      } else if (cat == 'Noodles') {
        countListCat4.add(count.value);
        return count.value;
      } else {
        countList.add(count.value);
        return count.value;
      }
    }
  }

  //

  void decrement(int index, String cat) {
    final counts = (cat == 'Steak')
        ? countListCat1
        : (cat == 'Drinks')
            ? countListCat2
            : (cat == 'Foods')
                ? countListCat3
                : (cat == 'Noodles')
                    ? countListCat4
                    : countList;
    if (index >= 0 && index < counts.length && counts[index] > 0) {
      counts[index]--;
    } else {
      count.value--;
    }
  }

  void pushorsad(int index, String cat) {
    final meal = (cat == 'Steak')
        ? _dataKios.steakList[index]
        : (cat == 'Drinks')
            ? _dataKios.drinkList[index]
            : (cat == 'Foods')
                ? _dataKios.foodList[index]
                : (cat == 'Noodles')
                    ? _dataKios.noodleList[index]
                    : _dataKios.coffeeList[index];
    final mealNameID = meal.mealId;

    checkorders.add(mealNameID);
  }

  void pushorder(int index, String cat) {
    final counts = (cat == 'Steak')
        ? countListCat1
        : (cat == 'Drinks')
            ? countListCat2
            : (cat == 'Foods')
                ? countListCat3
                : (cat == 'Noodles')
                    ? countListCat4
                    : countList;
    final meal = (cat == 'Steak')
        ? _dataKios.steakList[index]
        : (cat == 'Drinks')
            ? _dataKios.drinkList[index]
            : (cat == 'Foods')
                ? _dataKios.foodList[index]
                : (cat == 'Noodles')
                    ? _dataKios.noodleList[index]
                    : _dataKios.coffeeList[index];
    final mealNameID = meal.mealId;

    if (!checkorders.contains(mealNameID)) {
      categoryValues.add(cat);
      orders.add(index);
      double calculatedTotal = calculateTotal(index, cat).toDouble();
      calculatedTotalMap[index.toDouble()] = calculatedTotal;
      print('ค่าเก่า ${calculatedTotal}');
      int amount_food = countValue(index, cat);
      pushorsad(index, cat);
      amountFoodMap[index] = amount_food;
      print('จำนวนอาหารเก่า : ${amount_food}');

      total_price.value += calculatedTotal.toDouble();
      numorder += amount_food;
    } else {
      print('เข้าElse');
      int oldAmount = amountFoodMap[index]!.toInt();
      print('จำนวนอาหารเก่า ${oldAmount}');
      double oldCalculatedTotal = calculatedTotalMap[index]!.toDouble();
      print('จำนวนอาหารรวม ${numorder}');
      print('ค่าเก่า ${oldCalculatedTotal}');
      int new_amountFood = countValue(index, cat);
      amountFoodMap[index] = new_amountFood;
      int diff_amount = new_amountFood - oldAmount;
      print('จำนวนอาหารเก่าOld${oldAmount}');
      print('ค่าต่างจำนวนอาหารKK${diff_amount}');
      print('จำนวนอาหารปัจจุบันNew ${new_amountFood}');
      double recalculatedTotal = calculateTotal(index, cat).toDouble();
      calculatedTotalMap[index.toDouble()] = recalculatedTotal;
      print('ค่าปัจจุบน ${recalculatedTotal}');
      double diff = recalculatedTotal - oldCalculatedTotal;
      print(' ค่าต่าง = ${diff}');

      if (numordercheck.value == true) {
        numorder == diff_amount - (pushCount.value) + (removeCount.value);

        total_price.value == diff - (pushCount.value) + (removeTotal.value);
        numordercheck.value = false;
        pushCount.value = 0;
        removeCount.value = 0;
        pushTotal.value = 0;
        removeTotal.value = 0;

        print('บวกif ${(pushCount.value + removeCount.value)}');
        print('ลบif ${(pushCount.value) + (removeTotal.value)}');
      } else {
        print('else num');
        numorder += diff_amount - (pushCount.value) + (removeCount.value);
        total_price.value += diff - (pushTotal.value) + (removeTotal.value);

        print('บวก ${pushTotal.value}');
        print('ลบ ${removeTotal.value}');
        pushCount.value = 0;
        removeCount.value = 0;
        pushTotal.value = 0;
        removeTotal.value = 0;
      }

      /*total_price.value +=
          diff; // อัปเดตค่า total_price โดยไม่เพิ่มค่า numorder อีกครั้ง
      numorder += diff_amount; // เพิ่มเฉพาะค่า diff_amount ไม่บวกอีกครั้ง*/
      print('ค่ารวม = ${total_price.value}');
      print('ต่าง = ${diff_amount}');
    }
  }

  num calculateTotal(int index, String cat) {
    final selectedFoodItem = (cat == 'Steak')
        ? selectedFoodItemsCat1
        : (cat == 'Drinks')
            ? selectedFoodItemsCat2
            : (cat == 'Foods')
                ? selectedFoodItemsCat3
                : (cat == 'Noodles')
                    ? selectedFoodItemsCat4
                    : selectedFoodItems;
    FoodItem foodItem = selectedFoodItem[index];
    final counts = (cat == 'Steak')
        ? countListCat1
        : (cat == 'Drinks')
            ? countListCat2
            : (cat == 'Foods')
                ? countListCat3
                : (cat == 'Noodles')
                    ? countListCat4
                    : countList;
    final meal = (cat == 'Steak')
        ? _dataKios.steakList[index]
        : (cat == 'Drinks')
            ? _dataKios.drinkList[index]
            : (cat == 'Foods')
                ? _dataKios.foodList[index]
                : (cat == 'Noodles')
                    ? _dataKios.noodleList[index]
                    : _dataKios.coffeeList[index];
    final mealPrice = meal.mealPrice;
    final mealOptionprice = meal.mealOptionprice;

    double total = counts[index].toDouble() *
        (mealPrice +
            foodItem.price +
            foodItem.egg1 +
            foodItem.egg2 +
            foodItem.egg3 +
            foodItem.special +
            foodItem.level);

    return total;
  }

 

  String Textmore(int index, String cat, String text) {
    final selectedFoodItem = (cat == 'Steak')
        ? selectedFoodItemsCat1
        : (cat == 'Drinks')
            ? selectedFoodItemsCat2
            : (cat == 'Foods')
                ? selectedFoodItemsCat3
                : (cat == 'Noodles')
                    ? selectedFoodItemsCat4
                    : selectedFoodItems;
    selectedFoodItem[index].enteredText = text;
    return text;
  }

  String TextEdit(int index, String cat) {
    final selectedFoodItem = (cat == 'Steak')
        ? selectedFoodItemsCat1
        : (cat == 'Drinks')
            ? selectedFoodItemsCat2
            : (cat == 'Foods')
                ? selectedFoodItemsCat3
                : (cat == 'Noodles')
                    ? selectedFoodItemsCat4
                    : selectedFoodItems;
    return selectedFoodItem[index].enteredText;
  }
}

class FoodItem {
  String foodName;
  String spicinessLevel;
  bool isEggDawMaiSook;
  bool isEggDawSook;
  bool isKaiJeaw;
  String additionalDetails;
  String Kai1;
  String Kai2;
  String Kai3;
  int count;
  double price;
  double level;
  double special;
  String selectedOption;
  String selected_Spiciness;
  double egg;
  double egg1;
  double egg2;
  double egg3;
  String selectedValue;
  String enteredText;
  String selectedlevel;

  FoodItem(
      {this.foodName = '',
      this.spicinessLevel = '',
      this.isEggDawMaiSook = false,
      this.isEggDawSook = false,
      this.isKaiJeaw = false,
      this.additionalDetails = '',
      this.count = 0,
      this.price = 0,
      this.level = 0,
      this.special = 0,
      this.selectedOption = '',
      this.selected_Spiciness = '',
      this.egg = 0,
      this.egg1 = 0,
      this.egg2 = 0,
      this.egg3 = 0,
      this.selectedValue = '',
      this.enteredText = '',
      this.Kai1 = '',
      this.Kai2 = '',
      this.Kai3 = '',
      this.selectedlevel = ''});
}
