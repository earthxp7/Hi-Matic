import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
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
  var printer_on = false.obs;
  RxBool connected = false.obs;
  RxInt check_default = 0.obs;
  RxInt vendorIds = 0.obs;
  RxInt productIds = 0.obs;
  var mealNames = <Map<String, String>>[].obs;
  List<dynamic> categories = [];
  List<dynamic> steakList = [];
  List<dynamic> drinkList = [];
  List<dynamic> coffeeList = [];
  List<dynamic> foodList = [];
  List<dynamic> noodleList = [];
  List<dynamic> mealOption = [];
  List<dynamic> advertlist = [];
  List<dynamic> reqKiosdata = [];
  List<dynamic> paymentdata = [];
  List<dynamic> channel = [];
  List<dynamic> Qrpayment = [];
  List<dynamic> mqData = [];
  List<Category> categoryList = []; 
  List<Meal> updatedMeals = [];
  var que = ''.obs;
  var branchName = ''.obs;
  var Switch_language = false;
  var token =''.obs;
  
}
Future<List<Map<String, String>>> getMealNamesByCategoryName(String categoryName) async {
  final dataKios _dataKios = Get.put(dataKios());
  _dataKios.mealNames.clear();
  for (var category in _dataKios.categoryList) {
    if (category.categoryName["en"] == categoryName) {
      for (var meal in category.meals) {
        // ประกาศตัวแปรเพื่อเก็บข้อมูล mealOptions
        List<Map<dynamic, dynamic>> mealOptionsList = [];
        for (var option in meal.mealOption) {
          mealOptionsList.add({
            'mealDetails': option.mealDetails,
            'multipleSelect': option.multipleSelect,
            'forcedChoice': option.forcedChoice,
            'option': option.option.map((opt) => {
              'name': opt.name,
              'price': opt.price,
            }).toList(),
          });
        }
        
        _dataKios.mealNames.add({
          'id': meal.mealId.toString(),
          'name_en': meal.mealName['en'] ?? '',
          'name_th': meal.mealName['th'] ?? '',
          'name_cn': meal.mealName['cn'] ?? '',
          'description_en': meal.mealDescription['en'] ?? '',
          'description_th': meal.mealDescription['th'] ?? '',
          'description_cn': meal.mealDescription['cn'] ?? '',
          'price': meal.mealPrice.toString(),
          'image': meal.mealImage.isNotEmpty ? meal.mealImage[0] : '', // เลือกค่าหมายเลขแรกในรายการ mealImage
          'mealOptions': jsonEncode(mealOptionsList),  // ใช้ jsonEncode แทน toString
        });
      }
      break;
    }
  }
  return _dataKios.mealNames;
}

void LogFile(String texts) async {
  final directory = await getExternalStorageDirectory();
  final Filename = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final Log = 'Log';

  // กำหนดไฟล์บันทึกใหม่ที่จะเขียนข้อมูล
  final savePath = '${directory!.path}/$Log/$Filename.txt';
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
  final String access_token;
  final String kiosksId;
  final String customerId;

  reqKiosdata({
    required this.access_token,
    required this.kiosksId,
    required this.customerId,
  });
}

class Qrpaymentdata {
  final String qrImg;
  final String mchOrderNo;
  final String appId;
  final String status;

  Qrpaymentdata({
    required this.qrImg,
    required this.mchOrderNo,
    required this.appId,
    required this.status,
  });
}

class Paymentdata {
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

  Paymentdata({
    required this.paymentId,
    required this.paymentName,
    required this.paymentStatus,
    required this.appid,
    required this.channelname,
    required this.channelrate,
    required this.optionData,
    required this.fee_type,
    required this.paymentProvider,
    required this.channelLength,
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
      {required this.categoryId,
      required this.categoryNameTH,
      required this.categoryNameEN,
      required this.categoryDescriptionTH,
      required this.categoryDescriptionEN,
      required this.categoryImage,
      required this.categoryImageType});
}

class Advert {
  final int kiosksId;
  final int advertisingsId;
  final String advertisingName;
  final String advertisingImage;
  final String advertisingStartTime;
  final String advertisingEndTime;
  final String advertisingImageType;

  Advert({
    required this.kiosksId,
    required this.advertisingsId,
    required this.advertisingName,
    required this.advertisingImage,
    required this.advertisingImageType,
    required this.advertisingStartTime,
    required this.advertisingEndTime,
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

Future<void> testTimeAd() async {
  DateTime now = DateTime.now();
  final dataKios _dataKios = Get.put(dataKios());

  // List เพื่อเก็บโฆษณาที่กำลังแสดงอยู่
  List<Advert> activeAds = [];

  for (var ad in _dataKios.advertlist) {
    DateTime startTime = DateTime.parse(ad.advertisingStartTime);
    DateTime endTime = DateTime.parse(ad.advertisingEndTime);

    if (now.isAfter(startTime) && now.isBefore(endTime)) {
      print("โฆษณา '${ad.advertisingName}' กำลังแสดงอยู่");
      
      // เพิ่มโฆษณาที่กำลังแสดงอยู่ลงใน List
      activeAds.add(ad);
    } else {
      print("โฆษณา '${ad.advertisingName}' ไม่ได้แสดงอยู่ในขณะนี้");
    }
  }

  // ตัวอย่างการใช้งาน activeAds
  print("จำนวนโฆษณาที่กำลังแสดงอยู่: ${activeAds.length}");
  for (var ad in activeAds) {
    print("ชื่อโฆษณา: ${ad.advertisingName}");
  }
}

class reqKiosdatas {
  final String kiosksId;
  final String customerId;

  reqKiosdatas({
    required this.kiosksId,
    required this.customerId,
  });
}

class Category {
  final int categoryId;
  final Map<String, String> categoryName;
  final Map<String, String> categoryDescription;
  String categoryImage; 
  // final String categoryImageType;
  // final int categoryImageSize;
  final List<Meal> meals;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.categoryDescription,
    required this.categoryImage,
    // required this.categoryImageType,
    // required this.categoryImageSize,
    required this.meals,
  });

  Category copyWith({
    int? categoryId,
    Map<String, String>? categoryName,
    Map<String, String>? categoryDescription,
    String? categoryImage,
    // String? categoryImageType,
    // int? categoryImageSize,
    List<Meal>? meals,
  }) {
    return Category(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryDescription: categoryDescription ?? this.categoryDescription,
      categoryImage: categoryImage ?? this.categoryImage,
      // categoryImageType: categoryImageType ?? this.categoryImageType,
      // categoryImageSize: categoryImageSize ?? this.categoryImageSize,
      meals: meals ?? this.meals,
    );
  }

    factory Category.fromJson(Map<String, dynamic> json) {
    var mealList = json['meals'] as List;
    List<Meal> mealObjects = mealList.map((i) => Meal.fromJson(i)).toList();

    return Category(
      categoryId: json['categoryId'],
      categoryName: Map<String, String>.from(json['categoryName']),
      categoryDescription: Map<String, String>.from(json['categoryDescription']),
      categoryImage: json['categoryImage'],
    //  categoryImageType: json['categoryImageType'],
    //  categoryImageSize: json['categoryImageSize'],
      meals: mealObjects,
    );
  }
}

class Meal {
  final int mealId;
  final Map<String, String> mealName;
  final Map<String, String> mealDescription;
  final int mealPrice;
  final List<String> mealImage;
 // final String mealImageType;
  final int mealImageSize;
  final List<MealOption> mealOption;

  Meal({
    required this.mealId,
    required this.mealName,
    required this.mealDescription,
    required this.mealPrice,
    required this.mealImage,
   // required this.mealImageType,
    required this.mealImageSize,
    required this.mealOption,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      mealId: json['mealId'] ?? '',
      mealName: Map<String, String>.from(json['mealName'] ?? {}),
      mealDescription: Map<String, String>.from(json['mealDescription'] ?? {}),
      mealPrice: (json['mealPrice'] ?? 0),
      mealImage: (json['mealImage'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(), // Convert list to List<String>
     // mealImageType: json['mealImageType'] ?? [],
      mealImageSize: json['mealImageSize'] ?? 0,
      mealOption: (json['mealOption'] as List<dynamic>? ?? [])
          .map((i) => MealOption.fromJson(i))
          .toList(),
    );
  }

  Meal copyWith({
    int? mealId,
    Map<String, String>? mealName,
    Map<String, String>? mealDescription,
    int? mealPrice,
    List<String>? mealImage,
   // String? mealImageType,
    int? mealImageSize,
    List<MealOption>? mealOption,
  }) {
    return Meal(
      mealId: mealId ?? this.mealId,
      mealName: mealName ?? this.mealName,
      mealDescription: mealDescription ?? this.mealDescription,
      mealPrice: mealPrice ?? this.mealPrice,
      mealImage: mealImage ?? this.mealImage,
    //  mealImageType: mealImageType ?? this.mealImageType,
      mealImageSize: mealImageSize ?? this.mealImageSize,
      mealOption: mealOption ?? this.mealOption,
    );
  }
}


class MealOption {
  final Map<String, String> mealDetails;
  final bool multipleSelect;
  final bool forcedChoice;
  final List<Option> option;

  MealOption({
    required this.mealDetails,
    required this.multipleSelect,
    required this.forcedChoice,
    required this.option,
  });

  factory MealOption.fromJson(Map<String, dynamic> json) {
    return MealOption(
      mealDetails: Map<String, String>.from(json['mealDetails'] ?? {}),  
      multipleSelect: json['multipleSelect'] ?? false,
      forcedChoice: json['forcedChoice'] ?? false,
      option: (json['option'] as List<dynamic>? ?? []).map((i) => Option.fromJson(i)).toList(),
    );
  }
}

class Option {
  final Map<String, String> name;
  final int price;

  Option({
    required this.name,
    required this.price,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      name: Map<String, String>.from(json['name'] ?? {}),
      price: json['price'] ?? 0,
    );
  }
}



