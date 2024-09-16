import 'package:flutter/material.dart';
import 'package:screen/screen/setting_screen.dart';
import '../UI/Font/ColorSet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController passwordController = TextEditingController();
      final sizeHeight = MediaQuery.of(context).size.height;
      final sizeWidth = MediaQuery.of(context).size.width;

      return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sizeWidth *0.01),
            ),
            title: 
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: sizeWidth * 0.6,
                    height: sizeHeight * 0.07,
                    //color: Colors.yellow,
                    child: Center(
                      child: Text(AppLocalizations.of(context)!.confirm_identity,
                          style: Fonts(context, 0.048, true, Colors.black)),
                    ),
                  ),
                ),
              
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.enter_password,
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
                    width: sizeWidth * 0.3,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String password = passwordController.text;
                      if (password == 'hitop') {
                        Navigator.pushReplacement(
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
                            content: Text(AppLocalizations.of(context)!.failed_identity,
                                style:Fonts(context, 0.04, true, Colors.white)),
                                      backgroundColor: Color.fromRGBO(237, 28, 36, 1.0),
                          ),
                        );
                      }
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
                  )
                ],
              )
            ],
          ));
    },
  );
}
