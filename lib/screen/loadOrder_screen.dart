import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_device_identifier/flutter_device_identifier.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screen/getxController.dart/save_menu.dart';
import 'package:screen/screen/ads_screen.dart';
import 'package:screen/timeControl/connect_internet.dart';
import '../api/Kios_API.dart';
import 'package:connectivity/connectivity.dart';

import '../getxController.dart/printer_Test.dart';

class LoadData extends StatelessWidget {
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());

  List<dynamic> menu = [];
  final dataKios _dataKios = Get.put(dataKios());
  final pinter_test printer_Test = Get.put(pinter_test());
  //ดาวน์โหลดข้อมูล
  Future<double> checkFileSizeInMB(String filePath) async {
    File file = File(filePath);
    if (await file.exists()) {
      int fileSize = await file.length();
      double fileSizeInMB = fileSize / (1024 * 1024); // แปลงเป็น MB
      return fileSizeInMB;
    } else {
      throw FileSystemException("ไฟล์ไม่มีอยู่");
    }
  }

  Future<bool> downloadAndSaveFile(String url, String fileName) async {
    final directory = await getExternalStorageDirectory();
    final savePath = '${directory.path}/$fileName';

    try {
      final dio = Dio();
      final response = await dio.download(url, savePath);

      if (response.statusCode == 200) {
        double fileSizeInMB = await checkFileSizeInMB(savePath);
        print('ดาวน์โหลดสำเร็จ - ขนาด: ${fileSizeInMB.toStringAsFixed(2)} MB');
        return true;
      } else {
        print('ดาวน์โหลดล้มเหลว - รหัสสถานะ HTTP: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('ข้อผิดพลาดระหว่างการดาวน์โหลด: $e');
      return false;
    }
  }

  Future initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await FlutterDeviceIdentifier.platformVersion ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    await FlutterDeviceIdentifier.requestPermission();
    _dataKios.serialNumbers.value = await FlutterDeviceIdentifier.serialCode;
  }

  Future<reqKiosdata> reqKios() async {
    http.Client client = http.Client();
    final kiosksSn = _dataKios.serialNumbers.value;
    //3MF2209002140212   //'9FP46D1UQ8QATAJK';
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://hqhitop.thddns.net:60000/api/devices/kiosksConnection'));
    request.body = json.encode({"serialNumber": kiosksSn});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseBody);
      final kiosksId = jsonResponse['kiosks']['kiosksId'];
      final customerId = jsonResponse['kiosks']['customerId'];
      _dataKios.reqKiosdata.add(jsonResponse);
      print(
          'SerialNumbers : ${_dataKios.reqKiosdata[0]['kiosks']['customerId']}');
     
      return reqKiosdata(kiosksId: kiosksId, customerId: customerId);
    } else {
      print(response.reasonPhrase);
      throw Exception('เกิดข้อผิดพลาดในการร้องขอ Kios');
    }
  }

  Future<void> GetPayment() async {
    http.Client client = http.Client();
    String customerId = _dataKios.reqKiosdata[0]['kiosks']['customerId'];

    final url =
        'http://hqhitop.thddns.net:60000/api/devices/getPaymentInfoById?customerId=$customerId';
    print('Payment ${url}');
    final uri = Uri.parse(url);
    print('GetPayment ${uri}');
    final response = await client.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final results = json['data'] as List<dynamic>;
    final paymentdata = await Future.wait(results.map((e) async {
      final customerId = e['customerId'];
      final paymentId = e['paymentId'];
      final paymentName = e['paymentName'];
      final paymentProvider = e['paymentProvider'];
      final paymentStatus = e['paymentStatus'];
      final appid = e['paymentData']['appid'];
      final feeType = e['paymentData']['fee_type'];
      final channelData = e['paymentData']['channel'];
      final channelLength = channelData.length;
      final optionData = e['paymentData']['channel'] as List<dynamic>;
      for (var optionData in channelData) {
        final name = optionData['name'];
        final rate = optionData['rate'];

        return Paymentdata(
            customerId: customerId,
            paymentId: paymentId,
            paymentName: paymentName,
            paymentProvider: paymentProvider,
            paymentStatus: paymentStatus,
            appid: appid,
            fee_type: feeType,
            channelname: name,
            channelrate: rate,
            channelLength: channelLength,
            optionData: channelData);
      }
    }).toList());
    _dataKios.paymentdata = paymentdata;
  }

  Future GetMenu() async {
    final directory = await getExternalStorageDirectory();
    http.Client client = http.Client();
    String kiosID = _dataKios.reqKiosdata[0]['kiosks']['kiosksId'];
    var url =
        'http://hqhitop.thddns.net:60000/api/devices/getKiosksMealById?kiosksId=$kiosID';
    //  'http://192.168.0.9/api/devices/getKiosksMealById?kiosksId=$kiosID';
    final uri = Uri.parse(url);
    print(url);
    print('GetMenu ${uri}');
    final response = await client.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final results = json['kiosksMeal'] as List<dynamic>;
    final transformed = await Future.wait(results.map((e) async {
      final categoryId = e['categoryId'];
      var categoryImage = e['categoryImage'];
      final categoryNameTH = e['categoryName']['th'];
      final categoryNameEN = e['categoryName']['en'];
      final categoryDescriptionTH = e['categoryDescription']['th'];
      final categoryDescriptionEN = e['categoryDescription']['en'];
      final categoryImageType = e['categoryImageType'];

      if (categoryNameEN == 'Foods') {
        final directory = await getExternalStorageDirectory();
        final mealsData = e['meals'] is List<dynamic> ? e['meals'] : [];
        final foodData = mealsData.map((meal) {
          final mealNameID = meal['mealId'];
          final mealNameTH = meal['mealName']['th'];
          final mealNameEN = meal['mealName']['en'];
          var mealImage = meal['mealImage'];
          final mealDescriptionTH = meal['mealDescription']['th'];
          final mealDescriptionEN = meal['mealDescription']['en'];
          final mealPrice = meal['mealPrice'];
          final mealOptions = meal['mealOption'] as List<dynamic>;
          final int mealOptionsLength = mealOptions.length;

          for (var option in mealOptions) {
            final optioncategory = option['mealDetails'];
            final multipleSelect = option['multipleSelect'];
            final forcedChoice = option['forcedChoice'];
            final mealOptionsCat = option['option'] as List<dynamic>;
            final int mealOptionsCatLength = mealOptionsCat.length;
            for (var optionmenu in mealOptionsCat) {
              final mealOptionname = optionmenu['name'];
              final mealOptionprice = optionmenu['price'];
              // สร้าง Map ของข้อมูลอาหารและเพิ่มลงใน foodList
              final fileName = 'food_${mealNameID.toString()}.png';
              final savePath = '${directory.path}/$fileName';
              final saved = downloadAndSaveFile(mealImage, fileName);
              mealImage = savePath;
              return FoodsItem(
                  mealId: mealNameID,
                  mealNameTH: mealNameTH,
                  mealNameEN: mealNameEN,
                  mealImage: mealImage,
                  forcedChoice: forcedChoice,
                  multipleSelect: multipleSelect,
                  mealDescriptionTH: mealDescriptionTH,
                  mealDescriptionEN: mealDescriptionEN,
                  mealPrice: mealPrice,
                  optioncategory: optioncategory,
                  mealOptionname: mealOptionname,
                  mealOptionprice: mealOptionprice,
                  mealOptionsLength: mealOptionsLength,
                  mealOptionsCatLength: mealOptionsCatLength,
                  mealOptions: mealOptions,
                  mealOptionsCat: mealOptionsCat);
            }
          }
        }).toList();

        // เพิ่มรายการอาหารลงใน foodList
        _dataKios.foodList = foodData;
      } else if (categoryNameEN == 'Drinks') {
        final directory = await getExternalStorageDirectory();
        final mealsData = e['meals'] is List<dynamic> ? e['meals'] : [];
        final drinkData = mealsData.map((meal) {
          final mealNameID = meal['mealId'];
          final mealNameTH = meal['mealName']['th'];
          final mealNameEN = meal['mealName']['en'];
          var mealImage = meal['mealImage'];
          final mealDescriptionTH = meal['mealDescription']['th'];
          final mealDescriptionEN = meal['mealDescription']['en'];
          final mealPrice = meal['mealPrice'];
          final mealOptions = meal['mealOption'] as List<dynamic>;
          for (var option in mealOptions) {
            final optioncategory = option['mealDetails'];
            final multipleSelect = option['multipleSelect'];
            final forcedChoice = option['forcedChoice'];
            final mealOptionsCat = option['option'] as List<dynamic>;
            final int mealOptionsCatLength = mealOptionsCat.length;
            for (var optionmenu in mealOptionsCat) {
              final mealOptionname = optionmenu['name'];
              final mealOptionprice = optionmenu['price'];
              // สร้าง Map ของข้อมูลเครื่องดื่มและเพิ่มลงใน drinkList
              final fileName = 'drink_${mealNameID.toString()}.png';
              final savePath = '${directory.path}/$fileName';
              final saved = downloadAndSaveFile(mealImage, fileName);
              mealImage = savePath;
              return DrinkItem(
                mealId: mealNameID,
                mealNameTH: mealNameTH,
                mealNameEN: mealNameEN,
                mealImage: mealImage,
                mealDescriptionTH: mealDescriptionTH,
                mealDescriptionEN: mealDescriptionEN,
                mealPrice: mealPrice,
                optioncategory: optioncategory,
                forcedChoice: forcedChoice,
                multipleSelect: multipleSelect,
                mealOptionname: mealOptionname,
                mealOptionprice: mealOptionprice,
                mealOptionsCatLength: mealOptionsCatLength,
                mealOptions: mealOptions,
                mealOptionsCat: mealOptionsCat,
              );
            }
          }
        }).toList();
        // เพิ่มรายการเครื่องดื่มลงใน drinkList
        _dataKios.drinkList = drinkData;
      } else if (categoryNameEN == 'Steak') {
        final directory = await getExternalStorageDirectory();
        final mealsData = e['meals'] is List<dynamic> ? e['meals'] : [];
        final steakData = mealsData.map((meal) {
          final mealNameID = meal['mealId'];
          final mealNameTH = meal['mealName']['th'];
          final mealNameEN = meal['mealName']['en'];
          var mealImage = meal['mealImage'];
          final mealDescriptionTH = meal['mealDescription']['th'];
          final mealDescriptionEN = meal['mealDescription']['en'];
          final mealPrice = meal['mealPrice'];
          final mealOptions = meal['mealOption'] as List<dynamic>;
          for (var option in mealOptions) {
            final optioncategory = option['mealDetails'];
            final multipleSelect = option['multipleSelect'];
            final forcedChoice = option['forcedChoice'];
            final mealOptionsCat = option['option'] as List<dynamic>;
            final int mealOptionsCatLength = mealOptionsCat.length;
            for (var optionmenu in mealOptionsCat) {
              final mealOptionname = optionmenu['name'];
              final mealOptionprice = optionmenu['price'];

              final fileName = 'steak_${mealNameID.toString()}.png';
              final savePath = '${directory.path}/$fileName';
              final saved = downloadAndSaveFile(mealImage, fileName);
              mealImage = savePath;
              return SteakItem(
                mealId: mealNameID,
                mealNameTH: mealNameTH,
                mealNameEN: mealNameEN,
                mealImage: mealImage,
                forcedChoice: forcedChoice,
                multipleSelect: multipleSelect,
                mealDescriptionTH: mealDescriptionTH,
                mealDescriptionEN: mealDescriptionEN,
                mealPrice: mealPrice,
                optioncategory: optioncategory,
                mealOptionname: mealOptionname,
                mealOptionprice: mealOptionprice,
                mealOptionsCatLength: mealOptionsCatLength,
                mealOptions: mealOptions,
                mealOptionsCat: mealOptionsCat,
              );
            }
          }
        }).toList();
        // เพิ่มรายการสเต็กลงใน steakList
        _dataKios.steakList = steakData;
      } else if (categoryNameEN == 'Coffee') {
        final directory = await getExternalStorageDirectory();
        final mealsData = e['meals'] is List<dynamic> ? e['meals'] : [];
        final coffeeData = mealsData.map((meal) {
          final mealNameID = meal['mealId'];
          final mealNameTH = meal['mealName']['th'];
          final mealNameEN = meal['mealName']['en'];
          var mealImage = meal['mealImage'];
          final mealDescriptionTH = meal['mealDescription']['th'];
          final mealDescriptionEN = meal['mealDescription']['en'];
          final mealPrice = meal['mealPrice'];
          final mealOptions = meal['mealOption'] as List<dynamic>;
          for (var option in mealOptions) {
            final optioncategory = option['mealDetails'];
            final multipleSelect = option['multipleSelect'];
            final forcedChoice = option['forcedChoice'];
            final mealOptionsCat = option['option'] as List<dynamic>;
            final int mealOptionsCatLength = mealOptionsCat.length;
            for (var optionmenu in mealOptionsCat) {
              final mealOptionname = optionmenu['name'];
              final mealOptionprice = optionmenu['price'];
              // สร้าง Map ของข้อมูลเครื่องดื่มและเพิ่มลงใน coffeeList
              final fileName = 'coffee_${mealNameID.toString()}.png';
              final savePath = '${directory.path}/$fileName';
              final saved = downloadAndSaveFile(mealImage, fileName);
              mealImage = savePath;

              return CoffeeItem(
                mealId: mealNameID,
                mealNameTH: mealNameTH,
                mealNameEN: mealNameEN,
                mealImage: mealImage,
                mealDescriptionTH: mealDescriptionTH,
                mealDescriptionEN: mealDescriptionEN,
                mealPrice: mealPrice,
                forcedChoice: forcedChoice,
                multipleSelect: multipleSelect,
                optioncategory: optioncategory,
                mealOptionname: mealOptionname,
                mealOptionprice: mealOptionprice,
                mealOptionsCatLength: mealOptionsCatLength,
                mealOptions: mealOptions,
                mealOptionsCat: mealOptionsCat,
              );
            }
          }
        }).toList();
        // เพิ่มรายการสเต็กลงใน coffeeList
        _dataKios.coffeeList = coffeeData;
      } else if (categoryNameEN == 'Noodles') {
        final directory = await getExternalStorageDirectory();
        final mealsData = e['meals'] is List<dynamic> ? e['meals'] : [];
        final noodleData = mealsData.map((meal) {
          final mealNameID = meal['mealId'];
          final mealNameTH = meal['mealName']['th'];
          final mealNameEN = meal['mealName']['en'];
          var mealImage = meal['mealImage'];
          final mealDescriptionTH = meal['mealDescription']['th'];
          final mealDescriptionEN = meal['mealDescription']['en'];
          final mealPrice = meal['mealPrice'];
          final mealOptions = meal['mealOption'] as List<dynamic>;
          for (var option in mealOptions) {
            final optioncategory = option['mealDetails'];
            final multipleSelect = option['multipleSelect'];
            final forcedChoice = option['forcedChoice'];
            final mealOptionsCat = option['option'] as List<dynamic>;
            final int mealOptionsCatLength = mealOptionsCat.length;
            for (var optionmenu in mealOptionsCat) {
              final mealOptionname = optionmenu['name'];
              final mealOptionprice = optionmenu['price'];
              // สร้าง Map ของข้อมูลเครื่องดื่มและเพิ่มลงใน coffeeList
              final fileName = 'noodles_${mealNameID.toString()}.png';
              final savePath = '${directory.path}/$fileName';
              final saved = downloadAndSaveFile(mealImage, fileName);
              mealImage = savePath;
              return NoodleItem(
                mealId: mealNameID,
                mealNameTH: mealNameTH,
                mealNameEN: mealNameEN,
                mealImage: mealImage,
                mealDescriptionTH: mealDescriptionTH,
                mealDescriptionEN: mealDescriptionEN,
                mealPrice: mealPrice,
                forcedChoice: forcedChoice,
                multipleSelect: multipleSelect,
                optioncategory: optioncategory,
                mealOptionname: mealOptionname,
                mealOptionprice: mealOptionprice,
                mealOptionsCatLength: mealOptionsCatLength,
                mealOptions: mealOptions,
                mealOptionsCat: mealOptionsCat,
              );
            }
          }
        }).toList();
        // เพิ่มรายการสเต็กลงใน coffeeList
        _dataKios.noodleList = noodleData;
      }

      final fileName =
          'category_${categoryNameEN}.${categoryImageType == 'image/png' ? 'png' : 'jpeg'}';
      final directory = await getExternalStorageDirectory();
      final savePath = '${directory.path}/$fileName';
      final saved = await downloadAndSaveFile(categoryImage, fileName);
      categoryImage = savePath;
      print('เช็คพาร์ท : ${directory.path}');
      return CategoryModel(
          //เก็บ API หมวดหมู่อาหารไปไว้ใน _foodOptionController.testAPI = transformed;
          categoryId: categoryId,
          categoryNameTH: categoryNameTH,
          categoryNameEN: categoryNameEN,
          categoryDescriptionTH: categoryDescriptionTH,
          categoryDescriptionEN: categoryDescriptionEN,
          categoryImage: categoryImage,
          categoryImageType: categoryImageType);
    }).toList());
    _dataKios.CatList = transformed;
  }

  Future GetAdvert() async {
    http.Client client = http.Client();
    const url = 'http://hqhitop.thddns.net:60000/api/devices/getKiosksAds';
    //  'http://hqhitop.thddns.net:60000/api/devices/getKiosksAdsById?kiosksId=$kiosID';
    final uri = Uri.parse(url);
    final response = await client.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final results = json['kiosksAds'] as List<dynamic>;

    final transformed = await Future.wait(results.map((ad) async {
      final kiosksId = ad['kiosksId'];
      final advertisingsId = ad['advertisingsId'];
      final advertisingName = ad['advertisingName'];
      var advertisingImage =
          ad['advertisingImage']; // Declare as a non-final variable
      final advertisingImageType = ad['advertisingImageType'];
      final advertisingStartTime = ad['advertisingStartTime'];
      final advertisingEndTime = ad['advertisingEndTime'];

      final fileName =
          'advert_${advertisingsId.toString()}.${advertisingImageType == 'video/mp4' ? 'mp4' : 'jpeg'}';
      final directory = await getExternalStorageDirectory();
      final savePath = '${directory.path}/$fileName';
      final saved = await downloadAndSaveFile(advertisingImage, fileName);
      advertisingImage = savePath;

      return Advert(
        kiosksId: kiosksId,
        advertisingsId: advertisingsId,
        advertisingName: advertisingName,
        advertisingImage: advertisingImage,
        advertisingImageType: advertisingImageType,
        advertisingStartTime: advertisingStartTime,
        advertisingEndTime: advertisingEndTime,
      );
    }).toList());

    _dataKios.advertlist = transformed;
  }

  @override
  Widget build(BuildContext ConText) {
    loadDataAPI(ConText);
    final sizeHeight = MediaQuery.of(ConText).size.height;
    final sizeWidth = MediaQuery.of(ConText).size.width;
    // print('${_dataKios.notcon.value}');
    return Scaffold(
      body: Container(
        height: sizeHeight * 1,
        width: sizeWidth * 1,
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 500),
                child: Container(
                  height: sizeHeight * 0.25,
                  width: sizeWidth * 0.8,
                  child: Lottie.asset('assets/loading.json'),
                ),
              ),
              Text(
                'Please Wait A Moment',
                style: GoogleFonts.kanit(
                  fontSize: sizeWidth * 0.07,
                ),
              ),
              Text(
                'Checking The Food List',
                style: GoogleFonts.kanit(
                  fontSize: sizeWidth * 0.05,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> USB_VID_PID() async {
    List<Map<String, dynamic>> results =
        await FlutterUsbPrinter.getUSBDeviceList();
    printer_Test.devices.value.assignAll(results);
  }

  Future<void> LAN_IP() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4) {
          // Store the IPv4 address in the list
          printer_Test.ipAddresses.value.add({'ipAddress': addr.address});
        }
      }
    }
  }

  /*  Future<void> PaymentSocket() async {
    final String URL = 'http://192.168.0.9:15672';
    final String host = '192.168.0.9'; // RabbitMQ Management Plugin URL
    final String username = 'adminht';
    final String password = '@minht9953293';
    final String exchanges = 'statusPayment';
    final String queues = 'KiosksPayment';
    final String rout_key = '3MF2209002140212';
    ConnectionSettings settings = ConnectionSettings(
        host: host, authProvider: PlainAuthenticator(username, password));
    Client client = Client(settings: settings);

    Channel channel = await client.channel();
    Queue queue = await channel.queue(
      queues,
      durable: true,
      exclusive: false,
      autoDelete: false,
      arguments: null,
    );

    Exchange Exchanges = await channel.exchange(
      exchanges,
      ExchangeType.DIRECT,
    );
    await queue.bind(Exchanges, rout_key);

    Consumer consumer = await queue.consume();
    // ใช้ listen() เพื่อรับข้อมูลจาก Queue
    consumer.listen((AmqpMessage message) {
      print('Received message: ${message.payloadAsString}');
    });
  }*/

  void loadDataAPI(BuildContext context) async {
    final int connect = 300;
    final connectNetwork _connectNetwork = Get.put(connectNetwork(connect));
    await initPlatformState();
    await reqKios();
    _connectNetwork.startTimer(context);
    await GetMenu();
    await GetAdvert();
    await GetPayment();
    await USB_VID_PID();
    await LAN_IP();
    // await PaymentSocket();
    /* print('IP :${_dataKios.ipAddresses}');
    print(' devices : ${_dataKios.devices}');
    print('Kios : ${_dataKios.reqKiosdata[0]['kiosks']['kiosksId']}');
    print('CustomerId : ${_dataKios.reqKiosdata[0]['kiosks']['customerId']}');*/

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Ads_screen(),
          );
        },
      ),
    );
  }
}
