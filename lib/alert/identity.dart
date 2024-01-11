import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen/screen/setting_screen.dart';
import '../UI/Font/ColorSet.dart';
import '../timeControl/adtime.dart';

void showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController passwordController = TextEditingController();
      final int admob_time = 60;
      final admob_times = Get.put(AdMobTimeController(admob_time));
      final sizeHeight = MediaQuery.of(context).size.height;
      final sizeWidth = MediaQuery.of(context).size.width;

      return WillPopScope(
          onWillPop: () async {
            return false; // ป้องกันผู้ใช้ปิด AlertDialog โดยการคลิกที่พื้นที่ว่าง
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Row(
              children: [
                Container(
                  width: sizeWidth * 0.5,
                  height: sizeHeight * 0.07,
                  child: Center(
                    child: Text('กรุณายืนยันตัวตน!',
                        style: Fonts(context, 0.05, true, Colors.black)),
                  ),
                )
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'ใส่รหัสของคุณที่นี่',
                      labelStyle: Fonts(context, 0.02, true,
                          Color.fromRGBO(214, 214, 214, 1)),
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('ยกเลิก',
                        style: Fonts(context, 0.035, true, Colors.white)),
                  ),
                  SizedBox(
                    width: sizeWidth * 0.27,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String password = passwordController.text;
                      if (password == 'hitop') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return WillPopScope(
                                onWillPop: () async {
                                  return false;
                                },
                                child: Setting_Screen(),
                              );
                            },
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('การยืนยันตัวตนไม่ผ่าน',
                                style:
                                    Fonts(context, 0.04, true, Colors.white)),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('ตกลง',
                        style: Fonts(context, 0.035, true, Colors.white)),
                  )
                ],
              )
            ],
          ));
    },
  );
}
