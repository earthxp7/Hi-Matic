import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen/Appbar/report.dart';
import 'package:screen/api/Kios_API.dart';
import 'package:screen/restaurant/image.dart';
import 'package:screen/screen/menu_screen.dart';
import '../Appbar/language.dart';
import '../UI/Font/ColorSet.dart';
import '../getxController.dart/save_menu.dart';
import '../timeControl/adtime.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class selection_screen extends StatelessWidget {
  final dataKios _dataKios = Get.put(dataKios());
  final List<ImageController> myimage = images;
  
  @override
  Widget build(BuildContext context) {
   // final List<ImageController> myimage = images;
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final int admob_time = 60;
    final categories = _dataKios.categoryList; 
    final categorie = categories[0]; 
    final FoodOptionController _foodOptionController =
        Get.put(FoodOptionController());
    final admob_times = Get.put(AdMobTimeController(admob_time: admob_time));
    _dataKios.status.value = '';
    
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(children: [
          Container(
              height: sizeHeight * 0.042,
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
          GestureDetector(
            onTap: () {             
              admob_times.reset();
            },
            child: Container(
                      height: sizeHeight * 0.55,
                      width: sizeWidth * 1,
                      decoration: BoxDecoration(
                       gradient: LinearGradient(
                       begin: Alignment.topCenter,  // จุดเริ่มต้นของการไล่ระดับสี (ด้านบน)
                      end: Alignment.bottomCenter, // จุดสิ้นสุดของการไล่ระดับสี (ด้านล่าง)
                      colors: [
                    Color.fromRGBO(229, 229, 229, 1),  // สีเข้มสุดด้านบน
                    Color.fromRGBO(229, 229, 229, 0.4),  // สีจางสุดด้านล่าง (โปร่งใส)
                      ],
                      )
                  ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Container(
                        height: sizeHeight * 0.15,
                      width: sizeWidth * 0.6,
                          child: Image.asset(
                          'assets/logo.png',
                          height: sizeHeight * 0.5,
                          width: sizeWidth * 1,
                          fit: BoxFit.contain,
                        ),
                        
                      ),
                     /*  Row(
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
                          right: 8,  
                          top: 10,   
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
                    ),
                     Text(
                          'R E S T A U R A N T',
                          style: TextStyle(
                            fontSize: sizeWidth * 0.047,
                            fontFamily: 'SukhumvitSet-Medium',
                          ),
                        ),*/
                    
                    ])),
          ),
          GestureDetector(
            onTap: () {
              admob_times.reset(); // Reset the time countdown
            },
            child: Container(
              height: sizeHeight * 0.385,
              width: sizeWidth * 1,
               decoration: BoxDecoration(
                       gradient: LinearGradient(
                       begin: Alignment.topCenter,  // จุดเริ่มต้นของการไล่ระดับสี (ด้านบน)
                      end: Alignment.bottomCenter, // จุดสิ้นสุดของการไล่ระดับสี (ด้านล่าง)
                      colors: [
                    Color.fromRGBO(229, 229, 229, 0.4),  // สีเข้มสุดด้านบน
                    Color.fromRGBO(229, 229, 229, 0),  // สีจางสุดด้านล่าง (โปร่งใส)
                      ],
                      )
                  ),
              child: Column(
                children: [
                  SizedBox(
                    height: sizeHeight * 0.01,
                  ),
                  Center(
                    child: Text(AppLocalizations.of(context)!.choose,
                        style: Fonts(context, 0.047, true, Colors.black)),
                  ),
                  SizedBox(
                    height: sizeHeight * 0.03, 
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [               
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async  {
                              String DineIn =
                                  'Dine-in : ${_foodOptionController.formattedDate}';
                              _foodOptionController.FromHere();
                              LogFile(DineIn);
                              _foodOptionController.namecat.value = categorie.categoryName['en'] ?? 'default';
                             await getMealNamesByCategoryName(categorie.categoryName['en'].toString());
                              admob_times.reset();
                             Future.delayed(Duration.zero, () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => menu_screen()),
                                );
                              });
                             },
                            child: 
                              Container(
                                height: sizeHeight * 0.2,
                                width: sizeWidth * 0.35,
                                decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(sizeWidth * 0.06),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // สีของเงา
                                    spreadRadius: 1, // กระจายเงา
                                    blurRadius: 10, // ระยะการเบลอของเงา
                                    offset: Offset(5, 5), // การเลื่อนของเงา (x, y)
                                  ),
                               ],
                            ),
                            child: Column(
                            children: [
                            SizedBox(height: sizeHeight * 0.025,),
                        Container(
                          color: Colors.white,
                          child: Image.asset(
                          'assets/restaurant.png',
                          width: sizeWidth * 0.22,
                          height: sizeHeight * 0.11,
                        ),
                      ),
                        SizedBox(height: sizeHeight * 0.012,),
                        Text(
                         AppLocalizations.of(context)!.dineIn,
                          style: Fonts(context, 0.042, false, Colors.black)),
                          ],
                      ),
                        ),
                        ),
                        ],
                      ),
                    SizedBox(
                    width: sizeWidth * 0.038,
                  ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              String Take_Away =
                                  'Take Away : ${_foodOptionController.formattedDate}';
                              LogFile(Take_Away);
                              _foodOptionController.TakeHome();
                               await getMealNamesByCategoryName(categorie.categoryName['en'].toString());
                              admob_times.reset();
                               _foodOptionController.namecat.value = categorie.categoryName['en'] ?? 'default';
                              Future.delayed(Duration.zero, () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => menu_screen()),
                                );
                              });
                              },
                              child: Container(
                                    height: sizeHeight * 0.2,
                                    width: sizeWidth * 0.35,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                      borderRadius: BorderRadius.circular(sizeWidth * 0.06),
                                         boxShadow: [
                                            BoxShadow(
                                            color: Colors.black.withOpacity(0.2), // สีของเงา
                                            spreadRadius: 1, // กระจายเงา
                                            blurRadius: 10, // ระยะการเบลอของเงา
                                            offset: Offset(5, 5), // การเลื่อนของเงา (x, y)
                                        ),
                                        ],
                                     ),
                                      child: Column(
                                        children: [
                                            SizedBox(height: sizeHeight *0.025,),
                                          Container(
                                            color: Colors.white,
                                            child: Image.asset(
                                            'assets/home.png',
                                            width: sizeWidth *0.22,
                                            height: sizeHeight * 0.11,
                                            ),
                                          ),
                                          SizedBox(height: sizeHeight *0.012,),
                                           Text(
                                      AppLocalizations.of(context)!.takeAway,
                                      style: Fonts(context, 0.042, false, Colors.black)),
                                        ],
                                      ),
                                    ),
                          ),
                        ],
                      ),
                    ]),
                  
                ],
              ),
            ),
          ),
         Container(
            height: sizeHeight * 0.023,
            width: sizeWidth * 1,
            color: Color.fromRGBO(239, 17, 0, 1),
            child: Bottombar())
        ]),
      ),
    );
  }
}
