import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_device_identifier/flutter_device_identifier.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screen/getxController.dart/save_menu.dart';
import 'package:screen/main.dart';
import 'package:screen/screen/ads_screen.dart';
import 'package:screen/screen/setting_screen.dart';
import 'package:screen/timeControl/connect_internet.dart';
import '../UI/Font/ColorSet.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/printer_setting.dart';
import 'notAvailable_screen.dart';

final connectNetwork _connectNetwork =
    Get.put(connectNetwork(connect: connect));

class LoadData extends StatelessWidget {
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  String HeadTextError = "ขออภัยในความไม่สะดวก";
  String TextError = "ตู้ของท่านยังไม่ได้รับการลงทะเบียน";
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
    final savePath = '${directory!.path}/$fileName';

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

  /*Future<reqKiosdata> reqKios() async {
    http.Client client = http.Client();
    final kiosksSn =  '4FA2252008971253';//_dataKios.serialNumbers.value;
    //print('SN : ${_dataKios.serialNumbers.value}');
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
      throw Exception('เกิดข้อผิดพลาดในการร้องขอ Kios');
    }
  }*/
Future<reqKiosdata> reqKios() async {
  http.Client client = http.Client();
  final kiosksSn = "4FA2252008971253"; // กำหนดหมายเลข Serial Number ของ Kios
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request(
    'POST',
    Uri.parse('http://206.189.36.97:3146/API/devices/login'),
  );
  request.body = json.encode({"serial_number": kiosksSn});
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String responseBody = await response.stream.bytesToString();
    
    // พิมพ์ responseBody เพื่อตรวจสอบข้อมูลที่ส่งกลับมา
    print('Response Body: $responseBody');
    
    Map<String, dynamic> jsonResponse = json.decode(responseBody);
    
    // พิมพ์ jsonResponse เพื่อตรวจสอบข้อมูลที่แปลงจาก JSON
    print('JSON Response: $jsonResponse');
    
    final accessToken = jsonResponse['data']['access_token']; // ดึง access_token จากข้อมูล
     
     _dataKios.token.value = accessToken ;
   
    return reqKiosdata(
      access_token: accessToken,
      kiosksId: '123', 
      customerId: '456',
    );
    
  } else {
    // พิมพ์ response status code และ body หากเกิดข้อผิดพลาด
    print('Response Status: ${response.statusCode}');
    print('Response Reason: ${response.reasonPhrase}');
    
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



 /* Future GetAdvert() async {
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
      final savePath = '${directory!.path}/$fileName';
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
  }*/

  Future<void> GetAdvert() async {

  http.Client client = http.Client();
  const url = 'http://206.189.36.97:3146/API/devices/advertise';
  final String token = _dataKios.token.value;  
  
  final uri = Uri.parse(url);
  
  // ส่งคำขอ GET พร้อมแนบ Token Authorization
  final response = await client.get(
    uri,
    headers: {
      'Authorization': 'Bearer $token',  // แนบ Token 
      'Content-Type': 'application/json',
    },
  );

  // ตรวจสอบสถานะการตอบกลับ
  if (response.statusCode == 200) {
    final body = response.body;
    final jsonResponse = jsonDecode(body);
    final results = jsonResponse['kiosksAds'] as List<dynamic>;

    final transformed = await Future.wait(results.map((ad) async {
      final kiosksId = ad['kiosksId'];
      final advertisingsId = ad['advertisingsId'];
      final advertisingName = ad['advertisingName'];
      var advertisingImage = ad['advertisingImage'];
      final advertisingImageType = ad['advertisingImageType'];
      final advertisingStartTime = ad['advertisingStartTime'];
      final advertisingEndTime = ad['advertisingEndTime'];
      /*.${advertisingImageType == 'video' ? 'mp4' : 'jpeg'}*/
      final fileName = 'advert_${advertisingsId.toString()}.${advertisingImageType == 'video' ? 'mp4' : 'jpeg'}';
      final directory = await getExternalStorageDirectory();
      final savePath = '${directory!.path}/$fileName';
      final saved = await downloadAndSaveFile(advertisingImage, fileName);
      advertisingImage = savePath;
     // print("advertisinTY : ${fileName}");
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
   ;
  } else {
    print('Request failed with status: ${response.statusCode}');
   
  }
}

  @override
  Widget build(BuildContext ConText) {
    if (_connectNetwork.isConnected.value == true) {
      loadDataAPI(ConText);
    } else {
      Get.to(NotAvailable(HeadTextError, TextError));
    }
    final sizeHeight = MediaQuery.of(ConText).size.height;
    final sizeWidth = MediaQuery.of(ConText).size.width;

    return Scaffold(
      body: Container(
        height: sizeHeight * 1,
        width: sizeWidth * 1,
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: sizeHeight *0.27,),
               Container(
                  height: sizeHeight * 0.25,
                  width: sizeWidth * 0.8,
                  child: Lottie.asset('assets/loading.json'),
                ),
              
              Text('กรุณารอสักครู่...',
                  style: Fonts(ConText, 0.07, false, Colors.black)),
              Text('กำลังตรวจสอบรายการอาหาร',
                  style: Fonts(ConText, 0.05, false, Colors.black))
            ],
          ),
        ),
      ),
    );
  }


Future<List<Category>> fetchDataFromApi() async {
  var url = 'http://206.189.36.97:3146/API/devices/meal';
  final String token = _dataKios.token.value;
  
  final uri = Uri.parse(url);
  http.Client client = http.Client();
  // ส่งคำขอ GET พร้อมแนบ Token Authorization
  final response = await client.get(
    uri,
    headers: {
      'Authorization': 'Bearer $token',  // แนบ Token ที่นี่
      'Content-Type': 'application/json',
    },
  );
  //print("checkUrl ${url}");
 if (response.statusCode == 200) {
  final jsonResponse = json.decode(response.body);
  if (jsonResponse is Map && jsonResponse.containsKey('kiosksMeal')) {
    final List<dynamic> categories = jsonResponse['kiosksMeal'];
    List<Category> updatedCategories = [];
    final directory = await getExternalStorageDirectory();

    for (var category in categories) {
      final cat = Category.fromJson(category);          
      
      // Download and update category image
      final categoryFileName = 'category_${cat.categoryName['en']}.png';
      final categorySavePath = '${directory!.path}/$categoryFileName';
      await downloadAndSaveFile(cat.categoryImage, categoryFileName);
      
      // Create updated list for this category's meals
      List<Meal> updatedMeals = [];

      for (var meal in cat.meals) {
        List<String> mealImagePaths = [];
        for (var imageUrl in meal.mealImage) {
          final mealFileName = 'meal_${meal.mealId}_${Uri.parse(imageUrl).pathSegments.last}';
          final mealSavePath = '${directory.path}/$mealFileName';
          await downloadAndSaveFile(imageUrl, mealFileName);
          mealImagePaths.add(mealSavePath);
        }

        // Create updated meal
        final updatedMeal = meal.copyWith(mealImage: mealImagePaths);
        updatedMeals.add(updatedMeal);
      }

      // Update category
      final updatedCat = cat.copyWith(
        categoryImage: categorySavePath,
        meals: updatedMeals,
      );

      updatedCategories.add(updatedCat);
    }

    _dataKios.categoryList.addAll(updatedCategories);
    return updatedCategories;
  } else {
    throw Exception('Unexpected JSON format');
  }
} else {
  print('Failed to load data');
  return [];
}

}
  Future<void> USB_VID_PID() async {
    List<Map<String, dynamic>> results =
        await FlutterUsbPrinter.getUSBDeviceList();
    printer_Test.devices.value.assignAll(results);
  }


Future<void> checkAndSetPIDVID() async {
  final directory = await getExternalStorageDirectory();
  final path = '${directory!.path}/Setting.txt';
  final file = File(path);

  if (await file.exists()) {
    final content = await file.readAsString();

    print('File Content: $content');  // ตรวจสอบข้อมูลที่อ่านได้จากไฟล์

    // Assuming PID, VID, and IP are stored in the format:
    final pidRegex = RegExp(r'PID\s*:\s*(\d+)');
    final vidRegex = RegExp(r'VID\s*:\s*(\d+)');
    final ipRegex = RegExp(r'IP\s*:\s*([\d\.]+)');

    final pidMatch = pidRegex.firstMatch(content);
    final vidMatch = vidRegex.firstMatch(content);
    final ipMatch = ipRegex.firstMatch(content);

    if (pidMatch != null && vidMatch != null && ipMatch != null) {
      final pid = int.parse(pidMatch.group(1)!);
      final vid = int.parse(vidMatch.group(1)!);
      final ip = ipMatch.group(1)!;

      // Set the values to your variables
      _dataKios.productIds.value = pid;
      _dataKios.vendorIds.value = vid;
      printer_Test.ipAddresses.value = ip;
      Connects( _dataKios.vendorIds.value,_dataKios.productIds.value );
      print('PID: $pid, VID: $vid, IP: $ip');
    } else {
      // Set values to empty if PID, VID, or IP not found
      _dataKios.productIds.value = 0;
      _dataKios.vendorIds.value = 0;
      printer_Test.ipAddresses.value = ''; // Or set to default IP if needed

      //print('PID, VID, or IP not found in the file.');
    }
  } else {
    // Set values to empty if file not found
    _dataKios.productIds.value = 0;
    _dataKios.vendorIds.value = 0;
    printer_Test.ipAddresses.value = ''; // Or set to default IP if needed

    print('File not found.');
  }
}


  void loadDataAPI(BuildContext context) async {
   // await initPlatformState();
    await reqKios();
    await GetAdvert();
  //if (_dataKios.reqKiosdata.isNotEmpty) {
   // await GetMenu();*/
      await fetchDataFromApi();
  // await GetPayment();
  //    await USB_VID_PID();
  //    checkAndSetPIDVID();
  //   if (printer_Test.devices.value.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Ads_screen(),
          ),
        );
    //  }
    }
}

/*  }

  
}*/
