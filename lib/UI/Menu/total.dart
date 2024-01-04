import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../api/Kios_API.dart';
import '../../getxController.dart/amount_food.dart';
import '../../getxController.dart/save_menu.dart';
import '../../screen/selection_screen.dart';
import '../../timeControl/adtime.dart';
import '../../widget_sheet/myorder.dart';
import '../../widget_sheet/payment_option.dart';

class totalUI extends StatelessWidget {
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final dataKios _dataKios = Get.put(dataKios());
  final int IndexOrder;
  totalUI({this.IndexOrder});
  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final int admob_time = 60;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time));
    final DateLog = _foodOptionController.formattedDate;
    String Back = 'Back Select a dining location page : ${DateLog}';
    return Container(
      height: sizeHeight * 0.08,
      width: sizeWidth * 1,
      decoration: BoxDecoration(
        color: Color.fromRGBO(206, 206, 206, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: sizeHeight * 0.08,
            width: sizeWidth * 0.7,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 200, 194, 194),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    LogFile(Back);
                    _foodOptionController.tapCount.value = 0;
                    adtimeController.reset();
                    Get.delete<amount_food>();
                    Get.delete<FoodOptionController>();
                    Get.delete<FoodItem>();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return WillPopScope(
                            onWillPop: () async {
                              return false;
                            },
                            child: selection_screen(),
                          );
                        },
                      ),
                    );
                  },
                  child: Transform.translate(
                    offset: Offset(30.0, -20.0),
                    child: Transform.scale(
                      scale: 1.3, // ปรับขนาดตามความต้องการ
                      child: Image.asset(
                        'assets/Homes.png',
                        height: sizeHeight * 1, // ความสูงของรูปภาพ
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Transform.translate(
                        offset: Offset(0.0, 20.0),
                        child: Obx(() => Container(
                              height: sizeHeight * 0.022,
                              width: sizeWidth * 0.05,
                              decoration: BoxDecoration(
                                color:
                                    (_foodOptionController.numorder.value > 0)
                                        ? Colors.green
                                        : Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                  child: Obx(
                                () => Padding(
                                  padding: const EdgeInsets.only(
                                    right: 10,
                                  ),
                                  child: Text(
                                    ' ${_foodOptionController.numorder.value}',
                                    style: GoogleFonts.kanit(
                                        fontSize: sizeHeight * 0.015,
                                        color: (_foodOptionController
                                                    .numorder.value >
                                                0)
                                            ? Colors.black
                                            : Colors.white),
                                  ),
                                ),
                              )),
                            ))),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: GestureDetector(
                        onTap: () {
                          String moyorder =
                              'Open my food page : ${_foodOptionController.formattedDate}';
                          LogFile(moyorder);
                          _foodOptionController.tapCount.value = 0;
                          adtimeController.reset();
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              isDismissible: false,
                              enableDrag: false,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              builder: (context) {
                                return NotificationListener<
                                    OverscrollIndicatorNotification>(
                                  onNotification:
                                      (OverscrollIndicatorNotification
                                          notification) {
                                    notification.disallowIndicator();
                                    return false;
                                  },
                                  child: MyOrder(
                                      IndexOrder:
                                          _foodOptionController.namecat.value),
                                );
                              });
                        },
                        child: Transform.translate(
                          offset: Offset(-50.0, -5.0),
                          child: Image.asset(
                            'assets/basket.png',
                            height: sizeHeight * 0.04,
                            width: sizeWidth * 0.22,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, right: 20),
                      child: Obx(
                        () => Text(
                          '${_foodOptionController.total_price.value} ฿',
                          style: TextStyle(
                            fontSize: sizeWidth * 0.05,
                            fontFamily: 'SukhumvitSet-Medium',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              String payment =
                  'Open the payment options page : ${_foodOptionController.formattedDate}';
              LogFile(payment);
              _foodOptionController.tapCount.value = 0;
              adtimeController.reset();
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useRootNavigator: true,
                  isDismissible: false,
                  enableDrag: false,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    return WillPopScope(
                      onWillPop: () async {
                        return false;
                      },
                      child: BottomSheetContent(IndexOrder: IndexOrder),
                    );
                  });
            },
            child: Obx(() => Container(
                  height: sizeHeight * 0.08,
                  width: sizeWidth * 0.3,
                  decoration: BoxDecoration(
                    color: (_foodOptionController.numorder.value > 0)
                        ? Colors.green
                        : Color.fromRGBO(136, 136, 136, 1),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Payment',
                        style: TextStyle(
                          fontSize: sizeWidth * 0.047,
                          fontFamily: 'SukhumvitSet-Medium',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
