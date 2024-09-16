import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:screen/api/Kios_API.dart';
import 'package:screen/getxController.dart/save_menu.dart';
import 'package:screen/getxController.dart/selection.dart';
import 'package:screen/printer/printer_USB.dart';
import 'package:screen/screen/setting_screen.dart';
import 'package:screen/timeControl/adtime.dart';
import 'package:screen/timeControl/waiting%20_for_success.dart';
import 'package:screen/timeControl/waiting_for_payment.dart';
import 'package:screen/widget_sheet/successful_payment.dart';

final int admob_time = 60;

class Payment_controller extends GetxController {
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final UsbDeviceControllers usbDeviceController =
      Get.put(UsbDeviceControllers());
  final dataKios _dataKios = Get.put(dataKios());
  final set_printer = Setting_Screen();
    final SelectionController selectionController =
      Get.put(SelectionController());
  final AdMobTimeController adtimeController =
      Get.put(AdMobTimeController(admob_time: admob_time));
  Timer? timer;
  String formatTime(int seconds) {
    int minutes = (seconds ~/ 60);
    int remainingSeconds = (seconds % 60);
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<Image> CovertQR() async {
    String qrImgBase64 = _dataKios.Qrpayment[0]['qrImg'];
    String base64String = qrImgBase64.split(',').last;
    Uint8List bytes = Uint8List.fromList(base64.decode(base64String));

    return Image.memory(bytes);
  }

  void postMenu() async {
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(currentDate);
    print('formattedDate : ${formattedDate}');
    const url =
        'http://hqhitop.thddns.net:60000/api/devices/receiveTransactionValue';
    final uri = Uri.parse(url);
    final List<Map<String, dynamic>> dataToSend = [];
    for (int index = 0; index < selectionController.allMeals.length; index++) {
     final meal = selectionController.allMeals[index];
       final mealsId = meal['mealsId'];
        final category = meal['category'];
        final mealImage = meal['mealImage'];
        final mealNameEN = meal['mealNameEN'];
        final mealNameTH = meal['mealNameTH'];
        final mealDescriptionEN = meal['mealDescriptionEN'];
        final mealDescriptionTH = meal['mealDescriptionTH'];
        final mealPrice = meal['mealPrice'];
        final foodPrice = meal['foodPrice'];
        final amount = meal['amount'];
      //  final mealId = meal.mealId.toString();
        final paymentsName = selectionController.paymentsName.value;
        final kiosksSn = _dataKios.serialNumbers.value;
        final kiosksId = _dataKios.reqKiosdata[0]['kiosks']['kiosksId'];
      // เพิ่มข้อมูลแต่ละรายการลงใน List
      final currentDate = DateTime.now();
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse(
              'http://hqhitop.thddns.net:60000/api/devices/receiveTransactionValue'));
      request.body = json.encode({
        "transactionTime": formattedDate,
        "mealsId": mealsId,
        "mealsPrice":foodPrice ,
        "mealsName": mealNameEN,
        "paymentsName": paymentsName,
        "paymentsAmount": amount,
        "kiosksId": kiosksId,
        "kiosksSn": kiosksSn,
        "status": 0,
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    }
  }

  Future<void> postStatusPayment() async {
    String Paymentid = _dataKios.paymentdata[0].paymentId;

    var url =
        'http://hqhitop.thddns.net:60000/api/devices/checkStatusPayment?paymentId=$Paymentid';
    final uri = Uri.parse(url);
    final List<Map<String, dynamic>> dataToSend = [];
    final MchOrderNo = _dataKios.MchOrderNo.value.toString();
    print('MchOrderNo ${MchOrderNo} ');
    var headers = {'Content-Type': 'application/json'};
    try {
      var request = http.Request(
          'POST',
          Uri.parse(
              'http://hqhitop.thddns.net:60000/api/devices/checkStatusPayment?paymentId=$Paymentid'));
      request.body = json.encode({"mchOrderNo": MchOrderNo});
      request.headers.addAll(headers);
      http.Client client = http.Client();
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseBody);
        final Status = jsonResponse['status'];
        final paymentStatus = jsonResponse['paymentStatus'];
        _dataKios.status.value = paymentStatus;
      } else {
        print('reasonPhrase ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void PostStatusPayment() async {
    await postStatusPayment();
  }

  Future<void> checkQueue() async {
    String kiosksId = _dataKios.reqKiosdata[0]['kiosks']['kiosksId'];
    var url = 'http://192.168.0.9/api/devices/queueOrder?kioskId=$kiosksId';
    final uri = Uri.parse(url);
    final List<Map<String, dynamic>> dataToSend = [];

    var headers = {'Content-Type': 'application/json'};
    try {
      var request = http.Request(
          'POST',
          Uri.parse(
              'http://192.168.0.9/api/devices/queueOrder?kioskId=$kiosksId'));
      request.body = json.encode({"kiosksId": kiosksId});
      request.headers.addAll(headers);
      http.Client client = http.Client();
      http.StreamedResponse response = await request.send();
      print('postStatusPaymentstatus : ${response.statusCode}');
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseBody);
        final orderNumber = jsonResponse['orderNumber'];
        final branchName = jsonResponse['branchName'];
        _dataKios.que.value = orderNumber;
        _dataKios.branchName.value = branchName;
      } else {
        print('reasonPhrase ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void checkStatus(BuildContext context) async {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final int pay_times = 180;
    final int admob_times = 60;
    final int successful_times = 10;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time: admob_times));
    final successful_time_controller =
        Get.put(waiting_for_success(successful_times));
    final pay_time_controller =
        Get.put(waiting_for_payment(pay_time: pay_times));
    if (_dataKios.status.value == 'SUCCESS') {
      await checkQueue();
      if (_dataKios.connected.value == true) {
        await usbDeviceController.prints();
      //  await printToNetworkPrinter();
      }
      _dataKios.Qrpayment = [];
      _dataKios.status.value = '';
      _dataKios.printer_on.value = true;
    //  postMenu();
      adtimeController.stopTimerAndReset();
      pay_time_controller.stopTimerAndReset();
      successful_time_controller.startTimer(context);
      showFlexibleBottomSheet(
       initHeight: 0.861,
       isDismissible: false,
       context: context,
       bottomSheetBorderRadius: BorderRadius.only(
       topLeft: Radius.circular(sizeWidth*0.05),
       topRight: Radius.circular(sizeWidth*0.05),
       ),
       builder: (context, controller, offset) {
       return NotificationListener<OverscrollIndicatorNotification>(
      onNotification:(OverscrollIndicatorNotification notification) {
      notification.disallowIndicator();
      return false;
      },
      child: successful_payment(),
            );
          });

      String conNect =
          'Printer connected : ${_foodOptionController.formattedDate}';
      LogFile(conNect);
    } else {
      String Notcon =
          'Printer is not connected : ${_foodOptionController.formattedDate}';
      LogFile(Notcon);
    }
  }
  // }

  void CheckStatus(BuildContext context) {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      checkStatus(context);

      if (_dataKios.status.value == 'SUCCESS') {
        timer?.cancel();
      } else {
        print('จ่ายเงินเท่ากับ : ${_dataKios.status.value}');
      }
    });
  }
}
