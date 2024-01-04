import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen/screen/setting_screen.dart';
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
                    child: Text(
                      'Confirm Your Identity!',
                      style: GoogleFonts.roboto(
                        fontSize: sizeHeight * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                      labelText: 'Enter Your Password',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 300),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.roboto(
                        fontSize: sizeHeight * 0.02,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
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
                        content: Text(
                          'The Password Is Incorrect',
                          style: GoogleFonts.roboto(
                            fontSize: sizeHeight * 0.03,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'OK',
                  style: GoogleFonts.roboto(
                    fontSize: sizeHeight * 0.02,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ));
    },
  );
}
