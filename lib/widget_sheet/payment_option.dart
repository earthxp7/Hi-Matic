import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:screen/UI/Font/ColorSet.dart';
import 'package:screen/getxController.dart/amount_food.dart';
import 'package:screen/timeControl/waiting_for_payment.dart';
import 'package:screen/widget_sheet/payment_scan.dart';
import '../UI/Menu/total_in_widget.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/save_menu.dart';
import '../timeControl/adtime.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class BottomSheetContent extends StatelessWidget {
  final amount_food _amount_food = Get.put(amount_food());
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final int IndexOrder;

  BottomSheetContent({
    this.IndexOrder,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final int admob_time = 30;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time));
    final dataKios _dataKios = Get.put(dataKios());
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final int pay_time = 180;
    // String Paymentid = _dataKios.paymentdata[0].paymentId;
    // print('Paymentid  ${Paymentid}');
    final pay_time_controller = Get.put(waiting_for_payment(pay_time));
    final List<String> imageAssets = [
      'assets/พร้อมเพลย์.png',
      'assets/turemoney.png',
      'assets/shopee.png',
      'assets/LinePay.png',
      'assets/wechat.png',
      'assets/airpay.png',
    ];
    final List<String> namepayment = [
      'promptpay',
      'truemoney',
      'shopeepay',
      'LinePay',
      'Wechat',
      'alipay',
    ];

    Future<void> postPayMent() async {
      String Paymentid = _dataKios.paymentdata[0].paymentId;
      final currentDate = DateTime.now();
      final formattedDate = DateFormat('yyyyMMddHHmmss').format(currentDate);
      final url =
          'http://hqhitop.thddns.net:60000/api/devices/createPayment?paymentId=$Paymentid';
      final uri = Uri.parse(url);
      final List<Map<String, dynamic>> dataToSend = [];
      final Cannel = _foodOptionController.paymentsName.value;
      final TotalFee = 1;
      final MchOrderNo = formattedDate;
      var headers = {'Content-Type': 'application/json'};
      try {
        var request = http.Request(
            'POST',
            Uri.parse(
                'http://hqhitop.thddns.net:60000/api/devices/createPayment?paymentId=$Paymentid'));
        request.body = json.encode({
          "channel": Cannel,
          "totalFee": TotalFee,
          "mchOrderNo": MchOrderNo,
          "deviceId": _dataKios.serialNumbers.value
        });
        request.headers.addAll(headers);
        http.Client client = http.Client();
        http.StreamedResponse response = await client.send(request);
        print('postPayMentstatus : ${response.statusCode}');
        if (response.statusCode == 200) {
          String responseBody = await response.stream.bytesToString();
          Map<String, dynamic> jsonResponse = json.decode(responseBody);
          final qrImg = jsonResponse['qrImg'];
          final mchOrderNo = jsonResponse['mchOrderNo'];
          final appId = jsonResponse['appId'];
          final status = jsonResponse['status'];
          _dataKios.Qrpayment.add(jsonResponse);
          _dataKios.MchOrderNo.value = MchOrderNo;
          return Qrpaymentdata(
              qrImg: qrImg,
              mchOrderNo: mchOrderNo,
              appId: appId,
              status: status);
        } else {
          print(response.reasonPhrase);
        }
      } catch (error) {
        print('Error: $error');
      }
    }

    Future<void> postStatusPayment() async {
      String Paymentid = _dataKios.paymentdata[0].paymentId;
      print('postStatusPaymentstatus ${Paymentid} ');
      var url =
          'http://hqhitop.thddns.net:60000/api/devices/checkStatusPayment?paymentId=$Paymentid';
      final uri = Uri.parse(url);
      final List<Map<String, dynamic>> dataToSend = [];
      final MchOrderNo = _dataKios.MchOrderNo.value.toString();
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
        print('postStatusPaymentstatus : ${response.statusCode}');
        if (response.statusCode == 200) {
          String responseBody = await response.stream.bytesToString();
          Map<String, dynamic> jsonResponse = json.decode(responseBody);
          print('Response from API: $jsonResponse');
        } else {
          print('reasonPhrase ${response.reasonPhrase}');
        }
      } catch (error) {
        print('Error: $error');
      }
    }

    return GestureDetector(
        onTap: () {
          adtimeController.reset(); // Reset the time countdown
        },
        child: SingleChildScrollView(
          child: Container(
            height: sizeHeight * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              children: [
                Container(
                  height: sizeHeight * 0.15,
                  width: sizeWidth * 1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 160, left: 70),
                        child: GestureDetector(
                          onTap: () {
                            adtimeController.reset();
                            Get.back();
                            String back =
                                'Return to the menu page : ${_foodOptionController.paymentsName.value} ${_foodOptionController.formattedDate}';
                            LogFile(back);
                          },
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
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 100, left: 10),
                        child: Column(
                          children: [
                            Text('เลือกช่องทางชำระเงิน',
                                style:
                                    Fonts(context, 0.045, true, Colors.black)),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text('Select Payment',
                                  style: Fonts(
                                      context, 0.035, false, Colors.black)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: sizeHeight * 0.47,
                  width: sizeWidth * 0.85,
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 40,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: List.generate(
                        /*   imageAssets
                            .length */
                        _dataKios.paymentdata[0].channelLength, (index) {
                      int IndexOrder = index;
                      final cenel =
                          _dataKios.paymentdata[0].optionData[IndexOrder];
                      final cenalname = cenel['name'];
                      final cenalrate = cenel['rate'];
                      _foodOptionController.paymentsName.value = cenalname;

                      String Payment =
                          'Payment by : ${_foodOptionController.paymentsName.value} ${_foodOptionController.formattedDate}';
                      return GestureDetector(
                        onTap: () async {
                          if (_foodOptionController.total_price.value > 0 &&
                              _foodOptionController.payment_times.value == 0) {
                            _foodOptionController.payment_times.value = 5;
                            LogFile(Payment);
                            await postPayMent();
                            _foodOptionController.startTimer(context);
                            pay_time_controller.startTimer(context);

                            print(
                                'กดได้ใน ${_foodOptionController.payment_times.value}');
                            adtimeController.stopTimerAndReset();
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                useRootNavigator: true,
                                isDismissible: false,
                                enableDrag: false,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (context) {
                                  return WillPopScope(
                                    onWillPop: () async {
                                      return false;
                                    },
                                    child: pay_scan_bottomsheet(
                                        IndexOrder: IndexOrder),
                                  );
                                });
                          } else {
                            String fail =
                                'Payment failed (no food items found) : ${_foodOptionController.paymentsName.value} ${_foodOptionController.formattedDate}';
                            LogFile(fail);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: Text('ไม่พบรายการอาหาร',
                                      style: Fonts(
                                          context, 0.042, true, Colors.red)),
                                  content: Text(
                                      'โปรดเลือกอาหารของคุณก่อนชำระเงิน',
                                      style: Fonts(
                                          context, 0.028, false, Colors.black)),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blue,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 24),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text('ตกลง',
                                          style: Fonts(context, 0.034, true,
                                              Colors.white)),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: (cenalrate > 0.0)
                                ? Image.asset(
                                    imageAssets[index],
                                    fit: BoxFit.contain,
                                    height: sizeHeight * 0.11,
                                    width: sizeWidth * 0.41,
                                  )
                                : Container()),
                      );
                    }),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  child: Container(
                    height: sizeHeight * 0.08,
                    width: sizeWidth * 1,
                    color: Color.fromARGB(255, 225, 224, 223),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [TotalWiget()],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
