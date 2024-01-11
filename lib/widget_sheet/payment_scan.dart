import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:screen/UI/Font/ColorSet.dart';
import 'package:screen/api/Kios_API.dart';
import 'package:screen/getxController.dart/amount_food.dart';
import 'package:screen/timeControl/waiting_for_payment.dart';
import 'package:screen/widget_sheet/payment_option.dart';
import 'package:screen/widget_sheet/successful_payment.dart';
import 'package:http/http.dart' as http;
import '../UI/Menu/total_in_widget.dart';
import '../getxController.dart/save_menu.dart';
import '../printer/printer_LAN.dart';
import '../printer/printer_USB.dart';
import '../timeControl/adtime.dart';
import '../timeControl/waiting _for_success.dart';
import 'package:flutter/services.dart';

class pay_scan_bottomsheet extends StatelessWidget {
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final UsbDeviceController usbDeviceController =
      Get.put(UsbDeviceController());
  final dataKios _dataKios = Get.put(dataKios());
  final int IndexOrder;

  pay_scan_bottomsheet({
    this.IndexOrder,
  });
  final amount_food _amount_food = Get.put(amount_food());
  final BottomSheetContent _bottomSheetContent = Get.put(BottomSheetContent());
  String formatTime(int seconds) {
    int minutes = (seconds ~/ 60);
    int remainingSeconds = (seconds % 60);
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void postMenu() async {
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(currentDate);
    print('formattedDate : ${formattedDate}');
    const url =
        'http://hqhitop.thddns.net:60000/api/devices/receiveTransactionValue';
    final uri = Uri.parse(url);
    final List<Map<String, dynamic>> dataToSend = [];
    for (int index = 0; index < _foodOptionController.orders.length; index++) {
      final currentIndex = _foodOptionController.orders[index];
      final categoryValue = _foodOptionController.categoryValues[index];
      final advert = _dataKios.advertlist[currentIndex];
      final countsList = (categoryValue == 'Steak')
          ? _foodOptionController.countListCat1
          : (categoryValue == 'Drinks')
              ? _foodOptionController.countListCat2
              : (categoryValue == 'Foods')
                  ? _foodOptionController.countListCat3
                  : (categoryValue == 'Noodles')
                      ? _foodOptionController.countListCat4
                      : _foodOptionController.countList;
      final meal = (categoryValue == 'Steak')
          ? _dataKios.steakList[currentIndex]
          : (categoryValue == 'Drinks')
              ? _dataKios.drinkList[currentIndex]
              : (categoryValue == 'Foods')
                  ? _dataKios.foodList[currentIndex]
                  : (categoryValue == 'Noodles')
                      ? _dataKios.noodleList[currentIndex]
                      : _dataKios.coffeeList[currentIndex];
      final paymentsAmount = countsList[currentIndex];
      final kiosksId = _dataKios.reqKiosdata[0]['kiosks']['kiosksId'];
      final mealId = meal.mealId.toString();
      final mealNameEN = meal.mealNameEN.toString();
      final mealNameTH = meal.mealNameTH.toString();
      final mealPrice = _foodOptionController
          .calculateTotal(currentIndex, categoryValue)
          .toDouble();
      final paymentsName = _foodOptionController.paymentsName.value;
      final kiosksSn = _dataKios.serialNumbers.value;

      // เพิ่มข้อมูลแต่ละรายการลงใน List
      final currentDate = DateTime.now();
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse(
              'http://hqhitop.thddns.net:60000/api/devices/receiveTransactionValue'));
      request.body = json.encode({
        "transactionTime": formattedDate,
        "mealsId": mealId,
        "mealsPrice": mealPrice,
        "mealsName": mealNameTH,
        "paymentsName": paymentsName,
        "paymentsAmount": paymentsAmount,
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

  final List<String> imageAssets = [
    'assets/พร้อมเพลย์.png',
    'assets/turemoney.png',
    'assets/shopee.png',
    'assets/LinePay.png',
    'assets/wechat.png',
    'assets/airpay.png',
  ];
  Image image;
  Future<void> CovertQR() async {
    String qrImgBase64 = _dataKios.Qrpayment[0]['qrImg'];
    String base64String = qrImgBase64.split(',').last;
    Uint8List bytes = Uint8List.fromList(base64.decode(base64String));
    image = Image.memory(bytes);
  }

  Future<void> postStatusPayment() async {
    String Paymentid = _dataKios.paymentdata[0].paymentId;
    print('postStatusPaymentstatus ${Paymentid} ');
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
        print('จ่ายเงิน : ${_dataKios.status.value}');
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
    print('Kios : ${kiosksId}');
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
    final int pay_times = 180;
    final int admob_times = 60;
    final int successful_times = 10;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_times));
    final successful_time_controller =
        Get.put(waiting_for_success(successful_times));
    final pay_time_controller = Get.put(waiting_for_payment(pay_times));
    if (_dataKios.status.value == 'SUCCESS') {
      await checkQueue();
      adtimeController.stopTimerAndReset();
      pay_time_controller.stopTimerAndReset();
      successful_time_controller.startTimer(context);
      if (usbDeviceController.connected.value) {
        await usbDeviceController.prints();
        await printToNetworkPrinter();
        _dataKios.Qrpayment = [];

        //   postMenu();
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useRootNavigator: true,
            isDismissible: false,
            enableDrag: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return WillPopScope(
                onWillPop: () async {
                  // Return false to prevent the bottom sheet from being closed
                  return true;
                },
                child: successful_payment(),
              );
            });
        _dataKios.status.value = '';
        String conNect =
            'Printer connected : ${_foodOptionController.formattedDate}';
        LogFile(conNect);
      } else {
        String Notcon =
            'Printer is not connected : ${_foodOptionController.formattedDate}';
        LogFile(Notcon);
      }
    }
  }

  void CheckStatus(BuildContext context) {
    Timer timer;

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      checkStatus(context);

      if (_dataKios.status.value == 'SUCCESS') {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    CheckStatus(context);
    PostStatusPayment();
    CovertQR();
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(currentDate);
    final int pay_time = 180;
    final int successful_time = 10;
    final pay_time_controller = Get.put(waiting_for_payment(pay_time));
    final successful_time_controller =
        Get.put(waiting_for_success(successful_time));
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final int admob_time = 60;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time));

    return GestureDetector(
        onTap: () {
          adtimeController.reset();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: sizeHeight * 0.7,
                width: sizeWidth * 1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  children: [
                    Row(children: [
                      Container(
                        height: sizeHeight * 0.277,
                        width: sizeWidth * 1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 70, bottom: 100, right: 100),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                16), // Adjust the radius as needed
                                          ),
                                          title: Text('ยกเลิกการชำระเงิน',
                                              style: Fonts(context, 0.045, true,
                                                  Colors.red)),
                                          content: Text(
                                              'คุณต้องการยกเลิกการชำระเงินหรือไม่',
                                              style: Fonts(context, 0.028,
                                                  false, Colors.black)),
                                          actions: [
                                            Row(
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.red,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 12,
                                                            horizontal: 24),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  child: Text('ยกเลิก',
                                                      style: Fonts(
                                                          context,
                                                          0.034,
                                                          false,
                                                          Colors.white)),
                                                ),
                                                SizedBox(
                                                  width: sizeWidth * 0.25,
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    final controller = Get.find<
                                                        waiting_for_payment>();
                                                    controller
                                                        .stopTimerAndReset();
                                                    adtimeController.reset();
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();

                                                    String back =
                                                        'Return to the payment channels page : ${_foodOptionController.paymentsName.value} ${_foodOptionController.formattedDate}';
                                                    LogFile(back);
                                                    _dataKios.Qrpayment = [];
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.blue,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 12,
                                                            horizontal: 24),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  child: Text('ตกลง',
                                                      style: Fonts(
                                                          context,
                                                          0.034,
                                                          false,
                                                          Colors.white)),
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      },
                                    );
                                    adtimeController.reset();
                                  },
                                  /*  child: Transform.translate(
                                      offset: Offset(0.0, -70.0),*/
                                  child: Container(
                                      height: sizeHeight * 0.05,
                                      width: sizeWidth * 0.08,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.arrow_back,
                                          size: sizeHeight * 0.032,
                                          color: Colors.black,
                                        ),
                                      )),
                                )),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 100, right: 20),
                                  child: Text('กรุณาชำระเงิน',
                                      style: Fonts(
                                          context, 0.045, true, Colors.black)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20, right: 20),
                                  child: Text('Please scan QR code',
                                      style: Fonts(
                                          context, 0.035, false, Colors.black)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 30),
                                        child: Text('กรุณาชำระเงินภายใน',
                                            style: Fonts(context, 0.035, false,
                                                Colors.black)),
                                      ),
                                      Container(
                                        height: sizeHeight * 0.04,
                                        width: sizeWidth * 0.2,
                                        color:
                                            Color.fromARGB(255, 239, 238, 235),
                                        child: Center(
                                          child: Obx(() {
                                            final controller =
                                                Get.find<waiting_for_payment>();
                                            return Text(
                                              formatTime(controller
                                                  .remainingSeconds.value),
                                              style: GoogleFonts.kanit(
                                                fontSize: sizeWidth * 0.032,
                                              ),
                                            );
                                          }),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
                    Column(
                      children: [
                        Container(
                          height: sizeHeight * 0.1,
                          width: sizeWidth * 1,
                          color: Colors.white,
                          child: FractionalTranslation(
                            translation: Offset(0.0, -0.8),
                            child: Image.asset(
                              imageAssets[IndexOrder],
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                              width:
                                  sizeWidth * 0.3, // ปรับขนาดความกว้างของรูปภาพ
                              height:
                                  sizeHeight * 0.5, // ปรับขนาดความสูงของรูปภาพ
                            ),
                          ),
                        ),
                        Container(
                          height: sizeHeight * 0.2,
                          width: sizeWidth * 0.5,
                          color: Colors.white,
                          child: /*Image.asset(
                                'assets/QR_code.png')*/
                              FractionalTranslation(
                            translation: Offset(0.0, -0.3),
                            child: FutureBuilder<void>(
                              future: CovertQR(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  // Now you can use the 'image' variable in your UI
                                  return image;
                                } else {
                                  // While the image is loading, you can show a placeholder or loading indicator
                                  return CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 82),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                        child: Container(
                          height: sizeHeight * 0.08,
                          width: sizeWidth * 1,
                          color: Color.fromARGB(255, 225, 224, 223),
                          child: GestureDetector(
                            onTap: () {},
                            child: Center(child: TotalWiget()),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
