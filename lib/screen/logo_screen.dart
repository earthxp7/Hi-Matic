import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:screen/screen/selection_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Appbar/language.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/save_menu.dart';
import '../restaurant/image.dart';
import '../timeControl/adtime.dart';
import 'package:flutter/services.dart';

class logo_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    final dataKios _dataKios = Get.put(dataKios());
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final int admob_time = 60;
    final FoodOptionController _foodOptionController =
        Get.put(FoodOptionController());
    final List<ImageController> myimage = images;
    final admob_times = Get.put(AdMobTimeController(admob_time));
    String Log =
        'Select a dining location : ${_foodOptionController.formattedDate}';

    return Scaffold(
      body: Column(
        children: [
          Container(
              height: sizeHeight * 0.045,
              width: sizeWidth * 1,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(sizeWidth * 0.01),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(2, 2),
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
                      height: sizeHeight * 0.13,
                    ),
                    Container(
                      height: sizeHeight * 0.4,
                      width: sizeWidth * 0.5,
                      child: Transform.translate(
                        offset: Offset(0.0, 70.0),
                        child: Image.asset(
                          myimage[0].image,
                          height: sizeHeight * 0.35,
                          width: sizeWidth * 1,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Container(
                      height: sizeHeight * 0.08,
                      child: Text(
                        'NAME',
                        style: TextStyle(
                          fontSize: sizeWidth * 0.12,
                          fontFamily: 'SukhumvitSet-Medium',
                        ),
                      ),
                    ),
                    Text(
                      'R E S T A U R A N T',
                      style: TextStyle(
                        fontSize: sizeWidth * 0.055,
                        fontFamily: 'SukhumvitSet-Medium',
                      ),
                    ),
                    SizedBox(
                      height: sizeHeight * 0.12,
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
                          'แตะเพื่อเริ่มต้น',
                          style: TextStyle(
                            fontSize: sizeWidth * 0.047,
                            fontFamily: 'SukhumvitSet-Medium',
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0.0, -35.0),
                      child: Image.asset(
                        'assets/Tap.png',
                        height: sizeHeight * 0.05,
                        width: sizeWidth * 0.5,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
