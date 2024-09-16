import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen/Appbar/report.dart';
import 'package:screen/screen/selection_screen.dart';
import '../Appbar/language.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/save_menu.dart';
import '../restaurant/image.dart';
import '../timeControl/adtime.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class logo_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataKios _dataKios = Get.put(dataKios());
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final int admob_time = 60;
    final FoodOptionController _foodOptionController =
        Get.put(FoodOptionController());
    //final List<ImageController> myimage = images;
    final admob_times = Get.put(AdMobTimeController(admob_time: admob_time));
    String Log =
        'Select a dining location : ${_foodOptionController.formattedDate}';

    return Scaffold(
        body: SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Container(
              height: sizeHeight * 0.045,
              width: sizeWidth * 1,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(sizeWidth * 0.01),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: languageBar()),
          Container(
            height: sizeHeight * 0.955,
            width: sizeWidth * 1,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  LogFile(Log);
                  admob_times.reset();
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
                child: Column(
                  children: [
                    SizedBox(
                      height: sizeHeight * 0.34,
                    ),
                    Container(
                      height: sizeHeight * 0.15,
                      width: sizeWidth * 0.6,
                     // color: Colors.red,
                        child: Image.asset(
                          'assets/logo.png',
                          height: sizeHeight * 0.5,
                          width: sizeWidth * 1,
                          fit: BoxFit.contain,
                        ),
                      
                    ),
                  /* Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                          Text("H",
                            style: TextStyle(
                            fontSize: sizeWidth * 0.16,
                            fontFamily: 'VarelaRound',
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(239, 17, 0, 1),
                          ),
                        ),
                        Positioned(
                          right: 8,  // จัดวางให้ชิดขวา
                          top: 10,    // จัดวางให้ชิดบน
                          child: CircleAvatar(
                          radius: sizeWidth * 0.015, // กำหนดรัศมีของจุด
                          backgroundColor: Color.fromRGBO(239, 17, 0, 1), // กำหนดสีพื้นหลังให้เป็นสีแดง
                          ),
                        ),
                       ],
                     ),
                     Text("Matic",
                            style: TextStyle(
                            fontSize: sizeWidth * 0.15,
                            fontFamily: 'Poppins-Black',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),*/
                   
                    SizedBox(
                      height: sizeHeight * 0.257,
                    ),
                    Container(
                      height: sizeHeight * 0.06,
                      width: sizeWidth * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(sizeWidth * 0.05),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        ///แตะเพื่อเริ่ม
                        child: Text(
                          AppLocalizations.of(context)!.touch,
                          style: TextStyle(
                          fontSize: sizeWidth * 0.042,
                          fontFamily: 'SukhumvitSet-Medium',
                           fontWeight: FontWeight.w700
                           ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sizeHeight * 0.125,
                    ),
                     Container(
                      height: sizeHeight * 0.023,
                      width: sizeWidth * 1,
                      color: Color.fromRGBO(239, 17, 0, 1),
                      child: Bottombar())
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
