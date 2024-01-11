import 'dart:convert';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/save_menu.dart';
import 'package:diacritic/diacritic.dart';

class UsbDeviceController extends GetxController {
  final devices = RxList<Map<String, dynamic>>();
  final FlutterUsbPrinter flutterUsbPrinter = FlutterUsbPrinter();
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final RxBool connected = false.obs;
  int moneyPosition = 0;
  RxInt vendorIds = 0.obs;
  RxInt productIds = 0.obs;
  final dataKios _dataKios = Get.put(dataKios());
  ScreenshotController screenshotController = ScreenshotController();

  Future<void> connect(int vendorId, int productId) async {
    try {
      bool returned = await flutterUsbPrinter.connect(vendorId, productId);
      if (returned) {
        connected.value = true;
      }
    } on PlatformException catch (e) {
      print('Connection error: $e');
    }
  }

  Future<void> prints() async {
    try {
      String slip =
          'Queue ${_dataKios.queue.value} Successfully printed slip : ${_foodOptionController.formattedDate}';
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);
      final ByteData dataImag = await rootBundle.load('assets/logo.png');
      final Uint8List bytesImg = dataImag.buffer.asUint8List();
      final img.Image image = img.decodeImage(bytesImg);
      final int newWidth = 160;
      final int newHeight = 160;
      final Uint8List resizedImage =
          await FlutterImageCompress.compressWithList(
        bytesImg,
        minWidth: newWidth,
        minHeight: newHeight,
        format: CompressFormat.png,
        quality: 95,
      );
      String omitted(String text) {
        return text.length <= 20 ? text : '${text.substring(0, 20)}...';
      }

      var maxLength = 32;
      var Money = utf8.encode('Money');

      String price(String text, int priceLength) {
        final spacesToAdd = priceLength - text.length;
        if (spacesToAdd <= 0) {
          return text;
        }
        return text + ' ' * spacesToAdd;
      }

      var textprice = '';
      var priceLength = 36; // ความยาวที่คุณต้องการให้ข้อความอยู่ในตำแหน่งเดิม
      var paddedprice = price(textprice, priceLength);
      String Thank(String text, int ThankLength) {
        final spacesToAdd = ThankLength - text.length;
        if (spacesToAdd <= 0) {
          return text; // ไม่ต้องเพิ่มช่องว่างถ้าความยาวเกินหรือเท่ากับความยาวที่ต้องการ
        }
        return text + ' ' * spacesToAdd;
      }

      var textThank = '';
      var ThankLength = 8; // ความยาวที่คุณต้องการให้ข้อความอยู่ในตำแหน่งเดิม
      var paddedThank = price(textThank, ThankLength);

      String Net_price(String text, int Net_priceLength) {
        final spacesToAdd = Net_priceLength - text.length;
        if (spacesToAdd <= 0) {
          return text; // ไม่ต้องเพิ่มช่องว่างถ้าความยาวเกินหรือเท่ากับความยาวที่ต้องการ
        }
        return text + ' ' * spacesToAdd;
      }

      var textNet_price = '';
      var Net_priceLength =
          33; // ความยาวที่คุณต้องการให้ข้อความอยู่ในตำแหน่งเดิม
      var paddedNet_price = Net_price(textNet_price, Net_priceLength);
      String vat(String text, int vatLength) {
        final spacesToAdd = vatLength - text.length;
        if (spacesToAdd <= 0) {
          return text; // ไม่ต้องเพิ่มช่องว่างถ้าความยาวเกินหรือเท่ากับความยาวที่ต้องการ
        }
        return text + ' ' * spacesToAdd;
      }

      var textvat = '';
      var vatLength = 30; // ความยาวที่คุณต้องการให้ข้อความอยู่ในตำแหน่งเดิม
      var paddedvat = price(textvat, vatLength);
      String padcount(String text, int desiredLength) {
        final spacesToAdd = desiredLength - text.length;
        if (spacesToAdd <= 0) {
          return text; // ไม่ต้องเพิ่มช่องว่างถ้าความยาวเกินหรือเท่ากับความยาวที่ต้องการ
        }
        return text + ' ' * spacesToAdd;
      }

      var textToKeepInPosition = '';
      var desiredLength = 1; // ความยาวที่คุณต้องการให้ข้อความอยู่ในตำแหน่งเดิม
      var paddedText = padcount(textToKeepInPosition, desiredLength);

      String paddes(String text, int desLength) {
        final spacesToAdd = desLength - text.length;
        if (spacesToAdd <= 0) {
          return text; // ไม่ต้องเพิ่มช่องว่างถ้าความยาวเกินหรือเท่ากับความยาวที่ต้องการ
        }
        return text + ' ' * spacesToAdd;
      }

      var textdes = '';
      var desLength = 9;
      var paddeddesText = paddes(textdes, desLength);

      //แปลงเป็น Thai
      var ForRestaurant = ('(Restaurant)');
      var ForCustomer = ('(Customers)');
      /* Uint8List ForRestaurant =
          await CharsetConverter.encode('TIS-620', '(Restaurant)');
      Uint8List ForCustomer =
          await CharsetConverter.encode('TIS-620', '(Customers)');*/
      if (image != null) {
        var list = <int>[];
        var choose = _foodOptionController.choose.value;
        var Choose = utf8.encode(choose);
        var allTotal = ' ${_foodOptionController.total_price.value}';
        var VAT7 =
            ' ${_foodOptionController.calculateTotalWithVAT().toString()}';
        var netPrice = '${_foodOptionController.NetPrice().toString()}';
        var namePay = '${_foodOptionController.paymentsName.value.toString()}';
        var maxLength = 32;
        var nameRes = "Restaurant name";
        var Nameres = utf8.encode(nameRes);
        var formattedDate =
            DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
        var line = '-----------------------------------------------';
        var kiosID = _dataKios.reqKiosdata[0]['kiosks']['kiosksId'];
        var Description = 'Description';
        var imageLogo = generator.image(img.decodeImage(resizedImage));
        var spacesBefore = maxLength - nameRes.length;
        var spacesAfter = maxLength + nameRes.length;
        var Money = '฿';
        var Total = 'Price';
        var Vat = 'VAT 7.00%';
        var Net_price = 'Net price';
        var Thank = 'Thank you for using our service';
        var Note = '- Note: ';
        var queue = _dataKios.que.value;
        var branchName = _dataKios.branchName.value;
        var Numqueue = '${branchName.toString()} ${queue.toString()}';
        var cutCommand = Uint8List.fromList([0x1D, 0x56, 0x00]);
        /*  Uint8List Money = await CharsetConverter.encode('TIS-620', '฿');
        /* Uint8List Total = await CharsetConverter.encode('TIS-620', 'ราคา');*/
        Uint8List Note = await CharsetConverter.encode('TIS-620', '- Note: ');*/
        /* Uint8List Vat =
            await CharsetConverter.encode('TIS-620', 'ภาษีมูลค่าเพิ่ม');
        Uint8List Net_price =
            await CharsetConverter.encode('TIS-620', 'ราคาสุทธิ');
        Uint8List Thank =
            await CharsetConverter.encode('TIS-620', 'ขอบคุณที่ใช้บริการ');
        Uint8List Note =
            await CharsetConverter.encode('TIS-620', '- หมายเหตุ: ');*/
        /*final double noteFontSize =
            18; // กำหนดขนาดของข้อความ '- หมายเหตุ:' ที่คุณต้องการ
        final noteText = Text(
          '- หมายเหตุ:',
          style: TextStyle(
            fontSize: noteFontSize, // ใช้ fontSize ที่คุณกำหนด
            fontWeight:
                FontWeight.bold, // ตั้งค่าแบบหนาหรือตัวอื่นๆ ตามที่คุณต้องการ
          ),
        );
        String noteString = noteText.data;
        Uint8List noteBytes =
            await CharsetConverter.encode('TIS-620', noteString);*/

        list.addAll(imageLogo);
        list.addAll([0x20]);
        list.addAll(utf8.encode(Numqueue));
        list.addAll([0x0A]);
        list.addAll([0x20]);
        list.addAll(Nameres);
        list.addAll([0x0A]);
        list.addAll([0x20]);
        list.addAll(utf8.encode(ForRestaurant));
        list.addAll([0x0A]);
        list.addAll([0x20]);
        list.addAll(Choose);
        list.addAll([0x0A]);
        list.addAll([0x20]);
        list.addAll(utf8.encode("Ordered at $formattedDate"));
        list.addAll([0x0A]);
        list.addAll([0x20]);
        list.addAll(utf8.encode('Kiosk ID# $kiosID'));
        list.addAll([0x0A, 0x20]);
        list.addAll(utf8.encode('$line'));
        list.addAll([0x0A]);

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
          //
          final kaiIndex =
              optionKai.containsKey('option') ? optionKai['option'] : [];
          //
          final kai = kaiIndex.isNotEmpty ? kaiIndex[0] : {};
          final kainame = kai.containsKey('name') ? kai['name'] : '';
          final kaiprice =
              kai.containsKey('price') ? kai['price'].toDouble() : 0.toDouble();
          //
          final kai1 = kaiIndex.isNotEmpty ? kaiIndex[1] : {};
          final kainame1 = kai1.containsKey('name') ? kai1['name'] : '';
          final kaiprice1 = kai1.containsKey('price')
              ? kai1['price'].toDouble()
              : 0.toDouble();
          //
          final kai2 = kaiIndex.isNotEmpty ? kaiIndex[2] : {};
          final kainame2 = kai2.containsKey('name') ? kai2['name'] : '';
          final kaiprice2 = kai2.containsKey('price')
              ? kai2['price'].toDouble()
              : 0.toDouble();
          //โค้ดพิเศษ
          final optionspecial = mealOptions.length > 3 ? mealOptions[3] : {};
          final specialIndex = optionspecial.containsKey('option')
              ? optionspecial['option']
              : [];
          final selectedspecial =
              specialIndex.isNotEmpty ? specialIndex[0] : {};
          final selectedname = selectedspecial.containsKey('name')
              ? selectedspecial['name']
              : '';
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
          //พิเศษ
          var special = (selectedFoodItem?.selectedValue != null)
              ? selectedFoodItem.selectedValue
              : '';
          //รายละเอียดเพิ่มเติมห
          var textmore = (selectedFoodItem?.enteredText != null)
              ? selectedFoodItem.enteredText
              : '';
          var MealNameEN = mealNameEN;

          var Spiciness = spicinessOptionname;

          var Special = selectedspecial;
          var Textmore = textmore;

          /*  Uint8List MealNameEN =
              await CharsetConverter.encode('TIS-620', mealNameEN);
          Uint8List MealOptionname =
              await CharsetConverter.encode('TIS-620', mealOption['name']);

          Uint8List Meat = await CharsetConverter.encode('TIS-620', meat);
          Uint8List Spiciness =
              await CharsetConverter.encode('TIS-620', spiciness);
          Uint8List Kai1 = await CharsetConverter.encode('TIS-620', kai1);
          Uint8List Kai2 = await CharsetConverter.encode('TIS-620', kai2);
          Uint8List Kai3 = await CharsetConverter.encode('TIS-620', kai3);
          Uint8List Special = await CharsetConverter.encode('TIS-620', special);
          Uint8List Textmore =
              await CharsetConverter.encode('TIS-620', textmore);*/

          //ราคาเนื้อสัตว์
          var totalMet = ' ${selectedFoodItem.price} ';
          var totallevel = ' ${selectedFoodItem.level} ';
          //ราคาไข่ดาวไม่สุก
          var totalKai1 = (selectedFoodItem?.Kai1 != null)
              ? ' ${selectedFoodItem.egg1}'
              : '';
          //ราคาไข่ดาวสุก
          var totalKai2 = (selectedFoodItem?.Kai2 != null)
              ? ' ${selectedFoodItem.egg2}'
              : '';
          // ราคาไข่เจียว
          var totalKai3 = (selectedFoodItem?.Kai3 != null)
              ? ' ${selectedFoodItem.egg3}'
              : '';
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

          String padFood(String text, int foodLength) {
            final spacesToAdd = foodLength - text.length;
            if (spacesToAdd <= 0) {
              return text;
            }
            return text + ' ' * spacesToAdd;
          }

          var textfood = '';
          var foodLength = countsList[currentIndex] < 10 ? 5 : 4;
          var paddedfoodText = padFood(textfood, foodLength);
          list.addAll([0x1B, 0x61, 0x00]);
          list.addAll(utf8.encode(paddedText));
          list.addAll(utf8.encode('$countForIndex'));
          list.addAll(utf8.encode(paddedfoodText));
          list.addAll(utf8.encode(omitted(mealNameEN)));

          // ลบตัวสระบนล่างออก
          /* String removeDiacritics(String text) {
            return text.replaceAll(RegExp('[่ ้ ๊ ๋ ็ ั ์ ิ ี ึ ืุ ู]'), '');
          }*/

          // ความยาวที่คุณต้องการให้บรรทัดมี
          var maxLength = 30;
          var maxLengthformenu = 32;

          //ระยะห่างคิดจากตัวอักษรเมนู
          var Menuname = (omitted(mealNameEN));
          var Delete_tone_menu = removeDiacritics(Menuname);
          var MenuLength = Delete_tone_menu.length;
          var addedTextMenuLength = MenuLength;
          var MenuToMoney = maxLengthformenu - addedTextMenuLength;
          for (var i = 0; i < MenuToMoney; i++) {
            list.add(32); // 32 คือรหัส ASCII ของช่องว่าง
          }
          //list.addAll(Money);
          list.addAll(utf8.encode(totalForIndex));
          list.addAll([0x0A]);
          list.addAll(utf8.encode(paddeddesText));
          list.addAll(utf8.encode('$Description'));
          list.addAll([0x0A]);
          (selectedFoodItem?.selectedOption != null)
              ? list.addAll(utf8.encode(paddeddesText))
              : '';
          (selectedFoodItem?.selectedOption != null)
              ? list.addAll(utf8.encode('- '))
              : '';
          (selectedFoodItem?.selectedOption != null)
              ? list.addAll(utf8.encode(omitted(meat)))
              : '';

          //ระยะห่างคิดจากตัวอักษรเนื้อสัตว์
          var mealOptionnames = (omitted(meat));
          print('ชื่อเนื้อ: ${mealOptionname}');
          var Delete_tone_meat = removeDiacritics(mealOptionnames);
          // var Delete_tone_meat = mealOptionname;

          var MeatLength = Delete_tone_meat.length;
          var addedTextMeatLength = MeatLength;
          var MeatToMoney = maxLength - addedTextMeatLength;
          for (var i = 0; i < MeatToMoney; i++) {
            list.add(32); // 32 คือรหัส ASCII ของช่องว่าง
          }

          // list.addAll(Money);
          (selectedFoodItem?.selectedOption != null)
              ? list.addAll((utf8.encode(totalMet)))
              : '';
          (selectedFoodItem?.selectedOption != null) ? list.addAll([0x0A]) : '';
          (selectedFoodItem?.selectedlevel != null)
              ? list.addAll(utf8.encode(paddeddesText))
              : '';
          (selectedFoodItem?.selectedlevel != null)
              ? list.addAll(utf8.encode('- '))
              : '';
          (selectedFoodItem?.selectedlevel != null)
              ? list.addAll(utf8.encode(omitted(spiciness)))
              : '';
          var Spicy_level = (omitted(spiciness));
          var Delete_tone_Spicylevel = removeDiacritics(Spicy_level);
          var SpicylevelLength = Spicy_level.length;
          var SpicylevelTextMeatLength = SpicylevelLength;
          var SpicylevelToMoney = maxLength - SpicylevelTextMeatLength;
          for (var i = 0; i < SpicylevelToMoney; i++) {
            list.add(32); // 32 คือรหัส ASCII ของช่องว่าง
          }
          // list.addAll(Money);
          (selectedFoodItem?.selectedlevel != null)
              ? list.addAll((utf8.encode(totallevel)))
              : '';
          (selectedFoodItem?.selectedlevel != null) ? list.addAll([0x0A]) : '';
          (selectedFoodItem?.Kai1 != null)
              ? list.addAll(utf8.encode(paddeddesText))
              : '';
          (selectedFoodItem?.Kai1 != null)
              ? list.addAll(utf8.encode('- '))
              : '';
          (selectedFoodItem?.Kai1 != null)
              ? list.addAll(utf8.encode(omitted(kainame)))
              : '';
          if (selectedFoodItem?.Kai1 != null) {
            var Kain1 = (omitted(kainame));
            var Kai1Length = Kain1.length;
            var addedTextKai1Length = Kai1Length;
            var Kai1ToMoney = maxLength - addedTextKai1Length;
            for (var i = 0; i < Kai1ToMoney; i++) {
              list.add(32); // 32 คือรหัส ASCII ของช่องว่าง
            }
          } else {
            '';
          }

          (selectedFoodItem?.Kai1 != null)
              ? list.addAll(utf8.encode(totalKai1))
              : '';
          (selectedFoodItem?.Kai1 != null) ? list.addAll([0x0A]) : '';
          (selectedFoodItem?.Kai2 != null)
              ? list.addAll(utf8.encode(paddeddesText))
              : '';
          (selectedFoodItem?.Kai2 != null)
              ? list.addAll(utf8.encode('- '))
              : '';
          (selectedFoodItem?.Kai2 != null)
              ? list.addAll(utf8.encode(omitted(kainame1)))
              : '';
          if (selectedFoodItem?.Kai2 != null) {
            var Kain2 = (omitted(kainame1));
            ;
            /* print('ชื่อเนื้อ: ${Kai2}');
            var Delete_tone_Kai2 = removeDiacritics(Kain2);
            print('ก่อนรีมูฟเนื้อ: ${Kai2.length}');
            print('หลังรีมูฟเนื้อ: ${Delete_tone_Kai2.length}');*/

            var Kai2Length = Kain2.length;
            var addedTextKai2Length = Kai2Length;
            var Kai2ToMoney = maxLength - addedTextKai2Length;
            for (var i = 0; i < Kai2ToMoney; i++) {
              list.add(32); // 32 คือรหัส ASCII ของช่องว่าง
            }
            // list.addAll(utf8.encode(paddeddesText));
          } else {
            null;
          }
          (selectedFoodItem?.Kai2 != null)
              ? '' //list.addAll((Money))
              : '';
          (selectedFoodItem?.Kai2 != null)
              ? list.addAll(utf8.encode(totalKai2))
              : '';
          (selectedFoodItem?.Kai2 != null) ? list.addAll([0x0A]) : '';
          (selectedFoodItem?.Kai3 != null)
              ? list.addAll(utf8.encode(paddeddesText))
              : '';
          (selectedFoodItem?.Kai3 != null)
              ? list.addAll(utf8.encode('- '))
              : '';
          (selectedFoodItem?.Kai3 != null)
              ? list.addAll(utf8.encode(omitted(kainame2)))
              : '';
          if (selectedFoodItem?.Kai3 != null) {
            var Kain3 = (omitted(kainame2));
            /* print('ชื่อเนื้อ: ${Kai3}');
            var Delete_tone_Kai3 = removeDiacritics(Kain3);
            print('ก่อนรีมูฟเนื้อ: ${Kai3.length}');
            print('หลังรีมูฟเนื้อ: ${Delete_tone_Kai3.length}');*/

            var Kai3Length = Kain3.length;
            var addedTextKai3Length = Kai3Length;
            var Kai3ToMoney = maxLength - addedTextKai3Length;
            for (var i = 0; i < Kai3ToMoney; i++) {
              list.add(32); // 32 คือรหัส ASCII ของช่องว่าง
            }
          } else {
            '';
          }
          (selectedFoodItem?.Kai3 != null)
              ? '' //list.addAll((Money))
              : '';
          (selectedFoodItem?.Kai3 != null)
              ? list.addAll(utf8.encode(totalKai3))
              : '';
          (selectedFoodItem?.Kai3 != null) ? list.addAll([0x0A]) : '';

          (selectedFoodItem?.selectedValue != null)
              ? list.addAll(utf8.encode(paddeddesText))
              : '';
          (selectedFoodItem?.selectedValue != null)
              ? list.addAll(utf8.encode('- '))
              : '';
          (selectedFoodItem?.selectedValue != null)
              ? list.addAll(utf8.encode(omitted(special)))
              : '';
          if (selectedFoodItem?.selectedValue != null) {
            var Special = (omitted(special));
            /*  print('ชื่อเนื้อ: ${Special}');
            var Delete_tone_Special = removeDiacritics(Special);
            print('ก่อนรีมูฟเนื้อ: ${Special.length}');
            print('หลังรีมูฟเนื้อ: ${Delete_tone_Special.length}');*/

            var SpecialLength = Special.length;
            var addedTextSpecialLength = SpecialLength;
            var SpecialToMoney = maxLength - addedTextSpecialLength;
            for (var i = 0; i < SpecialToMoney; i++) {
              list.add(32); // 32 คือรหัส ASCII ของช่องว่าง
            }
            // list.addAll(utf8.encode(paddeddesText));
          } else {
            '';
          }

          (selectedFoodItem?.selectedValue != null)
              ? '' //list.addAll((Money))
              : '';
          list.addAll(utf8.encode(totalSpecial));

          (selectedFoodItem?.selectedValue != null) ? list.addAll([0x0A]) : '';
          (selectedFoodItem?.enteredText != null)
              ? list.addAll(utf8.encode(paddeddesText))
              : '';
          (selectedFoodItem?.enteredText != null)
              ? list.addAll(utf8.encode(Note)) //list.addAll((Note))
              : '';
          list.addAll(utf8.encode(Textmore));

          (selectedFoodItem?.enteredText != null) ? list.addAll([0x0A]) : '';
          list.addAll([0x20]);
          list.addAll(utf8.encode('$line'));
          list.addAll([0x0A]);
        }

        list.addAll(utf8.encode(paddedText));
        list.addAll(utf8.encode(namePay));
        list.addAll([0x0A]);
        list.addAll(utf8.encode(paddedText));
        list.addAll(utf8.encode(Total));
        //
        var maxLengthstotal = 40;
        var TotalLength = Total;
        var Delete_tone_Total = removeDiacritics(TotalLength);
        print('ก่อนรีมูฟเมนู: ${TotalLength.length}');
        print('หลังรีมูฟเมนู: ${Delete_tone_Total.length}');
        var TotalLengths = Delete_tone_Total.length;
        var addedTextTotalLength = TotalLengths;
        var TotalToMoney = maxLengthstotal - addedTextTotalLength;
        for (var i = 0; i < TotalToMoney; i++) {
          list.add(32); // 32 คือรหัส ASCII ของช่องว่าง
        }
        list.addAll(utf8.encode(allTotal));
        list.addAll([0x0A]);
        list.addAll(utf8.encode(paddedText));
        list.addAll(utf8.encode(Vat));
//
        var VatLength = Vat;
        var Delete_tone_Vat = removeDiacritics(VatLength);
        var VatLengths = Delete_tone_Vat.length;
        var addedTextVatLength = VatLengths;
        var VatToMoney = maxLengthstotal - addedTextVatLength;
        for (var i = 0; i < VatToMoney; i++) {
          list.add(32); // 32 คือรหัส ASCII ของช่องว่าง
        }
        list.addAll(utf8.encode(VAT7));
        list.addAll([0x0A]);
        list.addAll(utf8.encode(paddedText));
        list.addAll(utf8.encode(Net_price));
//
        var AllTotalLength = Net_price;
        var Delete_tone_allTotal = removeDiacritics(AllTotalLength);
        var AllTotalLengths = Delete_tone_allTotal.length;
        var addedTextAllTotalLengths = AllTotalLengths;
        var AllTotalLengthsToMoney = maxLengthstotal - addedTextAllTotalLengths;
        for (var i = 0; i < AllTotalLengthsToMoney; i++) {
          list.add(32); // 32 คือรหัส ASCII ของช่องว่าง
        }
        list.addAll([0x20]);
        list.addAll(utf8.encode(netPrice));
        list.addAll([0x0A, 0x0A]);
        list.addAll(utf8.encode(paddedThank));
        list.addAll(utf8.encode(Thank));
        list.addAll([0x0A, 0x0A, 0x0A]);
        //ตัดกระดาษษ

        await flutterUsbPrinter.write(Uint8List.fromList(list));
        //   await Future.delayed(Duration(seconds: 1));
        await flutterUsbPrinter.write(cutCommand);
        await list.clear();
        // await LogFile(slip);
        print('พิมพ์สำเร็จ.');
      }
    } on PlatformException catch (e) {
      String error =
          'Queue ${_dataKios.queue.value} Error in printing the slip : ${_foodOptionController.formattedDate}';
      await LogFile(error);
      print('ข้อผิดพลาดในการพิมพ์: $e');
    }
  }

  @override
  void onInit() {
    connect(0x0FE6, 0x811E);
    super.onInit();
  }
}
