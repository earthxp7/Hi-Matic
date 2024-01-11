import 'dart:convert';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:screen/screen/menu_screen.dart';
import 'package:screen/screen/selection_screen.dart';
import '../UI/Font/ColorSet.dart';
import '../api/Kios_API.dart';
import 'package:image/image.dart' as img;
import '../getxController.dart/printer_setting.dart';
import '../getxController.dart/save_menu.dart';
import '../printer/printer_USB.dart';
import '../timeControl/adtime.dart';

_launchNetWorkSettings() {
  final intent = AndroidIntent(
    action: 'android.settings.WIRELESS_SETTINGS',
  );
  intent.launch();
}

_launchSystemSettings() {
  final intent = AndroidIntent(
    action: 'android.settings.SETTINGS',
  );
  intent.launch();
}

final List<String> settingName = [
  'Android System',
  'Network System',
  'Close The App',
];

class Setting_Screen extends StatelessWidget {
  final pinter_test printer_Test = Get.put(pinter_test());
  final UsbDeviceController usbDeviceController =
      Get.put(UsbDeviceController());
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final dataKios _dataKios = Get.put(dataKios());
  final FlutterUsbPrinter flutterUsbPrinter = FlutterUsbPrinter();

  @override
  Widget build(BuildContext context) {
    TextEditingController IP_Printer =
        TextEditingController(text: printer_Test.ipAddresses.value);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final int admob_time = 60;
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final AdMobTimeController adtimeController =
        Get.put(AdMobTimeController(admob_time));
    return Scaffold(
      body: Column(
        children: [
          Column(
            children: [
              Container(
                height: sizeHeight * 0.085,
                width: sizeWidth * 1,
                color: Colors.black,
                child: Row(
                  children: [
                    Transform.translate(
                      offset: Offset(400.0, 0.0),
                      child: Text("Settings screen",
                          style: Fonts(context, 0.04, true, Colors.white)),
                    ),
                  ],
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
                                  'Close The Application?',
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
                                      if (usbDeviceController.connected.value) {
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
                                  'Open Network System Page?',
                                  style: GoogleFonts.kanit(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      String Network =
                                          'Open Network System Page : ${_foodOptionController.formattedDate}';
                                      _launchNetWorkSettings();
                                      LogFile(Network);
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
                                  'Open Android System Page?',
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
                                      _launchSystemSettings();
                                      LogFile(Android);
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
            height: sizeHeight * 0.05,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 700),
            child: Text(
              'Print Test',
              style: GoogleFonts.kanit(
                  fontSize: sizeHeight * 0.025, color: Colors.black),
            ),
          ),
          Container(
            height: sizeHeight * 0.12,
            width: sizeWidth * 1,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: printer_Test.FixPrint.length,
              itemBuilder: (context, index) {
                final use = printer_Test.FixPrint[index];
                return Transform.scale(
                  scale: 1.5,
                  child: Obx(() {
                    return Column(
                      children: [
                        RadioListTile(
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
                                            value: printer_Test
                                                        .selectedRadio.value ==
                                                    use
                                                ? printer_Test
                                                    .selectedDropdownValues[use]
                                                : null,
                                            onChanged: (Map<String, dynamic>
                                                newValue) {
                                              printer_Test
                                                      .selectedDropdownValues[
                                                  use] = newValue;
                                              /*print(
                                              'Radio is ${_foodOptionController.printerValue.value}');
                                          String printer =
                                              'Printer  : ${_foodOptionController.formattedDate} ${newValue['vendorId']} - ${newValue['productId']}';

                                          LogFile(printer);*/
                                              adtimeController.reset();
                                            },
                                            items: printer_Test.devices.value
                                                .map<
                                                    DropdownMenuItem<
                                                        Map<String, dynamic>>>(
                                              (Map<String, dynamic> device) {
                                                return DropdownMenuItem<
                                                    Map<String, dynamic>>(
                                                  value: device,
                                                  child: Text(
                                                    'VID : ${device['vendorId']} , PID : ${device['productId']}',
                                                    style: GoogleFonts.kanit(
                                                      fontSize:
                                                          sizeHeight * 0.012,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).toList())
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
                                                labelText: '  ใส่ IP ของคุณ',
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
                            horizontal: 250,
                            vertical: 20,
                          ),
                          value: use,
                          groupValue: printer_Test.selectedRadio.value,
                          onChanged: (value) {
                            printer_Test.selectedRadio.value = value;
                            _foodOptionController.printerValue.value = value;
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
                Map<String, dynamic> usbInfo =
                    printer_Test.selectedDropdownValues['USB'];
                if (usbInfo != null) {
                  var cutCommand = Uint8List.fromList([0x1D, 0x56, 0x00]);
                  String productId = usbInfo['productId'];
                  String vendorId = usbInfo['vendorId'];
                  connect(vendorId, productId);
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
                Map<String, dynamic> usbInfo =
                    printer_Test.selectedDropdownValues['USB'];
                if (usbInfo != null) {
                  String productId = usbInfo['productId'];
                  String vendorId = usbInfo['vendorId'];
                  connect(vendorId, productId);
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
          Transform.translate(
            offset: Offset(0.0, 700.0),
            child: GestureDetector(
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
                        'Return To Menu Page?',
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
                            Navigator.of(context).pushReplacement(
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
              },
              child: Container(
                height: sizeHeight * 0.05,
                width: sizeWidth * 0.8,
                color: Colors.black,
                child: Center(
                  child: Text(
                    "Return To Menu Page",
                    style: GoogleFonts.kanit(
                      fontSize: sizeHeight * 0.02,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> connect(String vendorIdString, String productIdString) async {
    try {
      int vendorId = int.parse(vendorIdString);
      int productId = int.parse(productIdString);
      bool returned = await flutterUsbPrinter.connect(vendorId, productId);
      if (returned) {
        printer_Test.test_connected.value = true;
      }
    } on PlatformException catch (e) {
      print('Connection error: $e');
    }
  }

  Future<void> printTEXT() async {
    try {
      var Test = <int>[];
      var choose = _foodOptionController.choose.value;
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);
      final cutCommand = Uint8List.fromList([0x1D, 0x56, 0x00]);
      //
      var lineFeedCommand = Uint8List.fromList([0x0A, 0x0A, 0x0A]);
      var kiosID = _dataKios.reqKiosdata[0]['kiosks']['kiosksId'];
      var nameRes = "Restaurant name";
      var Nameres = utf8.encode(nameRes);
      var Choose = utf8.encode(choose);
      var formattedDate =
          DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
      var ForRestaurant = ('(Restaurant)');
      var line = '-----------------------------------------------';
      const double paperWidth = 45.0;
      List<int> centerText(List<int> textBytes) {
        final double textWidth = textBytes.length.toDouble();
        final double margin = (paperWidth - textWidth) / 2.0;
        final List<int> centeredText = [];
        centeredText.addAll(List.filled(margin.round(), 0x20));
        centeredText.addAll(textBytes);
        centeredText.addAll(List.filled(margin.round(), 0x20));
        return centeredText;
      }

      Test.addAll(centerText(Nameres));
      Test.addAll([0x0A]);
      Test.addAll(centerText((utf8.encode(ForRestaurant))));
      Test.addAll([0x0A]);
      Test.addAll(centerText(Choose));
      Test.addAll([0x0A]);
      Test.addAll(centerText((utf8.encode("Ordered at $formattedDate"))));
      Test.addAll([0x0A]);
      Test.addAll(utf8.encode('Kiosk ID# $kiosID'));
      Test.addAll([0x0A]);
      Test.addAll(utf8.encode('$line'));
      Test.addAll(lineFeedCommand);
      await flutterUsbPrinter.write(Uint8List.fromList(Test));
      //await flutterUsbPrinter.write(lineFeedCommand);
      await flutterUsbPrinter.write(cutCommand);
      /* Test.clear();
        printer_Test.test_connected.value = false;*/

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
      final img.Image image = img.decodeImage(bytesImg);
      var imageLogo = generator.image(img.decodeImage(resizedImage));
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
}
