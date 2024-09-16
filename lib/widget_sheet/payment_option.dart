import 'dart:convert';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:screen/UI/Font/ColorSet.dart';
import 'package:screen/api/payment.dart';
import 'package:screen/getxController.dart/payment.dart';
import 'package:screen/getxController.dart/printer_setting.dart';
import 'package:screen/getxController.dart/selection.dart';
import 'package:screen/printer/printer_USB.dart';
import 'package:screen/timeControl/waiting_for_payment.dart';
import 'package:screen/widget_sheet/fail_payment.dart';
import 'package:screen/widget_sheet/payment_scan.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/save_menu.dart';
import '../timeControl/adtime.dart';

class BottomSheetContent extends StatelessWidget {
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final Payment_controller payment_controller = Get.put(Payment_controller());
  final UsbDeviceControllers usbDeviceController =
      Get.put(UsbDeviceControllers());
  final dataKios _dataKios = Get.put(dataKios());
  final pinter_test printer_Test = Get.put(pinter_test());
  final SelectionController selectionController =
      Get.put(SelectionController());
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? usbInfo = printer_Test.selectedDropdownValues['USB'];
    final int admob_time = 30;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time: admob_time));
    final dataKios _dataKios = Get.put(dataKios());
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final int pay_time = 180;
    final pay_time_controller =
        Get.put(waiting_for_payment(pay_time: pay_time));
    List<Map<String, dynamic>> payment = Payments.PayMentItem(context);
    Future<Qrpaymentdata> postPayMent() async {
      String Paymentid = _dataKios.paymentdata[0].paymentId;
      final currentDate = DateTime.now();
      final formattedDate = DateFormat('yyyyMMddHHmmss').format(currentDate);
      final url =
          'http://hqhitop.thddns.net:60000/api/devices/createPayment?paymentId=$Paymentid';
      final uri = Uri.parse(url);
      final List<Map<String, dynamic>> dataToSend = [];
      final Cannel = selectionController.paymentsName.value;
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
          return Qrpaymentdata(
              qrImg: '', mchOrderNo: '', appId: '', status: '');
        }
      } catch (error) {
        print('Error: $error');
        return Qrpaymentdata(qrImg: '', mchOrderNo: '', appId: '', status: '');
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
            height: sizeHeight * 0.87,         
            child: Column(
              children: [
                Container(
                  height: sizeHeight * 0.15,
                  width: sizeWidth * 1,
                  decoration: BoxDecoration(
                    //color: Colors.yellow,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(sizeWidth*0.05),
                      topRight: Radius.circular(sizeWidth*0.05),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: sizeWidth*0.07,
                      ),
                      Container(
                            height: sizeHeight * 0.08,
                            width: sizeWidth * 0.08,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                size: sizeHeight * 0.04,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                adtimeController.reset();
                                Get.back();
                                String back =
                                    'Return to the menu page : ${selectionController.paymentsName.value} ${_foodOptionController.formattedDate}';
                                LogFile(back);
                              },
                            )),
                      SizedBox(
                        width: sizeWidth * 0.16,
                      ),
                      Container(
                        height: sizeHeight * 0.09,
                        width: sizeWidth * 0.4,
                        child: Column(
                        children: [
                            Text('เลือกวิธีชำระเงิน',
                                  style:
                                      Fonts(context, 0.05, true, Colors.black)),
                            SizedBox(
                              height: sizeHeight * 0.01,
                            ),
                            Text('Select Payment',
                                  style: Fonts(
                                      context, 0.038, true, Colors.black)),
                          ]
                        ),
                      
                   ) ],
                  ),
                ),
                SizedBox(height: sizeHeight * 0.02,),
                Container(
                  height: sizeHeight * 0.47,
                  width: sizeWidth * 0.85,
                 // color: Colors.red,
                  child: Wrap(
                    spacing: sizeWidth * 0.03,
                    runSpacing: sizeHeight *0.02,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: List.generate(
                        6, (index) {
                      final cenel = _dataKios.paymentdata[0].optionData[index];
                      final cenalname = cenel['name'];
                      final cenalrate = cenel['rate'];
                      String Payment =
                          'Payment by : ${selectionController.paymentsName.value} ${_foodOptionController.formattedDate}';
                      return GestureDetector(
                        onTap: () async {             
                          print("Count : ${selectionController.countAll.value} Time : ${_foodOptionController.payment_times.value}");
                         selectionController.paymentsName.value = cenalname;  
                             
                          if (selectionController.countAll.value > 0 &&
                              _foodOptionController.payment_times.value == 0 ) {
                           if(cenalrate > 0.0){
                            _foodOptionController.payment_times.value = 5;
                           
                            LogFile(Payment);
                            await postPayMent();
                            payment_controller.CheckStatus(context);
                            payment_controller.PostStatusPayment();
                            payment_controller.CovertQR();
                            _foodOptionController.startTimer(context);
                            pay_time_controller.startTimer(context);
                          
                            // adtimeController.stopTimerAndReset();
                            showFlexibleBottomSheet(
                                initHeight: 0.861,
                                isDismissible: false,
                                context: context,
                                bottomSheetBorderRadius: BorderRadius.only(
                                topLeft: Radius.circular(sizeWidth*0.05),
                                topRight: Radius.circular(sizeWidth*0.05),
                                ),
                                builder: (context, controller, offset) {
                                  return NotificationListener<
                                      OverscrollIndicatorNotification>(
                                    onNotification:
                                        (OverscrollIndicatorNotification
                                            notification) {
                                      notification.disallowIndicator();
                                      return false;
                                    },
                                    child: pay_scan_bottomsheet(
                                      IndexOrder: index,
                                    ),
                                  );
                                });
                        }else{
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: Text(AppLocalizations.of(context)!.no_payment_method,
                                      style: Fonts(
                                          context, 0.042, true, Colors.red)),
                                  content: Text( AppLocalizations.of(context)!.detail_no_payment_method,
                                      style: Fonts(
                                          context, 0.028, false, Colors.black)),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 24),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(AppLocalizations.of(context)!.agree,
                                          style: Fonts(context, 0.034, true,
                                              Colors.white)),
                                    ),
                                  ],
                                );
                              },
                            );
                        } 
                         } else {
                            String fail =
                                'Payment failed (no food items found) : ${selectionController.paymentsName.value} ${_foodOptionController.formattedDate}';
                            LogFile(fail);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: Text(AppLocalizations.of(context)!.head_no_food,
                                      style: Fonts(
                                          context, 0.042, true, Colors.red)),
                                  content: Text(
                                    AppLocalizations.of(context)!.detail_no_food,
                                      style: Fonts(
                                          context, 0.028, false, Colors.black)),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 24),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(AppLocalizations.of(context)!.agree,
                                          style: Fonts(context, 0.034, true,
                                              Colors.white)),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },child: Container(
                                  height: sizeHeight * 0.1,
                                  width: sizeWidth * 0.26,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(sizeWidth *0.017),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 6,
                                        offset: Offset(4, 4),
                                      ),
                                    ],
                                  ),
                            child: (cenalrate > 0.0)
                                ? Column(
                                          children: [
                                            Container(
                                              height: sizeHeight * 0.065,
                                              width: sizeWidth *1,
                                              //color: Colors.amber,
                                              child: Image.asset(
                                                payment[index]['image'],
                                                 fit: BoxFit.contain,
                                              ),
                                            ),
                                            Text(
                                              payment[index]['name'],
                                              style: Fonts(
                                                context, 0.028, false,
                                                Colors.black)
                                              ),
                                            
                                          ],
                                        )
                                : Container()
                      ));
                    }),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.1,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(sizeWidth *0.03),
                  ),
                  child: Container(
                    height: sizeHeight * 0.069,
                    width: sizeWidth * 0.9,
                    decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 0, 23, 1),
                    borderRadius: BorderRadius.all(
                    Radius.circular(sizeWidth*0.04),
                      ),
                    boxShadow: [
                    BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2, 
                    blurRadius: 8, 
                    offset: Offset(0, 4), 
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: sizeHeight *0.069,
                          width: sizeWidth * 0.55,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(AppLocalizations.of(context)!.total_payment,
                            style: Fonts(context, 0.045, true, Colors.white
                                    )),
                          ),
                            ),
                        SizedBox(
                          height: sizeHeight * 0.5,
                        ),
                        Obx(() => Container(
                          width: sizeWidth * 0.3,
                          height: sizeHeight * 0.069,
                          //color: Colors.green,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text('${selectionController.totalPrice.value} ฿',
                                style: Fonts(context, 0.045, true, Colors.white)
                                ,),
                          ),
                        ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
