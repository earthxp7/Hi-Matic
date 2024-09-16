import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:get/get.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/printer_setting.dart';
import '../getxController.dart/save_menu.dart';

final dataKios _dataKios = Get.put(dataKios());
final FoodOptionController _foodOptionController =
    Get.put(FoodOptionController());
final pinter_test Printer = Get.put(pinter_test());

Future<void> printToNetworkPrinter() async {
  try {
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(PaperSize.mm80, profile);
    final PosPrintResult res =
        await printer.connect(Printer.ipAddresses.value, port: 9100);
    var queue = _dataKios.que.value;
    var branchName = _dataKios.branchName.value;
    var Numqueue = '${branchName.toString()} ${queue.toString()}';
    var line = '------------------------------------------------';
    var Description = 'Description';
    var Thank = 'Thank you for using our service';
    var choose = _foodOptionController.choose.value;
    String padding(String text, int foodLength) {
      final spacesToAdd = foodLength - text.length;
      if (spacesToAdd <= 0) {
        return text;
      }
      return text + ' ' * spacesToAdd;
    }

    String omitted(String text) {
      return text.length <= 20 ? text : '${text.substring(0, 20)}...';
    }

    if (res == PosPrintResult.success) {
      // ทดสอบการพิมพ์
      printer.text(
        '${Numqueue}',
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      );
      printer.text('${choose}',
          styles: PosStyles(
            align: PosAlign.center,
          ));
      printer.text('${line}',
          styles: PosStyles(
            align: PosAlign.center,
          ));

      for (int i = 0; i < _foodOptionController.orders.length; i++) {
        var currentIndex = _foodOptionController.orders[i];
        var category = _foodOptionController.categoryValues[i];
        final meal = (category == 'Steak')
            ? _dataKios.steakList[currentIndex]
            : (category == 'Drinks')
                ? _dataKios.drinkList[currentIndex]
                : (category == 'Foods')
                    ? _dataKios.foodList[currentIndex]
                    : (category == 'Noodles')
                        ? _dataKios.noodleList[currentIndex]
                        : _dataKios.coffeeList[currentIndex];
        final mealNameTH = meal.mealNameTH;
        final mealNameEN = meal.mealNameEN;
        final mealOptions = meal.mealOptions;
        final mealOption = mealOptions[i];
        final mealOptionname = mealOption['name'];
        final mealOptionprice = mealOption['price'];
        final mealDescriptionTH = meal.mealDescriptionTH;
        final mealDescriptionEN = meal.mealDescriptionEN;
        final mealPrice = meal.mealPrice;
        //
        final meatOption = mealOptions[0];
        final meatOptionIndex = meatOption['option'];
        final MeatOption = meatOptionIndex[i];
        final Meatname = MeatOption['name'];
        final Meatprice = MeatOption['price'];
        //
        final mealOptionIndex2 = mealOptions.length > 1 ? mealOptions[1] : {};
        final optioncategoryIndex2 = mealOptionIndex2.containsKey('option')
            ? mealOptionIndex2['option']
            : [];

        final MealOptions =
            optioncategoryIndex2.isNotEmpty ? optioncategoryIndex2[i] : {};
        final spicinessOptionname =
            MealOptions.containsKey('name') ? MealOptions['name'] : '';
        final mealOptionprices = MealOptions.containsKey('price')
            ? MealOptions['price'].toDouble()
            : 0.toDouble();
        //โค้ดชื่อไข่
        final optionKai = mealOptions.length > 2 ? mealOptions[2] : {};
        final kaiIndex =
            optionKai.containsKey('option') ? optionKai['option'] : [];
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
        final optionspecial = mealOptions.length > 3 ? mealOptions[3] : {};
        final specialIndex =
            optionspecial.containsKey('option') ? optionspecial['option'] : [];
        final selectedspecial = specialIndex.isNotEmpty ? specialIndex[0] : {};
        final selectedname =
            selectedspecial.containsKey('name') ? selectedspecial['name'] : '';
        final specialprice = selectedspecial.containsKey('price')
            ? selectedspecial['price'].toDouble()
            : 0.toDouble();
        final selectedFoodItemsList = (category == 'Steak')
            ? _foodOptionController.selectedFoodItemsCat1
            : (category == 'Drinks')
                ? _foodOptionController.selectedFoodItemsCat2
                : (category == 'Foods')
                    ? _foodOptionController.selectedFoodItemsCat3
                    : (category == 'Noodles')
                        ? _foodOptionController.selectedFoodItemsCat4
                        : _foodOptionController.selectedFoodItems;
        var selectedFoodItem = selectedFoodItemsList[currentIndex];

        //เนื้อสัตว์
        var meat = (selectedFoodItem?.selectedOption != null)
            ? selectedFoodItem.selectedOption
            : '';
        //ความเผ็ด
        var spiciness = (selectedFoodItem?.selectedlevel != null)
            ? selectedFoodItem.selectedlevel
            : '';
        //เพิ่มไข่
        var Kai1 =
            (selectedFoodItem?.Kai1 != null) ? selectedFoodItem.Kai1 : '';
        var Kai2 =
            (selectedFoodItem?.Kai2 != null) ? selectedFoodItem.Kai2 : '';
        var kai3 =
            (selectedFoodItem?.Kai3 != null) ? selectedFoodItem.Kai3 : '';

        //รายละเอียดเพิ่มเติมห
        var textmore = (selectedFoodItem?.enteredText != null)
            ? selectedFoodItem.enteredText
            : '';
        var MealNameEN = mealNameEN;

        var Spiciness = spicinessOptionname;

        var Special = selectedspecial;
        var Textmore = textmore;

        //ราคาเนื้อสัตว์
        var totalMet = ' ${selectedFoodItem.price} ';
        var totallevel = ' ${selectedFoodItem.level} ';
        //ราคาไข่ดาวไม่สุก
        var totalKai1 =
            (selectedFoodItem?.Kai1 != null) ? ' ${selectedFoodItem.egg1}' : '';
        //ราคาไข่ดาวสุก
        var totalKai2 =
            (selectedFoodItem?.Kai2 != null) ? ' ${selectedFoodItem.egg2}' : '';
        // ราคาไข่เจียว
        var totalKai3 =
            (selectedFoodItem?.Kai3 != null) ? ' ${selectedFoodItem.egg3}' : '';
        //ราคาพิเศษ
        var totalSpecial = (selectedFoodItem?.selectedValue != null)
            ? ' ${selectedFoodItem.special}'
            : '';
        //ราคาอาหาร
        var totalForIndex = ' ${mealPrice} ';
        //จำนวนอาหาร
        final countsList = (category == 'Steak')
            ? _foodOptionController.countListCat1
            : (category == 'Drinks')
                ? _foodOptionController.countListCat2
                : (category == 'Foods')
                    ? _foodOptionController.countListCat3
                    : (category == 'Noodles')
                        ? _foodOptionController.countListCat4
                        : _foodOptionController.countList;
        var countForIndex = '${countsList[currentIndex]} x';
        var special = (selectedFoodItem?.selectedValue != null)
            ? selectedFoodItem.selectedValue
            : '';
        final paddingbefore = '${padding('', 9)}${padding('-', 2)}';

        // printer
        printer.text(
          '${padding('', 2)}${padding(countForIndex, 7)}${padding(omitted(mealNameEN), 32)}${padding(totalForIndex, 0)}',
        );
        printer.text(
          '${padding('', 9)}${Description}',
        );

        (selectedFoodItem?.selectedOption != null)
            ? printer.text('${paddingbefore}${padding(omitted(meat), 30)}')
            : '';
        (selectedFoodItem?.selectedlevel != null)
            ? printer.text('${paddingbefore}${padding(omitted(spiciness), 30)}')
            : '';
        (selectedFoodItem?.Kai1 != null)
            ? printer.text('${paddingbefore}${padding(omitted(kainame), 30)}')
            : '';
        (selectedFoodItem?.Kai2 != null)
            ? printer.text('${paddingbefore}${padding(omitted(kainame1), 30)}')
            : '';
        (selectedFoodItem?.Kai3 != null)
            ? printer.text('${paddingbefore}${padding(omitted(kainame2), 30)}')
            : '';
        (selectedFoodItem?.selectedValue != null)
            ? printer.text('${paddingbefore}${padding(omitted(special), 30)}')
            : '';
        (selectedFoodItem?.enteredText != null)
            ? printer
                .text('${padding('', 9)}- Note ${selectedFoodItem.enteredText}')
            : '';
        printer.text('${line}',
            styles: PosStyles(
              align: PosAlign.center,
            ));
      }

      printer.cut();
      printer.disconnect();
    } else {
      print('Failed to connect to the printer.');
    }
  } catch (e) {
    print('Error: $e');
  }
}
