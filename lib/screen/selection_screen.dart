import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen/api/Kios_API.dart';
import 'package:screen/restaurant/image.dart';
import 'package:screen/screen/menu_screen.dart';
import '../Appbar/language.dart';
import '../UI/Font/ColorSet.dart';
import '../getxController.dart/save_menu.dart';
import '../timeControl/adtime.dart';
import 'package:flutter/services.dart';

class selection_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final List<ImageController> myimage = images;
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final int admob_time = 60;
    final FoodOptionController _foodOptionController =
        Get.put(FoodOptionController());
    final admob_times = Get.put(AdMobTimeController(admob_time));

    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(children: [
          Container(
              height: sizeHeight * 0.045,
              width: sizeWidth * 1,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(sizeWidth * 0.01),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(1),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: languageBar()),
          GestureDetector(
            onTap: () {
              admob_times.reset(); // Reset the time countdown
            },
            child: Container(
                height: sizeHeight * 0.55,
                width: sizeWidth * 1,
                color: Color.fromRGBO(229, 229, 229, 1),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: sizeHeight * 0.4,
                        width: sizeWidth * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: Image.asset(
                            myimage[0].image,
                            height: sizeHeight * 1,
                            width: sizeWidth * 1,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0.0, -200.0),
                        child: Container(
                          height: sizeHeight * 0.075,
                          child: Text(
                            'NAME',
                            style: TextStyle(
                              fontSize: sizeWidth * 0.12,
                              fontFamily: 'SukhumvitSet-Medium',
                            ),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0.0, -190.0),
                        child: Text(
                          'R E S T A U R A N T',
                          style: TextStyle(
                            fontSize: sizeWidth * 0.038,
                            fontFamily: 'SukhumvitSet-Medium',
                          ),
                        ),
                      )
                    ])),
          ),
          GestureDetector(
            onTap: () {
              admob_times.reset(); // Reset the time countdown
            },
            child: Container(
              height: sizeHeight * 0.355,
              width: sizeWidth * 1,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  SizedBox(
                    height: sizeHeight * 0.02,
                  ),
                  Text('เลือกทานอาหารที่ร้าน หรือ สั่งกลับบ้าน?',
                      style: Fonts(context, 0.045, true, Colors.black)),
                  SizedBox(
                    height: sizeHeight * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 80,
                    ),
                    child: Row(children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              String DineIn =
                                  'Dine-in : ${_foodOptionController.formattedDate}';
                              _foodOptionController.FromHere();
                              LogFile(DineIn);
                              admob_times.reset();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => menu_screen()),
                              );
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 100),
                                  child: Container(
                                    height: sizeHeight * 0.23,
                                    width: sizeWidth * 0.31,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 226, 223, 223),
                                      borderRadius: BorderRadius.circular(
                                          sizeWidth *
                                              0.02), // ค่าเท่าครึ่งของความกว้าง
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 60,
                                          bottom: 100,
                                          left: 60,
                                          right: 60),
                                      child: Image.asset(
                                        'assets/restaurant.png',
                                      ),
                                    ),
                                  ),
                                ),
                                Transform.translate(
                                  offset: Offset(50.0,
                                      -90.0), // กำหนดตำแหน่งแนวนอนและแนวตั้งให้รูปภาพขยับไปทางขวา 50.0 และลงล่าง 100.0
                                  child: Text("ทานอาหารที่ร้าน",
                                      style: Fonts(
                                          context, 0.038, true, Colors.black)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              String Take_Away =
                                  'Take Away : ${_foodOptionController.formattedDate}';
                              LogFile(Take_Away);
                              _foodOptionController.TakeHome();
                              admob_times.reset();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => menu_screen()),
                              );
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 80, left: 40),
                                  child: Container(
                                    height: sizeHeight * 0.23,
                                    width: sizeWidth * 0.31,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 226, 223, 223),
                                      borderRadius: BorderRadius.circular(
                                          sizeWidth *
                                              0.02), // ค่าเท่าครึ่งของความกว้าง
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 60,
                                          bottom: 100,
                                          left: 60,
                                          right: 60),
                                      child: Image.asset(
                                        'assets/home.png',
                                      ),
                                    ),
                                  ),
                                ),
                                Transform.translate(
                                    offset: Offset(-15.0,
                                        -90.0), // กำหนดตำแหน่งแนวนอนและแนวตั้งให้รูปภาพขยับไปทางขวา 50.0 และลงล่าง 100.0
                                    child: Text("สั่งกลับบ้าน",
                                        style: Fonts(context, 0.038, true,
                                            Colors.black)))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              admob_times.reset(); // Reset the time countdown
            },
            child: Container(
              color: Color.fromRGBO(229, 229, 229, 1),
              height: sizeHeight * 0.065,
              width: sizeWidth * 1,
            ),
          )
        ]),
      ),
    );
  }
}
