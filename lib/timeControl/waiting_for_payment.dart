import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/save_menu.dart';
import '../widget_sheet/fail_payment.dart';
import 'adtime.dart';
import 'package:http/http.dart' as http;

int admob_time = 30;

class waiting_for_payment extends GetxController {
  final int pay_time;
  RxInt remainingSeconds = 0.obs;
  Timer timer;
  final admob_times = Get.put(AdMobTimeController(admob_time));
  waiting_for_payment(this.pay_time);
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final dataKios _dataKios = Get.put(dataKios());
  @override
  void onInit() {
    super.onInit();
    remainingSeconds.value = pay_time;
  }

  void stopTimerAndReset() {
    timer.cancel();
    remainingSeconds.value = pay_time;
  }

  void postMenu() async {
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(currentDate);
    const url = 'http://192.168.0.9/api/devices/receiveTransactionValue';
    final uri = Uri.parse(url);
    final List<Map<String, dynamic>> dataToSend = [];
    for (int index = 0; index < _foodOptionController.orders.length; index++) {
      final currentIndex = _foodOptionController.orders[index];
      final categoryValue = _foodOptionController.categoryValues[index];
      final advert = _dataKios.advertlist[currentIndex];
      final countsList = (categoryValue == 1)
          ? _foodOptionController.countListCat1
          : _foodOptionController.countList;
      final meal = (categoryValue == 1)
          ? _dataKios.drinkList[currentIndex]
          : _dataKios.foodList[currentIndex];
      final paymentsAmount = countsList[currentIndex];
      final kiosksId = advert.kiosksId.toString();
      final mealId = meal.mealId.toString();
      final mealNameEN = meal.mealNameEN.toString();
      final mealNameTH = meal.mealNameTH.toString();
      final mealPrice = _foodOptionController
          .calculateTotal(currentIndex, categoryValue)
          .toDouble();
      final paymentsName = _foodOptionController.paymentsName.value;
      final kiosksSn = _dataKios.serialNumbers.value;
      final currentDate = DateTime.now();
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('http://192.168.0.9/api/devices/receiveTransactionValue'));
      request.body = json.encode({
        "transactionTime": formattedDate,
        "mealsId": mealId,
        "mealsPrice": mealPrice,
        "mealsName": mealNameTH,
        "paymentsName": paymentsName,
        "paymentsAmount": paymentsAmount,
        "kiosksId": kiosksId,
        "kiosksSn": kiosksSn,
        "status": 1,
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
    print('postStatusPaymentstatus ${Paymentid} ');
    var url =
        'http://192.168.0.9/api/devices/checkStatusPayment-sudden?paymentId$Paymentid';
    final uri = Uri.parse(url);
    final List<Map<String, dynamic>> dataToSend = [];
    final MchOrderNo = _dataKios.MchOrderNo.value.toString();
    print('MchOrderNo ${MchOrderNo} ');
    var headers = {'Content-Type': 'application/json'};
    try {
      var request = http.Request(
          'POST',
          Uri.parse(
              'http://192.168.0.9/api/devices/checkStatusPayment-sudden?paymentId=$Paymentid'));
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
        print('จ่ายเงิน : ${_dataKios.status.value}');
      } else {
        print('reasonPhrase ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void startTimer(BuildContext context) {
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
        print('payment ${remainingSeconds.value}');
      } else if (_dataKios.status.value == 'SUCCESS') {
        stopTimerAndReset();
      } else {
        postStatusPayment();
        _dataKios.Qrpayment = [];
        _dataKios.status.value = '';
        String Timeout =
            'Payment timeout : ${_foodOptionController.formattedDate}';
        LogFile(Timeout);
        //postMenu();
        remainingSeconds.value = pay_time;
        stopTimerAndReset();
        admob_times.startTimer(context);
        Get.back();
        Get.bottomSheet(
          WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: fail_pay_screen(),
          ),
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
          useRootNavigator: true,
        );
      }
    });
  }

  void restarttime(BuildContext context) {
    remainingSeconds.value = pay_time;
    startTimer(context);
  }

  void reset() {
    remainingSeconds.value = pay_time;
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }
}
