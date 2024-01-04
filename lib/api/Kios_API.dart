import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class dataKios extends GetxController {
  RxString serialNumbers = ''.obs;
  var queue = 00.obs;
  RxString status = ''.obs;
  RxString MchOrderNo = ''.obs;
  var languageValue = 0.obs;
  var language = 'th'.obs;
  List<dynamic> categories = [];
  List<dynamic> steakList = [];
  List<dynamic> drinkList = [];
  List<dynamic> coffeeList = [];
  List<dynamic> foodList = [];
  List<dynamic> noodleList = [];
  List<dynamic> CatList = [];
  List<dynamic> mealOption = [];
  List<dynamic> advertlist = [];
  List<dynamic> reqKiosdata = [];
  List<dynamic> paymentdata = [];
  List<dynamic> channel = [];
  List<dynamic> Qrpayment = [];
  List<dynamic> mqData = [];

  var que = ''.obs;
  var branchName = ''.obs;
  var Switch_language = false;
}

void LogFile(String texts) async {
  final directory = await getExternalStorageDirectory();
  final Filename = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final Log = 'Log';

  // กำหนดไฟล์บันทึกใหม่ที่จะเขียนข้อมูล
  final savePath = '${directory.path}/$Log/$Filename.txt';
  final file = File(savePath);
  print('Filelocation : ${savePath}');
  try {
    if (await file.exists()) {
      // อ่านข้อมูลที่มีอยู่ในไฟล์และเตรียมข้อมูลใหม่
      final oldText = await file.readAsString();
      final combinedText = (oldText.isNotEmpty)
          ? oldText + "\n" + texts
          : 'Action              Time';

      // และเขียนข้อมูลใหม่ลงไฟล์ที่มีข้อมูลเก่าแล้ว
      await file.writeAsString(combinedText);
    } else {
      // หากไฟล์ยังไม่มีอยู่ในวันนี้, ให้สร้างไฟล์ใหม่และเขียนข้อมูลลงไป
      await file.create(recursive: true);
      await file.writeAsString(texts);
    }
    print('บันทึกข้อมูลเรียบร้อยแล้วในไฟล์ $Log');
  } catch (e) {
    print('เกิดข้อผิดพลาดในการบันทึกข้อมูล $Log: $e');
  }
}

class reqKiosdata {
  final String kiosksId;
  final String customerId;

  reqKiosdata({
    this.kiosksId,
    this.customerId,
  });
}

class Qrpaymentdata {
  final String qrImg;
  final String mchOrderNo;
  final String appId;
  final String status;

  Qrpaymentdata({
    this.qrImg,
    this.mchOrderNo,
    this.appId,
    this.status,
  });
}

class Paymentdata {
  final int total;
  final String customerId;
  final String paymentId;
  final String paymentName;
  final String paymentProvider;
  final int paymentStatus;
  final String appid;
  final String channelname;
  final double channelrate;
  final List<dynamic> optionData;
  final String fee_type;
  final int channelLength;
  final List<dynamic> ratesOption;
  final List<dynamic> paymentDatas;
  final List<dynamic> channel;

  Paymentdata({
    this.total,
    this.customerId,
    this.paymentId,
    this.paymentName,
    this.paymentStatus,
    this.appid,
    this.channelname,
    this.channelrate,
    this.optionData,
    this.fee_type,
    this.paymentProvider,
    this.channelLength,
    this.ratesOption,
    this.paymentDatas,
    this.channel,
  });
}

class CategoryModel {
  final String categoryId;
  final String categoryNameTH;
  final String categoryNameEN;
  final String categoryDescriptionTH;
  final String categoryDescriptionEN;
  final String categoryImage;
  final String categoryImageType;

  CategoryModel(
      {this.categoryId,
      this.categoryNameTH,
      this.categoryNameEN,
      this.categoryDescriptionTH,
      this.categoryDescriptionEN,
      this.categoryImage,
      this.categoryImageType});
}

class FoodsItem {
  final String mealId;
  final String mealNameTH;
  final String mealNameEN;
  final String mealImage;
  final String mealDescriptionTH;
  final String mealDescriptionEN;
  final num mealPrice;
  final String optioncategory;
  final String optioncategorys;
  final String mealOptionname;
  final bool multipleSelect;
  final bool forcedChoice;
  final bool mealImageType;
  final num mealOptionsLength;
  final num mealOptionprice;
  final num mealOptionsCatLength;
  final List<dynamic> mealOptions;
  final List<dynamic> mealOptionsCat;
  FoodsItem(
      {this.mealId,
      this.mealNameTH,
      this.mealNameEN,
      this.mealImage,
      this.mealDescriptionTH,
      this.mealDescriptionEN,
      this.mealPrice,
      this.multipleSelect,
      this.forcedChoice,
      this.optioncategory,
      this.optioncategorys,
      this.mealOptionname,
      this.mealOptionprice,
      this.mealOptionsLength,
      this.mealOptionsCatLength,
      this.mealOptions,
      this.mealOptionsCat,
      this.mealImageType});
}

class DrinkItem {
  final String mealId;
  final String mealNameTH;
  final String mealNameEN;
  final String mealImage;
  final String mealDescriptionTH;
  final String mealDescriptionEN;
  final double mealPrice;
  final bool multipleSelect;
  final bool forcedChoice;
  final String mealcategory;
  final String mealImageType;
  final String mealOptionname;
  final num mealOptionprice;
  final String optioncategory;
  final String optioncategorys;
  final num mealOptionsLength;
  final num mealOptionsCatLength;
  final List<dynamic> mealOptions;
  final List<dynamic> mealOptionsCat;
  DrinkItem(
      {this.mealId,
      this.mealNameTH,
      this.mealNameEN,
      this.mealImage,
      this.mealDescriptionTH,
      this.mealDescriptionEN,
      this.mealPrice,
      this.mealcategory,
      this.multipleSelect,
      this.forcedChoice,
      this.optioncategory,
      this.optioncategorys,
      this.mealOptionname,
      this.mealOptionprice,
      this.mealOptionsLength,
      this.mealOptionsCatLength,
      this.mealOptions,
      this.mealOptionsCat,
      this.mealImageType});
}

class SteakItem {
  final String mealId;
  final String mealNameTH;
  final String mealNameEN;
  final String mealImage;
  final String mealDescriptionTH;
  final String mealDescriptionEN;
  final double mealPrice;
  final String mealImageType;
  final bool multipleSelect;
  final bool forcedChoice;
  final String mealcategory;
  final String mealOptionname;
  final num mealOptionprice;
  final String optioncategory;
  final String optioncategorys;
  final num mealOptionsLength;
  final num mealOptionsCatLength;
  final List<dynamic> mealOptions;
  final List<dynamic> mealOptionsCat;
  SteakItem(
      {this.mealId,
      this.mealNameTH,
      this.mealNameEN,
      this.mealImage,
      this.mealDescriptionTH,
      this.mealDescriptionEN,
      this.mealPrice,
      this.multipleSelect,
      this.forcedChoice,
      this.mealcategory,
      this.optioncategory,
      this.optioncategorys,
      this.mealOptionname,
      this.mealOptionprice,
      this.mealOptionsLength,
      this.mealOptionsCatLength,
      this.mealOptions,
      this.mealOptionsCat,
      this.mealImageType});
}

class Advert {
  final String kiosksId;
  final String advertisingsId;
  final String advertisingName;
  final String advertisingImage;
  final String advertisingStartTime;
  final String advertisingEndTime;
  final String advertisingImageType;

  Advert({
    this.kiosksId,
    this.advertisingsId,
    this.advertisingName,
    this.advertisingImage,
    this.advertisingImageType,
    this.advertisingStartTime,
    this.advertisingEndTime,
  });
  factory Advert.fromJson(Map<String, dynamic> json) {
    return Advert(
      kiosksId: json['kiosksId'],
      advertisingsId: json['advertisingsId'],
      advertisingName: json['advertisingName'],
      advertisingImage: json['advertisingImage'],
      advertisingImageType: json['advertisingImageType'],
      advertisingStartTime: json['advertisingStartTime'],
      advertisingEndTime: json['advertisingEndTime'],
    );
  }
}

class CoffeeItem {
  final String mealId;
  final String mealNameTH;
  final String mealNameEN;
  final String mealImage;
  final String mealDescriptionTH;
  final String mealDescriptionEN;
  final double mealPrice;
  final String mealcategory;
  final bool multipleSelect;
  final bool forcedChoice;
  final String mealOptionname;
  final num mealOptionprice;
  final String optioncategory;
  final String optioncategorys;
  final num mealOptionsLength;
  final num mealOptionsCatLength;
  final String mealImageType;
  final List<dynamic> mealOptions;
  final List<dynamic> mealOptionsCat;
  CoffeeItem(
      {this.mealId,
      this.mealNameTH,
      this.mealNameEN,
      this.mealImage,
      this.multipleSelect,
      this.forcedChoice,
      this.mealDescriptionTH,
      this.mealDescriptionEN,
      this.mealPrice,
      this.mealcategory,
      this.optioncategory,
      this.optioncategorys,
      this.mealOptionname,
      this.mealOptionprice,
      this.mealOptionsLength,
      this.mealOptionsCatLength,
      this.mealOptions,
      this.mealOptionsCat,
      this.mealImageType});
}

class NoodleItem {
  final String mealId;
  final String mealNameTH;
  final String mealNameEN;
  final String mealImage;
  final String mealDescriptionTH;
  final String mealDescriptionEN;
  final double mealPrice;
  final String mealcategory;
  final bool multipleSelect;
  final bool forcedChoice;
  final String mealOptionname;
  final num mealOptionprice;
  final String mealImageType;
  final String optioncategory;
  final String optioncategorys;
  final num mealOptionsLength;
  final num mealOptionsCatLength;
  final List<dynamic> mealOptions;
  final List<dynamic> mealOptionsCat;
  NoodleItem(
      {this.mealId,
      this.mealNameTH,
      this.mealNameEN,
      this.mealImage,
      this.mealDescriptionTH,
      this.mealDescriptionEN,
      this.mealPrice,
      this.mealcategory,
      this.optioncategory,
      this.multipleSelect,
      this.forcedChoice,
      this.optioncategorys,
      this.mealOptionname,
      this.mealOptionprice,
      this.mealOptionsLength,
      this.mealOptionsCatLength,
      this.mealOptions,
      this.mealOptionsCat,
      this.mealImageType});
}
