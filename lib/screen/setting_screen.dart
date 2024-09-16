import 'dart:convert';
import 'dart:io';
import 'package:charset_converter/charset_converter.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screen/Appbar/language.dart';
import 'package:screen/screen/selection_screen.dart';
import '../UI/Font/ColorSet.dart';
import '../api/Kios_API.dart';
import 'package:image/image.dart' as img;
import '../getxController.dart/printer_setting.dart';
import '../getxController.dart/save_menu.dart';
import '../printer/printer_USB.dart';
import '../timeControl/adtime.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final FlutterUsbPrinter flutterUsbPrinter = FlutterUsbPrinter();
final dataKios _dataKios = Get.put(dataKios());

void openNetworkSettings() {
 AppSettings.openAppSettings(type: AppSettingsType.wifi);
}
void openAndroidettings() {
AppSettings.openAppSettings(type: AppSettingsType.device, asAnotherTask: true);
    
}


final List<String> settingName = [
  'Android System',
  'Network System',
  'Close The App',
];

Future<void> Connects(int vendorId, int productId) async {
  try {
    bool? returned = await flutterUsbPrinter.connect(vendorId, productId);
    if (returned == true) {
      _dataKios.connected.value = true;
      ('เชื่อมต่อ');
    }
  } on PlatformException catch (e) {
    print('Connection error: $e');
  }
  print('USB : ${_dataKios.connected.value}');
}

final pinter_test printer_Test = Get.put(pinter_test());

class Setting_Screen extends StatelessWidget {
  final UsbDeviceControllers usbDeviceController =
      Get.put(UsbDeviceControllers());
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  TextEditingController IP_Printer =
      TextEditingController(text: printer_Test.ipAddresses.value);
  final FlutterUsbPrinter flutterUsbPrinter = FlutterUsbPrinter();

  @override
  Widget build(BuildContext context) {
    final int admob_time = 60;
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time: admob_time));
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Container(
                      height: sizeHeight * 0.04,
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
                      child: languageBar(),
                    ),
                Container(
                  height: sizeHeight * 0.045,
                  width: sizeWidth * 1,
                  color: Colors.black,
                  child:  Align(
                    alignment: Alignment.center,
                    child: Text( AppLocalizations.of(context)!.setting_page,
                              style: Fonts(context, 0.04, true, Colors.white)),
                    ),
                ),
                Container(
                  height: sizeHeight * 0.1,
                  width: sizeWidth * 0.8,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: settingName.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          String Category =
                              'Settings category ${settingName[index]} : ${_foodOptionController.formattedDate}';
                          LogFile(Category);
                          //ปิดแอพพลิเคชั่น
                          if (settingName[index] == 'Close The App') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        16), // Adjust the radius as needed
                                  ),
                                  title: Text(
                                     AppLocalizations.of(context)!.confirm_close_app,
                                    style: GoogleFonts.kanit(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        String Close =
                                            'Close the application : ${_foodOptionController.formattedDate}';
                                        LogFile(Close);
                                        SystemNavigator.pop();
                                      },
                                      child: Text(
                                         AppLocalizations.of(context)!.agree,
                                        style: GoogleFonts.kanit(
                                          fontSize: 34,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                         AppLocalizations.of(context)!.cancel,
                                        style: GoogleFonts.kanit(
                                          fontSize: 34,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          if (settingName[index] == 'Test Printer') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        16), // Adjust the radius as needed
                                  ),
                                  title: Text(
                                    'Test Printer?',
                                    style: GoogleFonts.kanit(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        String testprinter =
                                            'Test the printer : ${_foodOptionController.formattedDate}';
                                        String not_connect =
                                            'Printer is not connected : ${_foodOptionController.formattedDate}';
                                        if (_dataKios.connected.value) {
                                          if (_dataKios.queue.value == 99) {
                                            _dataKios.queue.value = 1;
                                          }
                                         usbDeviceController.prints();
                                          LogFile(testprinter);
                                        } else {
                                          print('Printer is not connected.');
                                          LogFile(not_connect);
                                        }
                                      },
                                      child: Text(
                                        'OK',
                                        style: GoogleFonts.kanit(
                                          fontSize: 34,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: GoogleFonts.kanit(
                                          fontSize: 34,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          //เปิดหน้า Network system
                          if (settingName[index] == 'Network System') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        16), // Adjust the radius as needed
                                  ),
                                  title: Text(
                                     AppLocalizations.of(context)!.confirm_open_network_system,
                                    style: GoogleFonts.kanit(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        openNetworkSettings();
                                        String Network =
                                            'Open Network System Page : ${_foodOptionController.formattedDate}';
                                        //  _launchNetWorkSettings();
                                        LogFile(Network);
                                      },
                                      child: Text(
                                         AppLocalizations.of(context)!.agree,
                                        style: GoogleFonts.kanit(
                                          fontSize: 34,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                         AppLocalizations.of(context)!.cancel,
                                        style: GoogleFonts.kanit(
                                          fontSize: 34,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          if (settingName[index] == 'Android System') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        16), // Adjust the radius as needed
                                  ),
                                  title: Text(
                                     AppLocalizations.of(context)!.confirm_open_android_system,
                                    style: GoogleFonts.kanit(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        String Android =
                                            'Open Android System Page : ${_foodOptionController.formattedDate}';
                                        openAndroidettings();
                                        LogFile(Android);
                                      },
                                      child: Text(
                                         AppLocalizations.of(context)!.agree,
                                        style: GoogleFonts.kanit(
                                          fontSize: 34,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.cancel,
                                        style: GoogleFonts.kanit(
                                          fontSize: 34,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          _foodOptionController.namecat.value =
                              settingName[index];
                          _foodOptionController.showSkeleton.value = true;
                          await Future.delayed(const Duration(microseconds: 2));
                          _foodOptionController.showSkeleton.value = false;
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Obx(() => AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                        color: _foodOptionController
                                                    .namecat.value ==
                                                settingName[index]
                                            ? Color(0xFFFF9800) //สีที่ถูกเลือก
                                            : Colors.black, //สีที่ไม่ถูกเลือก
                                        borderRadius: BorderRadius.circular(
                                            sizeHeight * 0.05),
                                        border: Border.all(
                                          color: Colors.transparent,
                                          width: 2.0,
                                        )),
                                    child: Center(
                                      child: Text(
                                        settingName[index],
                                        style: GoogleFonts.kanit(
                                            fontSize: sizeHeight * 0.016,
                                            color: _foodOptionController
                                                        .namecat.value ==
                                                    settingName[index]
                                                ? Colors.black
                                                : Colors.white),
                                      ),
                                    ),
                                    height: sizeHeight * 0.04,
                                    width: sizeWidth * 0.25,
                                  ))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: sizeHeight * 0.02,
            ),
             Align(
              alignment: Alignment(-0.8, 0),
               child: Text(
                   AppLocalizations.of(context)!.print_test,
                  style: GoogleFonts.kanit(
                      fontSize: sizeHeight * 0.025, color: Colors.black),
                ),
             ),
            
            Container(
              height: sizeHeight * 0.2,
              width: sizeWidth * 1,
            //  color: Colors.amber,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: printer_Test.FixPrint.length,
                itemBuilder: (context, index) {
                  final use = printer_Test.FixPrint[index];
                  return Transform.scale(
                    scale: 1.7,
                    child: Obx(() {
                      return Column(
                        children: [
                          RadioListTile(
                            activeColor: Colors.black, 
                            title: Row(
                              children: [
                                Text(
                                  use,
                                  style: GoogleFonts.kanit(
                                    fontSize: sizeWidth * 0.02,
                                  ),
                                ),
                                if (_foodOptionController.printerValue.value ==
                                    use)
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: (_foodOptionController
                                                  .printerValue.value ==
                                              'USB')
                                          ? DropdownButton<Map<String, dynamic>>(
                                            key: UniqueKey(),
                                            value: _getDefaultSelectedDevice() ??
                                            (printer_Test.devices.value.isNotEmpty ? printer_Test.devices.value.first : null),
                                            onChanged: (Map<String, dynamic>? newValue) {
                                            if (newValue != null) {
                                            printer_Test.selectedDropdownValues[use] = newValue;
                                            _dataKios.productIds.value = int.parse(newValue['productId']);
                                            _dataKios.vendorIds.value = int.parse(newValue['vendorId']);
      
                                            Connects(_dataKios.vendorIds.value, _dataKios.productIds.value);
                                            adtimeController.reset();
                                                }
                                              },
                                            items: printer_Test.devices.value.map<DropdownMenuItem<Map<String, dynamic>>>(
                                            (Map<String, dynamic> device) {
                                            return DropdownMenuItem<Map<String, dynamic>>(
                                            value: device,
                                            child: Text(
                                            'VID : ${device['vendorId']} , PID : ${device['productId']}',
                                            style: GoogleFonts.kanit(
                                            fontSize: sizeHeight * 0.012,
                                            color: Colors.black,
                                                  ),
                                                ),
                                              );
                                            },
                                          ).toList(),
                                        )

                                          : Container(
                                              width: sizeWidth * 0.3,
                                              child: TextField(
                                                style: Fonts(context, 0.02, false,
                                                    Colors.black),
                                                onChanged: (text) {
                                                  printer_Test.ipAddresses.value =
                                                      text;
                                                },
                                                decoration: InputDecoration(
                                                  labelText:  AppLocalizations.of(
                                                                context)!
                                                            .input_ip,
                                                  labelStyle: Fonts(
                                                    context,
                                                    0.02,
                                                    false,
                                                    Color.fromRGBO(37, 37, 37, 1),
                                                  ),
                                                  border: OutlineInputBorder(),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 0.5),
                                                ),
                                                controller: IP_Printer,
                                              ),
                                            ),
                                    ),
                                  )
                              ],
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: sizeWidth *0.25,
                              vertical: sizeHeight *0.02,
                            ),
                            value: use,
                            groupValue: printer_Test.selectedRadio.value,
                            onChanged: (value) {
                              printer_Test.selectedRadio.value = value.toString();
                              _foodOptionController.printerValue.value =
                                  value.toString();
                              String printer =
                                  'Printer  : ${_foodOptionController.formattedDate} ';
                              LogFile(printer);
                              adtimeController.reset();
                              print('value :${value} ');
                            },
                          ),
                        ],
                      );
                    }),
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_foodOptionController.printerValue.value == 'USB') {
                  Map<String, dynamic>? usbInfo =
                      printer_Test.selectedDropdownValues['USB'];
                  if (usbInfo != null) {
                    var cutCommand = Uint8List.fromList([0x1D, 0x56, 0x00]);
        
                   Connects(
                        _dataKios.vendorIds.value, _dataKios.productIds.value);
                    if (printer_Test.test_connected.value = true) {
                      printTEXT();
                    } else {
                      print('Failed to connect printer');
                    }
                  } else {
                    print('No information for the USB key');
                  }
                }
              },
              child: Container(
                height: sizeHeight * 0.05,
                width: sizeWidth * 0.8,
                color: Color.fromARGB(255, 233, 230, 230),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    "Test_Printer_TEXT",
                    style: GoogleFonts.kanit(
                      fontSize: sizeHeight * 0.02,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_foodOptionController.printerValue.value == 'USB') {
                  Map<String, dynamic>? usbInfo =
                      printer_Test.selectedDropdownValues['USB'];
                  if (usbInfo != null) {
                    Connects(
                        _dataKios.vendorIds.value, _dataKios.productIds.value);
                    if (printer_Test.test_connected.value = true) {
                      printIMAGE();
                    } else {
                      print('Failed to connect printer');
                    }
                  } else {
                    print('No information for the USB key');
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  height: sizeHeight * 0.05,
                  width: sizeWidth * 0.8,
                  color: Color.fromARGB(255, 233, 230, 230),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Test_Printer_IMAGE",
                      style: GoogleFonts.kanit(
                        fontSize: sizeHeight * 0.02,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: sizeHeight *0.25,
            ),
            Column(
              children: [
                 GestureDetector(
                  onTap: () async {
                  final directory = await getExternalStorageDirectory();
                  final path = '${directory!.path}/Setting.txt';
                  final file = File(path);
        
                  // Delete the file if it already exists
                  if (await file.exists()) {
                    await file.delete();
                  }
        
                  // Retrieve the necessary values
                  final productId = _dataKios.productIds.value;
                  final vendorId = _dataKios.vendorIds.value;
                  final ipaddess =  printer_Test.ipAddresses.value;
        
                  // Prepare the text to be saved
                  final text = 'PID : $productId\nVID : $vendorId\nIP : $ipaddess';
        
                  // Write the text to the file
                    await file.writeAsString(text);
        
                  },
                   child: Container(
                        height: sizeHeight * 0.05,
                        width: sizeWidth * 0.8,
                         decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                          BorderRadius.circular(
                          sizeWidth * 0.02),
                          boxShadow: [
                            BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2, blurRadius: 4,offset:const Offset(6, 6),
                              ),
                            ],
                          ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.save_data,
                            style: GoogleFonts.kanit(
                              fontSize: sizeHeight * 0.02,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                 ),
                    SizedBox(
              height: sizeHeight *0.03,
            ),
                GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  16), // Adjust the radius as needed
                            ),
                            title: Text(
                               AppLocalizations.of(context)!.confirm_return_menu_page,
                              style: GoogleFonts.kanit(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  adtimeController.startTimer(context);
                                  Navigator.of(context).push(
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
                                child: Text(
                                 AppLocalizations.of(context)!.agree,
                                  style: GoogleFonts.kanit(
                                    fontSize: 34,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                               AppLocalizations.of(context)!.cancel,
                                  style: GoogleFonts.kanit(
                                    fontSize: 34,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      height: sizeHeight * 0.05,
                      width: sizeWidth * 0.8,
                       decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius:
                        BorderRadius.circular(
                        sizeWidth * 0.02),
                        boxShadow: [
                          BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2, blurRadius: 4,offset:const Offset(6, 6),
                            ),
                          ],
                        ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.return_menu_page,
                          style: GoogleFonts.kanit(
                            fontSize: sizeHeight * 0.02,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }

  Future<void> printTEXT() async {
    try {
      var Test = <int>[];
      //var choose = _foodOptionController.choose.value;
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);
      final cutCommand = Uint8List.fromList([0x1D, 0x56, 0x00]);
      //
      var lineFeedCommand = Uint8List.fromList([0x0A, 0x0A, 0x0A]);
      ///var kiosID = _dataKios.reqKiosdata[0]['kiosks']['kiosksId'];
      //var nameRes = "Restaurant name";
      var nameRes = "ชื่อร้านอาหาร";
      String thaiText = 'ขอบคุณที่ใช้บริการ';
      //Uint8List encodedText = Uint8List.fromList(utf8.encode(thaiText));
      Uint8List encodedText = await CharsetConverter.encode('ISO-8859-11', thaiText);

      //Uint8List encodedText = await CharsetConverter.encode('TIS-620', thaiText);
      var Nameres = utf8.encode(nameRes);
     // var Choose = utf8.encode(choose);
      var formattedDate =
          DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
      var ForRestaurant = ('(Restaurant)');
      var line = '-----------------------------------------------';
      const double paperWidth = 45.0;
    /*  List<int> centerText(List<int> textBytes) {
        final double textWidth = textBytes.length.toDouble();
        final double margin = (paperWidth - textWidth) / 2.0;
        final List<int> centeredText = [];
        centeredText.addAll(List.filled(margin.round(), 0x20));
        centeredText.addAll(textBytes);
        centeredText.addAll(List.filled(margin.round(), 0x20));
        return centeredText;
      }*/

      // Test.addAll(centerText(Nameres));
      // Test.addAll(centerText(Nameres));
     // Test.addAll((utf8.encode(nameRes))); 
      Test.addAll([0x0A]);
      Test.addAll(((utf8.encode(ForRestaurant))));
      Test.addAll([0x0A]);
      // Test.addAll(centerText(Choose));
      Test.addAll([0x0A]);
      Test.addAll(((utf8.encode("Ordered at $formattedDate"))));
      Test.addAll([0x0A]);
      // Test.addAll(utf8.encode('Kiosk ID# $kiosID'));
      Test.addAll([0x0A]);
      Test.addAll(utf8.encode('$line'));
      Test.addAll(lineFeedCommand);
      await flutterUsbPrinter.write(Uint8List.fromList(Test));
      // await flutterUsbPrinter.write(lineFeedCommand);
      await flutterUsbPrinter.write(cutCommand);
     // Test.clear();
      // printer_Test.test_connected.value = false;*/
    } on PlatformException catch (e) {
      print('ข้อผิดพลาดในการพิมพ์: $e');
    }
  }

  Future<void> printIMAGE() async {
    try {
      var test_pinter = <int>[];
      var cutCommand = Uint8List.fromList([0x1D, 0x56, 0x00]);
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);
      ByteData bytes = await rootBundle.load('assets/logo.png');
      final Uint8List bytesImg = bytes.buffer.asUint8List();
      final int newWidth = 160;
      final int newHeight = 160;
      final Uint8List resizedImage =
          await FlutterImageCompress.compressWithList(
        bytesImg,
        minWidth: newWidth,
        minHeight: newHeight,
        format: CompressFormat.png,
        quality: 80,
        autoCorrectionAngle: false,
      );
      var nameRes = "Restaurant name";
      var Nameres = utf8.encode(nameRes);
      var decodedImage = img.decodeImage(resizedImage);
      var imageLogo = generator.image(decodedImage ?? img.Image(1, 1));
      var lineFeedCommand = Uint8List.fromList([0x0A, 0x0A]);
      test_pinter.addAll(lineFeedCommand);
      test_pinter.addAll(imageLogo);
      // test_pinter.addAll(Nameres);
      test_pinter.addAll(lineFeedCommand);

      await flutterUsbPrinter.write(Uint8List.fromList(test_pinter));
      await flutterUsbPrinter.write(cutCommand);
    } on PlatformException catch (e) {
      print('ข้อผิดพลาดในการพิมพ์: $e');
    }
  }

 Map<String, dynamic>? _getDefaultSelectedDevice() {
  final defaultVendorId = _dataKios.vendorIds.value.toString();
  final defaultProductId = _dataKios.productIds.value.toString();

  // ค้นหาค่าที่ตรงกันใน devices
  final device = printer_Test.devices.value.firstWhere(
    (device) =>
      device['vendorId'] == defaultVendorId &&
      device['productId'] == defaultProductId,
    orElse: () => {},
  );

  // ตรวจสอบให้แน่ใจว่ามีค่าเดียวกันกับรายการใน Dropdown
  if (device != {} && printer_Test.devices.value.contains(device)) {
    return device;
  }

  return null;
}

}
