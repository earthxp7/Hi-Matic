import 'dart:convert';
import 'package:charset_converter/charset_converter.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:screen/getxController.dart/selection.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/save_menu.dart';
import 'package:diacritic/diacritic.dart';

class UsbDeviceControllers extends GetxController {
  final devices = RxList<Map<String, dynamic>>();
    final SelectionController selectionController =
      Get.put(SelectionController());
  final FlutterUsbPrinter flutterUsbPrinter = FlutterUsbPrinter();
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  int moneyPosition = 0;
  RxInt vendorIds = 0.obs;
  RxInt productIds = 0.obs;
  final dataKios _dataKios = Get.put(dataKios());
  ScreenshotController screenshotController = ScreenshotController();

  Future<void> prints() async {
    try {
      String slip =
          'Queue ${_dataKios.queue.value} Successfully printed slip : ${_foodOptionController.formattedDate}';
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);
      final ByteData dataImag =
          await rootBundle.load('assets/Yayoi_Logo_small.png');
      final Uint8List bytesImg = dataImag.buffer.asUint8List();
      final img.Image? image = img.decodeImage(bytesImg);
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
      var ForRestaurant = ('(ร้านค้า)');
      var ForCustomer = ('(Customers)');
       Uint8List ForRestaurants =
          await CharsetConverter.encode('TIS-620', '(Restaurant)');
     /* Uint8List ForCustomer =
          await CharsetConverter.encode('TIS-620', '(Customers)');*/
      if (image != null) {
        var list = <int>[];
        var choose = _foodOptionController.choose.value;
        var Choose = utf8.encode(choose);
        var allTotal = ' ${selectionController.totalPrice.value}';
        var VAT7 =
            ' ${selectionController.calculateTotalWithVAT().toString()}';
        var netPrice = '${selectionController.NetPrice().toString()}';
        var namePay = '${selectionController.paymentsName.value.toString()}';
        var maxLength = 32;
        var nameRes = "Restaurant name";
        var Nameres = utf8.encode(nameRes);
        var formattedDate =
            DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
        var line = '-----------------------------------------------';
        var kiosID = _dataKios.reqKiosdata[0]['kiosks']['kiosksId'];
        var Description = 'Description';
        var decodedImage = img.decodeImage(resizedImage);
        var imageLogo = generator.image(decodedImage ?? img.Image(1, 1));
       
        var Total = 'Price';
        var Vat = 'VAT 7.00%';
        var Net_price = 'Net price';
        var Thank = 'Thank you for using our service';
        var Note = '- Note: ';
        var queue = _dataKios.que.value;
        var branchName = _dataKios.branchName.value;
        var Numqueue = '${branchName.toString()} ${queue.toString()}';
        var cutCommand = Uint8List.fromList([0x1D, 0x56, 0x00]);
       /* Uint8List Money = await CharsetConverter.encode('TIS-620', '฿');
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

        for (int i = 0; i < selectionController.allMeals.length; i++) {
            final meal = selectionController.allMeals[i];
            final category = meal['category'];
            final mealImage = meal['mealImage'];
            final mealNameEN = meal['mealNameEN'];
            final mealNameTH = meal['mealNameTH'];
            final mealDescriptionEN = meal['mealDescriptionEN'];
            final mealDescriptionTH = meal['mealDescriptionTH'];
            final mealPrice = meal['mealPrice']?? ' 0.0';
            final foodPrice = meal['foodPrice']?? ' 0.0';
            final amount = meal['amount'];
            final note = meal['note'];
            final mealOptions = meal['mealoption'] ?? [];
            final optionsList = <Map<String, dynamic>>[];
          
            var maxLength = 30;
            var maxLengthformenu = 32;
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

             // ลบตัวสระบนล่างออก
          /* String removeDiacritics(String text) {
            return text.replaceAll(RegExp('[่ ้ ๊ ๋ ็ ั ์ ิ ี ึ ืุ ู]'), '');
          }*/

          String padFood(String text, int foodLength) {
            final spacesToAdd = foodLength - text.length;
            if (spacesToAdd <= 0) {
              return text;
            }
            return text + ' ' * spacesToAdd;
          }

          var textfood = '';
          var foodLength = amount < 10 ? 5 : 4;
          var paddedfoodText = padFood(textfood, foodLength);
          list.addAll([0x1B, 0x61, 0x00]);
          list.addAll(utf8.encode(paddedText));
          list.addAll(utf8.encode('$amount x'));
          list.addAll(utf8.encode(paddedfoodText));
          list.addAll(utf8.encode(omitted(mealNameEN)));
       
          //ระยะห่างคิดจากตัวอักษรเมนู
          var Menuname = (omitted(mealNameEN));
          var Delete_tone_menu = removeDiacritics(Menuname);
          var MenuLength = Delete_tone_menu.length;
          var addedTextMenuLength = MenuLength;
          var MenuToMoney = maxLengthformenu - addedTextMenuLength;
          for (var i = 0; i < MenuToMoney; i++) {
            list.add(32); // 32 คือรหัส ASCII ของช่องว่าง
          }
          
          list.addAll(utf8.encode(mealPrice.toString()));
          list.addAll([0x0A]);    
          if(mealOptions.isNotEmpty ){
          list.addAll(utf8.encode(paddeddesText));  
          list.addAll(utf8.encode('$Description'));
          list.addAll([0x0A]);
         // ตรวจสอบว่า mealOptions เป็น List<Map<String, dynamic>> หรือไม่
          if (mealOptions is List<Map<String, dynamic>>) {
          for (final option in mealOptions) {
            final value = option['value'];
            final price = double.tryParse(option['price']?.toString() ?? ' 0.0') ?? ' 0.0';

          list.addAll(utf8.encode(paddeddesText));
          list.addAll(utf8.encode('- '));
          list.addAll(utf8.encode(omitted(value)));

          var mealOptionnames = (omitted(value));
          var Delete_tone_meat = removeDiacritics(mealOptionnames);
          var MeatLength = Delete_tone_meat.length;
          var addedTextMeatLength = MeatLength;
          var MeatToMoney = maxLength - addedTextMeatLength;
          for (var i = 0; i < MeatToMoney; i++) {
            list.add(32); // 32 คือรหัส ASCII ของช่องว่าง
          } 
                 
          list.addAll((utf8.encode(price.toString())));
          list.addAll([0x0A]);
          }
        }
       } 
        if(note != ''){
          list.addAll(utf8.encode(paddeddesText));
          list.addAll(utf8.encode(Note));
          list.addAll(utf8.encode(note));
          list.addAll([0x0A]);
        }        
          //list.addAll(utf8.encode(paddeddesText));
         if(mealOptions.isEmpty && note == ''){
          list.addAll([0x0A, 0x20]);
         }
          list.addAll(utf8.encode('$line'));
          list.addAll([0x0A]);
        }
        list.addAll(utf8.encode(paddedText));
        list.addAll(utf8.encode(namePay));
        list.addAll([0x0A, 0x20]);
        list.addAll(utf8.encode('$line'));
        list.addAll([0x0A]);
        list.addAll(utf8.encode(paddedText));
        list.addAll(utf8.encode(Total));
        //
        var maxLengthstotal = 40;
        var TotalLength = Total;
        var Delete_tone_Total = removeDiacritics(TotalLength);
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

        await flutterUsbPrinter.write(Uint8List.fromList(list));
        list.clear();
        await Future.delayed(Duration(seconds: 1));
        await flutterUsbPrinter.write(cutCommand);

        // await LogFile(slip);
        print('พิมพ์สำเร็จ.');
      }
    } on PlatformException catch (e) {
      String error =
          'Queue ${_dataKios.queue.value} Error in printing the slip : ${_foodOptionController.formattedDate}';
      LogFile(error);
      print('ข้อผิดพลาดในการพิมพ์: $e');
    }
  }
}
