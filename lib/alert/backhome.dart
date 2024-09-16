import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:screen/getxController.dart/selection.dart';
import '../UI/Font/ColorSet.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/amount_food.dart';
import '../getxController.dart/save_menu.dart';
import '../screen/selection_screen.dart';
import '../timeControl/adtime.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void backHome(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController passwordController = TextEditingController();
        final int admob_time = 60;
         final dataKios _dataKios = Get.put(dataKios());
        final admob_times =
            Get.put(AdMobTimeController(admob_time: admob_time));
        final sizeHeight = MediaQuery.of(context).size.height;
        final sizeWidth = MediaQuery.of(context).size.width;
        final FoodOptionController _foodOptionController =
            Get.put(FoodOptionController());
        final DateLog = _foodOptionController.formattedDate;
        String Back = 'Back Select a dining location page : ${DateLog}';
        final AdMobTimeController adtimeController =
            Get.put(AdMobTimeController(admob_time: admob_time));
        return WillPopScope(
            onWillPop: () async {
              return true; // ป้องกันผู้ใช้ปิด AlertDialog โดยการคลิกที่พื้นที่ว่าง
            },
            child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Row(children: [
                  SizedBox(
                    width: sizeWidth * 0.04,
                  ),
                  Container(
                    width: sizeWidth * 0.55,
                    height: sizeHeight * 0.08,
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.head_return_home_page,
                            style: Fonts(context, 0.045, true, Colors.red)),
                        SizedBox(
                          height: sizeHeight * 0.01,
                        ),
                        Text(AppLocalizations.of(context)!.detail_return_home_page,
                            style: Fonts(context, 0.03, false, Colors.black))
                      ],
                    ),
                  )
                ]),
                content: SingleChildScrollView(
                    child: Row(children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.cancel,
                        style: Fonts(context, 0.035, true, Colors.white)),
                  ),
                  SizedBox(
                    width: sizeWidth * 0.35,
                  ),
                  TextButton(
                    onPressed: () {
                      LogFile(Back);
                      _foodOptionController.tapCount.value = 0;
                      adtimeController.reset();                     
                      Get.delete<amount_food>();
                      Get.delete<FoodOptionController>();
                      Get.delete<FoodItem>();    
                      Get.delete<SelectionController>();   
                      Navigator.pushReplacement(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.agree,
                        style: Fonts(context, 0.035, true, Colors.white)),
                  ),
                ]))));
      });
}
