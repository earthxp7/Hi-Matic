import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:screen/timeControl/waiting%20_for_success.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/amount_food.dart';
import '../getxController.dart/save_menu.dart';
import '../printer/printer_USB.dart';
import '../screen/loadOrder_screen.dart';
import '../screen/notAvailable_screen.dart';
import '../widget_sheet/fail_payment.dart';
import '../widget_sheet/food_option.dart';
import '../widget_sheet/myorder.dart';

class connectNetwork extends GetxController {
  final dataKios _dataKios = Get.put(dataKios());
  RxBool Internet = false.obs;
  RxString Network = ''.obs;
  final int connect;
  RxInt remainingSeconds = 0.obs;
  RxBool isConnected = false.obs;
  RxInt k = 0.obs;
  Timer timer;
  String HeadTextError = "ขออภัยในความไม่สะดวก";
  String TextError = "โปรดตรวจสอบสัญญาณอินเตอร์เน็ตของท่าน";
  final notConnect = NotAvailable;
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());

  connectNetwork(this.connect);
  @override
  void onInit() {
    super.onInit();
    remainingSeconds.value = connect;
  }

  void stopTimerAndReset() {
    timer?.cancel();
    remainingSeconds.value = connect;
  }

  Future<bool> checkInternetConnection() async {
    try {
      http.Client client = http.Client();
      final response = await http.get(Uri.parse('https://www.google.com'));
      if (response.statusCode == 200) {
        return true; // สามารถเชื่อมต่ออินเทอร์เน็ตได้

      } else {
        return false; // ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้
      }
    } catch (e) {
      return false; // ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้
    }
  }

  Future<reqKiosdata> reqKios() async {
    http.Client client = http.Client();
    final kiosksSn = _dataKios.serialNumbers.value;
    // '3MF2209002140212'; //_dataKios.serialNumbers.value; //'9FP46D1UQ8QATAJK';
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://hqhitop.thddns.net:60000/api/devices/kiosksConnection'));
    request.body = json.encode({"serialNumber": kiosksSn});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseBody);
      final kiosksId = jsonResponse['kiosks']['kiosksId'];
      final customerId = jsonResponse['kiosks']['customerId'];
      _dataKios.reqKiosdata.add(jsonResponse);

      return reqKiosdata(kiosksId: kiosksId, customerId: customerId);
    } else {
      print(response.reasonPhrase);
      throw Exception('เกิดข้อผิดพลาดในการร้องขอ Kios');
    }
  }

  void ConnectNewtwork(BuildContext context) async {
    try {
      print('เช็คเน็ต');
      isConnected.value = await checkInternetConnection();
      //  timer?.cancel();
      // await stopTimerAndReset();
      remainingSeconds.value = connect;
      if (isConnected.value) {
        if (Internet.value == true) {
          print('ต่อเน็ต if');
          reqKios();
          Network.value = 'Connected to the internet';
          Get.delete<FoodOptionController>();
          Get.delete<MyOrder>();
          Get.delete<UsbDeviceController>();
          Get.delete<FoodItem>();
          Get.delete<amount_food>();
          Get.delete<food_option>();
          Get.delete<fail_pay_screen>();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return WillPopScope(
                    onWillPop: () async {
                      return false;
                    },
                    child: LoadData());
              },
            ),
          );
          Internet.value = false;
        } else {
          Network.value = 'Connected to the internet';
          print('ต่อเน็ต else');
        }
      } else {
        print('ไม่ต่อเน็ต');
        final waiting_for_success waitss =
            Get.put(waiting_for_success(connect));
        waitss.stopTimerAndReset();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return WillPopScope(
                  onWillPop: () async {
                    // Return false to prevent the user from navigating back
                    return false;
                  },
                  child: NotAvailable(HeadTextError, TextError));
            },
          ),
        );
        Network.value = 'Unable to connect to the internet';
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  void writeLog(BuildContext context) async {
    await ConnectNewtwork(context);
    String internet =
        'Check Internet ${Network.value} : ${_foodOptionController.formattedDate}';
    LogFile(internet);
  }

  void startTimer(BuildContext context) {
    k++;
    print('ค่าา k : ${k.value}');
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
        print('เวลาเช็คเน็ต ${remainingSeconds.value}');
      } else if (remainingSeconds.value == 0) {
        print('เช็คเน็ต');
        ConnectNewtwork(context);
        writeLog(context);
        reset();
      }
    });
  }

  void reset() {
    remainingSeconds.value = connect;
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
