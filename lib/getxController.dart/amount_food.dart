import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen/getxController.dart/save_menu.dart';
import 'package:screen/getxController.dart/textbox_controller.dart';
import '../screen/menu_screen.dart';

class amount_food extends GetxController {
  final TextBoxExampleController textbox_controller =
      Get.put(TextBoxExampleController());
  List<FoodItem> selectedFoodItems = [];

  final List<int> selectedIndices = <int>[].obs;
  var isChecked1 = false.obs;
  var isChecked2 = false.obs;
  var isChecked3 = false.obs;
  var egg1 = 0.obs;
  var egg2 = 0.obs;
  var egg3 = 0.obs;
  var selectedValue = ''.obs;
  var special = 0.0.obs;
  var textValue = 150.0.obs;
  var count = 1.obs;
  var order = 1.obs;
  var numorder = 0.obs;
  var total = 0.obs;
  var selectedOption = ''.obs;
  var pice = 0.obs;
  var selectedMent = ''.obs;
  var selectedMentTitle = ''.obs;
  var selected_Spiciness = ''.obs;
  var selectedSpiciness = ''.obs;
  var selectedSpicinessTitle = ''.obs;
  final foodItemMap = <int, List<FoodItem>>{}.obs;

  void updateFoodItem(int index, FoodItem updatedFoodItem) {
    if (foodItemMap.containsKey(index)) {
      foodItemMap[index]!.add(updatedFoodItem);
    } else {
      foodItemMap[index] = [updatedFoodItem];
    }
  }

  //โค้ดราคา
  void setDefaultValues() {
    var isChecked1 = false.obs;
    var isChecked2 = false.obs;
    var isChecked3 = false.obs;
    var egg1 = 0.obs;
    var egg2 = 0.obs;
    var egg3 = 0.obs;
    var selectedValue = ''.obs;
    var special = 0.obs;
    var textValue = 150.obs;
    var count = 1.obs;
    var order = 1.obs;
    var numorder = 0.obs;
    var total = 0.obs;
    var selectedOption = ''.obs;
    var pice = 0.obs;
    var selectedMent = ''.obs;
    var selectedMentTitle = ''.obs;
    var selected_Spiciness = ''.obs;
    var selectedSpiciness = ''.obs;
    var selectedSpicinessTitle = ''.obs;
  }

//จำนวนอาหาร
  void updateTextValue(int value) {
    textValue.value = value.toDouble();
  }

  void increment() {
    count.value++;
  }

  void decrement() {
    if (count.value > 1) {
      count.value--;
    }
  }

  //อัปเดตราคา

  void updateTotal() {
    numorder = count;
    total.value = calculateTotal().toInt();
    numorder.update((value) => value);
  }

  double calculateTotal() {
    double textValueDouble = textValue.value.toDouble();

    return count.value *
        (textValueDouble +
            pice.value +
            egg1.value +
            egg2.value +
            egg3.value +
            special.value);
  }

  double toTal() {
    double textValueDouble = textValue.value.toDouble();
    return textValueDouble +
        pice.value +
        egg1.value +
        egg2.value +
        egg3.value +
        special.value;
  }

//โค้ดสั่งอาหารพิเศษ
  void updateSelectedValue(String total) {
    if (selectedValue.value == total) {
      selectedValue.value = '';
      special.value = 0;
    } else if (selectedValue.value != total) {
      selectedValue.value = total;
      special.value = 15;
    }
  }

//โค้ดเลือกไข่
  void toggleCheckbox1() {
    isChecked1.toggle();
    if (isChecked1.value) {
      egg1.value = 10;
    } else {
      egg1.value = 0;
    }
  }

  void toggleCheckbox2() {
    isChecked2.toggle();
    if (isChecked2.value) {
      egg2.value = 10;
    } else {
      egg2.value = 0;
    }
  }

  void toggleCheckbox3() {
    isChecked3.toggle();
    if (isChecked3.value) {
      egg3.value = 10;
    } else {
      egg3.value = 0;
    }
  }

//โค้ดเลือกเนื้อ
  void selectOption(String option, String s) {
    selectedOption.value = option;
  }

//โค้ดเลือกความเผ็ด
  void selectOption_Spiciness(String options, String v) {
    selected_Spiciness.value = options;
  }

  @override
  void onInit() {
    super.onInit();

    ever(selectedOption, (String option) {
      if (option == 'เนื้อ' || option == 'กุ้ง' || option == 'ปลาหมึก') {
        pice.value = 10;
      } else {
        pice.value = 0;
      }
    });
  }

  //เลือกและเก็บข้อมูลความเผ็ด
  void selectSpiciness(String option, String optionTitle) {
    selectedSpiciness.value = option;
    selectedSpicinessTitle.value = optionTitle;
  }

//บันทึกเนื้อสัตว์
  void selectMent(String option, String optionTitle) {
    selectedMent.value = option;
    selectedMentTitle.value = optionTitle;
  }

  void add_item(BuildContext context) {
    if (selectedOption.value != '' && selected_Spiciness != '') {
      updateTotal();
      FoodItem newFoodItem = FoodItem(
          foodName: selectedOption.value,
          spicinessLevel: selectedOption.value,
          isEggDawMaiSook: isChecked1.value,
          isEggDawSook: isChecked2.value,
          isKaiJeaw: isChecked3.value,
          additionalDetails: textbox_controller.enteredText.value,
          count: count.value,
          price: calculateTotal(),
          special: special.value);
      selectedOption:
      '';
      selectedFoodItems.add(newFoodItem);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => menu_screen()),
      );
      updateTotal();
    } else {}
  }

  void resetStateWithoutList() {
    egg1 = 0.obs;
    egg2 = 0.obs;
    egg3 = 0.obs;
    pice = 0.obs;
    selectOption('', '');
    selectOption_Spiciness('', '');
    isChecked1.value = false;
    isChecked2.value = false;
    isChecked3.value = false;
    special.value = 0;
    selectedValue.value = '';
    textbox_controller.enteredText.value = "";
    count.value = 1;
  }

  void ResetState() {
    resetStateWithoutList(); // Call the new method to reset the necessary variables
    // Add any additional code if needed...
  }
}
