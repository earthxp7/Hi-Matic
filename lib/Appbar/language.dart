import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen/api/Kios_API.dart';
import '../alert/identity.dart';
import '../getxController.dart/save_menu.dart';
import '../timeControl/adtime.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class languageBar extends StatelessWidget {
    final dataKios _dataKios = Get.put(dataKios());
    final FoodOptionController _foodOptionController =
    Get.put(FoodOptionController());
  @override
  Widget build(BuildContext context) {
    final int admob_time = 60;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time: admob_time));
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final DateLog = _foodOptionController.formattedDate;
    String SettingPage = 'Enter the settings panel : ${DateLog}';
    List Language = [
      'assets/Language/Thai.png',
      'assets/Language/English.png',
      'assets/Language/Chinese.png'
    ];
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: sizeWidth *0.015,
          ),
          GestureDetector(
            onTap: (() {
              if (_foodOptionController.tapCount < 9) {
                _foodOptionController.tapCount++;
              } else {
                showLoginDialog(context);
                LogFile(SettingPage);
                adtimeController.stopTimerAndReset();
                _foodOptionController.tapCount.value = 0;
              }
            }),
            child: Container(
                width: sizeWidth * 0.11,
                height: sizeHeight * 0.55,
                color: Colors.white,
                child: Image.asset("assets/Logo_HI-TOP.png",
                 scale: 0.5,)),
                
          ),
          SizedBox(
            width: sizeWidth * 0.71,
          ),
        
          Wrap(
              spacing: sizeWidth * 0.0075,
              runSpacing: 40,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: List.generate(Language.length, (index) {
                return GestureDetector(
                    onTap: () async {
                      _dataKios.languageValue.value = index;
                      if (_dataKios.languageValue.value == 0) {
                        _dataKios.language.value = 'th';
                      } else if (_dataKios.languageValue.value == 1) {
                        _dataKios.language.value = 'en';
                      } else if (_dataKios.languageValue.value == 2) {
                        _dataKios.language.value = 'zh';
                      }
                      Get.updateLocale(Locale('${_dataKios.language.value}'));
                    },
                    child: Obx(
                      () => Container(
                          height: sizeHeight * 0.045,
                          width: sizeWidth * 0.045,
                          child: (_dataKios.languageValue.value == index)
                              ? Image.asset(
                                  Language[index],
                                  height: sizeHeight * 0.08,
                                  width: sizeWidth * 0.08,
                                )
                              : ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                      Color.fromARGB(255, 87, 85, 85),
                                      BlendMode.modulate),
                                  child: Image.asset(
                                    Language[index],
                                    height: sizeHeight * 0.08,
                                    width: sizeWidth * 0.08,
                                  ),
                                )),
                    ));
              })),
        ],
      ),
    );
  }
}
