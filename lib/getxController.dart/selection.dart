import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:screen/api/Kios_API.dart';


 class SelectionController extends GetxController {
  var selectedValues = <String, Map<String, Map<String, dynamic>>>{}.obs;
  var my_food = <String, Map<String, Map<String, dynamic>>>{}.obs;
  var food_prices = 0.obs;
  var total_prices = 0.obs;
  var totalprices = 0.obs;
  var test = false.obs;
  var amounts = <String, Map<String, int>>{}.obs;
  var details = <String, Map<String, String>>{}.obs;
  var count = 1;
  var countAll = 0.obs;
  var textEditingControllers = <String, Map<String, TextEditingController>>{}.obs;
  var allMeals = <Map<String, dynamic>>[].obs;
  var totalPrice = 0.obs;
  var forcedchoice = false.obs;
  RxString paymentsName = ''.obs;
  

void forced_choice(String category, String mealName, bool forcedChoice, String mealDetails) {
  
  selectedValues[category] ??= {};
  selectedValues[category]![mealName] ??= {
    'forcedChoice': {}, 
  };
  selectedValues[category]![mealName]!['forcedChoice'] ??= {};
  selectedValues[category]![mealName]!['forcedChoice']![mealDetails] = {
    'forced': forcedChoice,
  };

  final forcedChoiceMap = selectedValues[category]![mealName]!['forcedChoice'];

  Map<String, Map<String, bool>> typedForcedChoiceMap = {};
  if (forcedChoiceMap is Map) {
    forcedChoiceMap.forEach((key, value) {
      if (value is Map<String, bool>) {
        typedForcedChoiceMap[key] = value;
      }
    });
  }

  bool hasFalse = typedForcedChoiceMap.values.any((details) => details['forced'] == false);
 
  if (hasFalse) {
    forcedchoice.value = true;
  } else {
    forcedchoice.value = false;
  }
}
/*
void updateSingleSelection(
  String category,
  String mealName,
  String mealDetails,
  Map<String, dynamic> detailValue,
  int price,
  int mealPrice,
) {
  // คำนวณราคาอาหารทั้งหมด
  int foodPrice = calculateTotalPriceForMeal(category, mealName, mealPrice);

  // ตรวจสอบและสร้างโครงสร้างข้อมูลสำหรับการเลือก
  if (selectedValues[category] == null) {
    selectedValues[category] = {};
  }

  if (selectedValues[category]![mealName] == null) {
    selectedValues[category]![mealName] = {
      'mealPrice': mealPrice,
      'foodPrice': foodPrice,
      'mealoption': {},
    };
  }

  if (selectedValues[category]![mealName]!['mealoption'] == null) {
    selectedValues[category]![mealName]!['mealoption'] = {};
  }

  // ตรวจสอบและสร้างรายการตัวเลือกสำหรับ mealDetails
  if (selectedValues[category]![mealName]!['mealoption']![mealDetails] == null) {
    selectedValues[category]![mealName]!['mealoption']![mealDetails] = {
      'values': <Map<String, dynamic>>[],
      'prices': <int>[],
    };
  }

  // อัปเดตค่าเลือกสำหรับ mealDetails
  final selectedOptions = selectedValues[category]![mealName]!['mealoption']![mealDetails]['values'] as List<Map<String, dynamic>>;
  final selectedValuesMap = detailValue; // ค่าที่ถูกเลือก

  // ลบค่าที่มีอยู่แล้วใน 'values' และเพิ่มค่าใหม่
  final updatedOptions = selectedOptions.where((option) => option['name'] != selectedValuesMap['name']).toList();
  updatedOptions.add(selectedValuesMap);
  selectedValues[category]![mealName]!['mealoption']![mealDetails]['values'] = updatedOptions;

  // รีเฟรช selectedValues
  selectedValues.refresh();
}*/
/*void updateSingleSelection(
  String category,
  String mealName,
  Map<String, dynamic> mealDetails, // mealDetails รับข้อมูลหลายภาษา
  Map<String, dynamic> detailValue,
  int price,
  int mealPrice,
) {
  // คำนวณราคาอาหารทั้งหมด
  int foodPrice = calculateTotalPriceForMeal(category, mealName, mealPrice,mealDetails);

  // ตรวจสอบและสร้างโครงสร้างข้อมูลสำหรับการเลือก
  if (selectedValues[category] == null) {
    selectedValues[category] = {};
  }

  if (selectedValues[category]![mealName] == null) {
    selectedValues[category]![mealName] = {
      'mealPrice': mealPrice,
      'foodPrice': foodPrice,
      'mealoption': {},
    };
  }

  if (selectedValues[category]![mealName]!['mealoption'] == null) {
    selectedValues[category]![mealName]!['mealoption'] = {};
  }

  // ตรวจสอบและสร้างรายการตัวเลือกสำหรับ mealDetails ในทุกภาษา
  mealDetails.forEach((language, details) {
    if (selectedValues[category]![mealName]!['mealoption']![details] == null) {
      selectedValues[category]![mealName]!['mealoption']![details] = {
        'values': <Map<String, dynamic>>[],
        'prices': <int>[],
      };
    }

    // อัปเดตค่าเลือกสำหรับ mealDetails
    final mealOption = selectedValues[category]![mealName]!['mealoption']![details];
    final valuesList = mealOption['values'] as List<Map<String, dynamic>>? ?? [];
    final pricesList = mealOption['prices'] as List<int>? ?? [];

    final selectedValuesMap = Map<String, dynamic>.from(detailValue);

    // ลบค่าที่มีอยู่แล้วใน 'values' และเพิ่มค่าใหม่
    final updatedOptions = valuesList.where((option) => option['name'] != selectedValuesMap['name']).toList();
    updatedOptions.add(selectedValuesMap);
    mealOption['values'] = updatedOptions;

    pricesList.clear(); // ลบราคาทั้งหมด
    pricesList.add(price); // เพิ่มราคาใหม่

    // อัปเดตราคาใน selectedValues
    mealOption['prices'] = pricesList;

  
  });
 
  selectedValues.refresh();
}*/
void updateSingleSelection(
  String category,
  String mealName,
  Map<String, dynamic> mealDetails,
  Map<String, dynamic> detailValue,
  int price,
  int mealPrice,
) {
  int foodPrice = calculateTotalPriceForMeal(category, mealName, mealPrice, mealDetails);

  if (selectedValues[category] == null) {
    selectedValues[category] = {};
  }

  if (selectedValues[category]![mealName] == null) {
    selectedValues[category]![mealName] = {
      'mealPrice': mealPrice,
      'foodPrice': foodPrice,
      'mealoption': {},
    };
  }

  if (selectedValues[category]![mealName]!['mealoption'] == null) {
    selectedValues[category]![mealName]!['mealoption'] = {};
  }

  mealDetails.forEach((language, details) {
    if (selectedValues[category]![mealName]!['mealoption']![details] == null) {
      selectedValues[category]![mealName]!['mealoption']![details] = {
        'values': <Map<String, dynamic>>[],
        'prices': <int>[],
      };
    }

    final mealOption = selectedValues[category]![mealName]!['mealoption']![details];
    final valuesList = mealOption['values'] as List<Map<String, dynamic>>? ?? [];
    final pricesList = mealOption['prices'] as List<int>? ?? [];

    final selectedValuesMap = Map<String, dynamic>.from(detailValue);
    final updatedOptions = valuesList.where((option) => option['name'] != selectedValuesMap['name']).toList();
    updatedOptions.add(selectedValuesMap);
    mealOption['values'] = updatedOptions;

    pricesList.clear();
    pricesList.add(price);
    mealOption['prices'] = pricesList;
   // selectedValues.refresh();
  });
  selectedValues.refresh();
}



/*void updateSingleSelection(
  String category,
  String mealName,
  Map<String, dynamic> mealDetails, // mealDetails เก็บข้อมูลหลายภาษา
  Map<String, dynamic> detailValue,
  int price,
  int mealPrice,
) {
  // คำนวณราคาอาหารทั้งหมด
  int foodPrice = calculateTotalPriceForMeal(category, mealName, mealPrice);

  // ตรวจสอบและสร้างโครงสร้างข้อมูลสำหรับการเลือก
  if (selectedValues[category] == null) {
    selectedValues[category] = {};
  }

  if (selectedValues[category]![mealName] == null) {
    selectedValues[category]![mealName] = {
      'mealPrice': mealPrice,
      'foodPrice': foodPrice,
      'mealoption': {},
      'prices': [], // เก็บราคาทั้งหมดแยกต่างหาก
    };
  }

  if (selectedValues[category]![mealName]!['mealoption'] == null) {
    selectedValues[category]![mealName]!['mealoption'] = {};
  }

  // ตรวจสอบและสร้างรายการตัวเลือกสำหรับ mealDetails ในทุกภาษา
  mealDetails.forEach((language, details) {
    if (selectedValues[category]![mealName]!['mealoption']![details] == null) {
      selectedValues[category]![mealName]!['mealoption']![details] = {
        'values': <Map<String, dynamic>>[],
      };
    }

    // อัปเดตค่าเลือกสำหรับ mealDetails
    final selectedOptions = selectedValues[category]![mealName]!['mealoption']![details]['values'] as List<Map<String, dynamic>>;
    final selectedValuesMap = detailValue; // ค่าที่ถูกเลือก

    // ลบค่าที่มีอยู่แล้วใน 'values' และเพิ่มค่าใหม่
    final updatedOptions = selectedOptions.where((option) => option['name'] != selectedValuesMap['name']).toList();
    updatedOptions.add(selectedValuesMap);
    selectedValues[category]![mealName]!['mealoption']![details]['values'] = updatedOptions;
  });

  // ตรวจสอบว่ามีรายการราคาใน 'prices' หรือไม่, ถ้าไม่มีให้สร้างใหม่
  final pricesList = selectedValues[category]![mealName]!['prices'] as List<int>? ?? [];

  // ลบราคาที่มีอยู่แล้ว (Single Selection ลบก่อนเพิ่มใหม่)
  pricesList.clear();

  // เพิ่มราคาที่เลือกเข้าไป
  pricesList.add(price);

  // อัปเดตราคาใน selectedValues
  selectedValues[category]![mealName]!['prices'] = pricesList;
  print('Radio ${selectedValues[category]![mealName]!['prices']}');
  // รีเฟรช selectedValues
  selectedValues.refresh();
}*/




void updateMultipleSelection(
  String category,
  String mealName,
  Map<String, dynamic> mealDetails,
  Map<String, dynamic> detailValue,
  bool isSelected,
  int price,
  int mealPrice,
) {
  int foodPrice = calculateTotalPriceForMeal(category, mealName, mealPrice,mealDetails);

  if (selectedValues[category] == null) {
    selectedValues[category] = {};
  }

  if (selectedValues[category]![mealName] == null) {
    selectedValues[category]![mealName] = {
      'mealPrice': mealPrice,
      'foodPrice': foodPrice,
      'mealoption': {},
    };
  }

  if (selectedValues[category]![mealName]!['mealoption'] == null) {
    selectedValues[category]![mealName]!['mealoption'] = {};
  }

  mealDetails.forEach((language, details) {
    if (selectedValues[category]![mealName]!['mealoption']![details] == null) {
      selectedValues[category]![mealName]!['mealoption']![details] = {
        'values': <Map<String, dynamic>>[],
        'prices': <int>[],
      };
    }
    
    final mealOption = selectedValues[category]![mealName]!['mealoption']![details];
    final valuesList = mealOption['values'] as List<Map<String, dynamic>>? ?? [];
    final pricesList = mealOption['prices'] as List<int>? ?? [];
    
    final detailValueMap = Map<String, dynamic>.from(detailValue);

    if (isSelected) {
        valuesList.add(detailValueMap);
          pricesList.add(price);       
    } else {
      final index = valuesList.indexWhere((map) => mapEquals(map, detailValueMap));
      if (index != -1) {
        valuesList.removeAt(index);
        pricesList.removeAt(index);
      }
      if (valuesList.isEmpty) {
        selectedValues[category]![mealName]!['mealoption']!.remove(details);
      }
    }
  });

  if (selectedValues[category]![mealName]!['mealoption']!.isEmpty) {
    selectedValues[category]!.remove(mealName);
  }

  if (selectedValues[category]!.isEmpty) {
    selectedValues.remove(category);
  }
  selectedValues.refresh();
}


/*int calculateTotalPriceForMeal(String category, String mealName, int basePrice) {
  int totalPrice = basePrice;

  if (selectedValues.containsKey(category) &&
      selectedValues[category] != null &&
      selectedValues[category]!.containsKey(mealName)) {
    
    // ดึงราคาจาก 'prices' แยกที่เก็บไว้ใน 'mealName'
    List<int>? pricesList = selectedValues[category]![mealName]!['prices'] as List<int>?;

    if (pricesList == null) {
      // ตั้งค่า pricesList เป็นลิสต์ว่างถ้ามันเป็น null
      pricesList = [];
      selectedValues[category]![mealName]!['prices'] = pricesList;
    }

    print('ลิสต์ราคา : ${pricesList}');
    if (pricesList.isNotEmpty) {
      // รวมราคาจาก 'prices'
      pricesList.forEach((price) {
        totalPrice += price;
      });
    }
  }
  
  return totalPrice * foodAmount(category, mealName);
}*/

/*int calculateTotalPriceForMeal(String category, String mealName, int basePrice ,Map<String, dynamic> MealDetail) {
 final dataKios _dataKios = Get.put(dataKios()); 
 int totalPrice = basePrice;

  if (selectedValues.containsKey(category) &&
      selectedValues[category] != null &&
      selectedValues[category]!.containsKey(mealName)) {
      var mealDetails = selectedValues[category]![mealName]!['mealoption'];
      
    if (mealDetails is Map) {
      Map<String, dynamic> mealDetailsMap = Map<String, dynamic>.from(mealDetails);
      final currentLanguage = _dataKios.language.value == 'en'? MealDetail['en'] 
                             : _dataKios.language.value == 'zh'? MealDetail['cn']
                             : MealDetail['th']; 
      
      print('mealDetailsMap : ${mealDetailsMap}');
      mealDetailsMap.forEach((key , valMap) {
        // print('key : ${key} mealDetailsMap : ${mealDetailsMap}');
        if (key == currentLanguage) {
        if (valMap is Map<String, dynamic>) {
          if (valMap.containsKey('prices')) {
            int price = (valMap['prices'] as int?) ?? 0;
            totalPrice += price;
            print('Radio');
          }  else if (valMap.containsKey('values') && valMap.containsKey('prices')) {
            List<dynamic> prices = valMap['prices'] as List<dynamic>;
            for (var price in prices) {
              int intPrice = (price as int?) ?? 0;
              //if (addedPrices.add(intPrice)) { // add returns false if price was already in the set
                totalPrice += intPrice;
          //    }
        }
       // print('totalPrice : ${totalPrice }');
     
      }}}});
    } 
  }
  return totalPrice * foodAmount(category, mealName);
}*/

/*int calculateTotalPriceForMeal(String category, String mealName, int basePrice) {
  int totalPrice = basePrice;

  if (selectedValues.containsKey(category) &&
      selectedValues[category] != null &&
      selectedValues[category]!.containsKey(mealName)) {
      var mealDetails = selectedValues[category]![mealName]!['mealoption'];

    if (mealDetails is Map) {
      Map<String, dynamic> mealDetailsMap = Map<String, dynamic>.from(mealDetails);
      //print('mealDetailsMap: $mealDetailsMap');
      print('ความยาว : ${ mealDetailsMap}');
      // Set to track added prices
      Set<int> addedPrices = {};

      mealDetailsMap.forEach((detailName, valMap) {
        if (valMap is Map<String, dynamic>) {
          if (valMap.containsKey('price')) {
            int price = (valMap['price'] as int?) ?? 0;
           // if (addedPrices.add(price)) { // add returns false if price was already in the set
              totalPrice += price;
          //  }
          } else if (valMap.containsKey('values') && valMap.containsKey('prices')) {
            List<dynamic> prices = valMap['prices'] as List<dynamic>;
            for (var price in prices) {
              int intPrice = (price as int?) ?? 0;
              //if (addedPrices.add(intPrice)) { // add returns false if price was already in the set
                totalPrice += intPrice;
          //    }
            }
          }
        }
      });
    }
  }

  return totalPrice * foodAmount(category, mealName);
}*/
int calculateTotalPriceForMeal(String category, String mealName, int basePrice,Map<String, dynamic> MealDetail,) {
 int totalPrice = basePrice;
   final dataKios _dataKios = Get.put(dataKios());    
  if (selectedValues.containsKey(category) &&
      selectedValues[category] != null &&
      selectedValues[category]!.containsKey(mealName)) {
      var mealDetails = selectedValues[category]![mealName]!['mealoption'];
     
    if (mealDetails is Map) {
      Map<String, dynamic> mealDetailsMap = Map<String, dynamic>.from(mealDetails);
      final currentLanguage = _dataKios.language.value == 'en'? MealDetail['en'] 
                             : _dataKios.language.value == 'zh'? MealDetail['cn']
                             : MealDetail['th']; 

      mealDetailsMap.forEach((key , valMap) {
       /// print('valMap : ${key == currentLanguage}');
       if (key == currentLanguage) {
      //  print('valMap : ${key == currentLanguage}');
       if (valMap is Map<String, dynamic>)
         {
          if (valMap.containsKey('prices')) {
            int price = (valMap['prices'] as int?) ?? 0;
            totalPrice += price;
          } 
          else if (valMap.containsKey('values') && valMap.containsKey('prices')) {
            List<dynamic> prices = valMap['prices'] as List<dynamic>;
            prices.forEach((price) {
              totalPrice += (price as int?) ?? 0;
            }
         // }
            );
        print('ราคา : ${totalPrice}');
      }}}});
    } 
  }
  
  return totalPrice * foodAmount(category, mealName);
}



void updateDetails(String category, String mealName, String text) {
  if (!selectedValues.containsKey(category)) {
    selectedValues[category] = {};
  }
  if (!selectedValues[category]!.containsKey(mealName)) {
    selectedValues[category]![mealName] = {};
  }
  selectedValues[category]![mealName]!['details'] = text;
  selectedValues.refresh();
}

  TextEditingController getTextEditingController(String category, String mealName) {
    if (!textEditingControllers.containsKey(category)) {
      textEditingControllers[category] = {};
    }
    if (!textEditingControllers[category]!.containsKey(mealName)) {
      textEditingControllers[category]![mealName] = TextEditingController();
    }
    return textEditingControllers[category]![mealName]!;
  }


int foodAmount(String category, String mealName) {
  if (selectedValues[category] == null) {
    selectedValues[category] = {};
  }
  if (selectedValues[category]![mealName] == null) {
    selectedValues[category]![mealName] = {'amount': 1};
  } else if (selectedValues[category]![mealName]!['amount'] == null) {
    selectedValues[category]![mealName]!['amount'] = 1;
  }
  return selectedValues[category]![mealName]!['amount'];
}

void updateFoodAmount(String category, String mealName, int newAmount) {
  if (selectedValues[category] == null) {
    selectedValues[category] = {};
  }
  if (selectedValues[category]![mealName] == null) {
    selectedValues[category]![mealName] = {'amount': newAmount};
  } else {
    selectedValues[category]![mealName]!['amount'] = newAmount;
  }
  selectedValues.refresh();
}

void addFood(String category, String mealName) {
  if (selectedValues[category] == null) {
    selectedValues[category] = {};
  }
  if (selectedValues[category]![mealName] == null) {
    selectedValues[category]![mealName] = {'amount': 1};
  } else if (selectedValues[category]![mealName]!['amount'] == null) {
    selectedValues[category]![mealName]!['amount'] = 1;
  } else {
    selectedValues[category]![mealName]!['amount'] = selectedValues[category]![mealName]!['amount'] + 1;
  }
  selectedValues.refresh();
}


void reduceFood(String category, String mealName) {
  if (selectedValues[category] == null) {
    selectedValues[category] = {};
  }
  if (selectedValues[category]![mealName] == null) {
    selectedValues[category]![mealName] = {'amount': 1};
  } else if (selectedValues[category]![mealName]!['amount'] == null) {
    selectedValues[category]![mealName]!['amount'] = 1;
  } else {
    selectedValues[category]![mealName]!['amount'] = selectedValues[category]![mealName]!['amount'] - 1;
  }
  selectedValues.refresh();
}

  
int calculateTotalPriceForAll( String category ,String mealName ,int mealPrice ,String image  ,String mealNameTH, String mealNameEN, String mealNameCN ,String mealId, String mealOptionsString ,int indexs,Map<String, dynamic> mealDetails,){
  int foodPrice = calculateTotalPriceForMeal(category, mealName, mealPrice,mealDetails);
  int amount = foodAmount( category, mealName);
  total_prices.value += foodPrice ;
  if (!selectedValues.containsKey(category)) {
  selectedValues[category] = {};
  }
    if (!selectedValues[category]!.containsKey(mealName)) {
    selectedValues[category]![mealName] = {
      'category':category ,
      'mealId' :mealId,
      'mealImage':image,
      'mealPrice':mealPrice,
      'foodPrice':foodPrice,
      'amount':amount,
      'mealNameTH' :mealNameTH,
      'mealNameEN' :mealNameEN,
      'mealNameCN' :mealNameCN,
      'mealindexs':indexs
    };
  } else {
    selectedValues[category]![mealName]!['category'] = category;
    selectedValues[category]![mealName]!['mealId'] = mealId;
    selectedValues[category]![mealName]!['foodPrice'] = foodPrice;
    selectedValues[category]![mealName]!['mealPrice'] = mealPrice;
    selectedValues[category]![mealName]!['mealImage'] = image;
    selectedValues[category]![mealName]!['amount'] = amount;
    selectedValues[category]![mealName]!['mealNameTH'] = mealNameTH;
    selectedValues[category]![mealName]!['mealNameEN'] = mealNameEN;
    selectedValues[category]![mealName]!['mealNameCN'] = mealNameCN;
    selectedValues[category]![mealName]!['mealindexs'] = indexs;
  }
   return total_prices.value;
}

Future<void> updateFood (String category, String mealName, bool foodOrder) async {
  if (selectedValues[category] == null) {
    selectedValues[category] = {};
  }
  if (selectedValues[category]![mealName] == null) {
    selectedValues[category]![mealName] = {'Choose': foodOrder};
  } else {
    selectedValues[category]![mealName]!['Choose'] = foodOrder;
  }
  selectedValues.refresh();
}

 num calculateTotalWithVAT() {
    final totalBeforeVAT = totalPrice.value;
    final vatRate = 0.07; // 7% VAT
    final vatAmount = totalBeforeVAT * vatRate;

    return int.parse(vatAmount.toStringAsFixed(0));
  }

  num NetPrice() {
    final totalBeforeVAT = totalPrice.value;
    final VatRate = calculateTotalWithVAT();
    final Vat7 = totalBeforeVAT + VatRate;
    return Vat7;
  }

/*List<Map<String, dynamic>> getAllFoods() {
  final selectedMeals = <Map<String, dynamic>>[]; 
  selectedValues.forEach((category, meals) {
    meals.forEach((mealName, mealDetails) {
      if (mealDetails['Choose'] == true) { 

        // Extract meal options
        final mealOptions = mealDetails['mealoption'] ?? {};
        final optionsList = <Map<String, dynamic>>[];
        mealOptions.forEach((optionName, optionDetails) {    
          if (optionDetails != null) {
            if (optionDetails.containsKey('values') && optionDetails.containsKey('prices')) {
             
              // Handling Checkbox or multi-choice options
              final values = optionDetails['values'] as List<String>? ?? [];
              final prices = optionDetails['prices'] as List<int>? ?? [];
              print('optionDetails${optionDetails}');
              for (int i = 0; i < values.length; i++) {
                optionsList.add({
                  'optionName': optionName,
                  'value': values[i],
                  'price': prices.isNotEmpty ? prices[i] : 0.0,
                });
              }
            } else {          
              optionsList.add({
                'optionName': optionName,
                'value': optionDetails['value'] ?? '',
                'price': int.tryParse(optionDetails['price']?.toString() ?? '0') ?? 0,
              });
            }
          }
        });
        selectedMeals.add({
          'category': mealDetails['category'],
          'mealId': mealDetails['mealId'],
          'mealNameTH': mealDetails['mealNameTH'] ?? '', 
          'mealNameEN': mealDetails['mealNameEN'] ?? '', 
          'mealNameCN': mealDetails['mealNameCN'] ?? '', 
          'mealImage': mealDetails['mealImage'] ?? '', 
          'mealindexs':mealDetails['mealindexs'] ?? 0, 
          'mealPrice': int.tryParse(mealDetails['mealPrice']?.toString() ?? '0') ?? 0, 
          'foodPrice': int.tryParse(mealDetails['foodPrice']?.toString() ?? '0') ?? 0, 
          'choose': mealDetails['Choose'] ?? false, 
          'amount': mealDetails['amount'] ?? 0,
          'note':  mealDetails['details']?? '',
          'mealoption': optionsList,       
        });
        //print('mealindexs : ${mealDetails['mealindexs']}');
      }
    });
  }); 
  return selectedMeals;
}*/

List<Map<String, dynamic>> getAllFoods() {
  final selectedMeals = <Map<String, dynamic>>[]; 
  selectedValues.forEach((category, meals) {
    meals.forEach((mealName, mealDetails) {
      if (mealDetails['Choose'] == true) { 

        // Extract meal options
        final mealOptions = mealDetails['mealoption'] ?? {};
        final optionsList = <Map<String, dynamic>>[];
        mealOptions.forEach((optionName, optionDetails) {    
          if (optionDetails != null) {
            if (optionDetails.containsKey('values') && optionDetails.containsKey('prices')) {
             
              // Handle different types of values
              final values = optionDetails['values'];
              final prices = optionDetails['prices'] as List<int>? ?? [];
              print('optionDetails${optionDetails}');
              
              if (values is List<String>) {
                // Handle case where values is List<String>
                for (int i = 0; i < values.length; i++) {
                  optionsList.add({
                    'optionName': optionName,
                    'value': values[i],
                    'price': prices.isNotEmpty ? prices[i] : 0.0,
                  });
                }
              } else if (values is List<Map<String, dynamic>>) {
                // Handle case where values is List<Map<String, dynamic>>
                for (int i = 0; i < values.length; i++) {
                  optionsList.add({
                    'optionName': optionName,
                    'value': values[i],
                    'price': prices.isNotEmpty ? prices[i] : 0.0,
                  });
                }
              }
            } else {          
              optionsList.add({
                'optionName': optionName,
                'value': optionDetails['value'] ?? '',
                'price': int.tryParse(optionDetails['price']?.toString() ?? '0') ?? 0,
              });
            }
          }
        });
        selectedMeals.add({
          'category': mealDetails['category'],
          'mealId': mealDetails['mealId'],
          'mealNameTH': mealDetails['mealNameTH'] ?? '', 
          'mealNameEN': mealDetails['mealNameEN'] ?? '', 
          'mealNameCN': mealDetails['mealNameCN'] ?? '', 
          'mealImage': mealDetails['mealImage'] ?? '', 
          'mealindexs':mealDetails['mealindexs'] ?? 0, 
          'mealPrice': int.tryParse(mealDetails['mealPrice']?.toString() ?? '0') ?? 0, 
          'foodPrice': int.tryParse(mealDetails['foodPrice']?.toString() ?? '0') ?? 0, 
          'choose': mealDetails['Choose'] ?? false, 
          'amount': mealDetails['amount'] ?? 0,
          'note':  mealDetails['details']?? '',
          'mealoption': optionsList,       
        });
      }
    });
  }); 
  return selectedMeals;
}


void getTotalAll(Map<String, dynamic> MealDetail) {
  final dataKios _dataKios = Get.put(dataKios());
  final currentLanguage = _dataKios.language.value == 'en'? MealDetail['en'] 
                          : _dataKios.language.value == 'zh'? MealDetail['cn']
                          : MealDetail['th']; 
  totalPrice.value = 0;
  selectedValues.forEach((category, meals) {
    meals.forEach((mealName, mealDetails) {
      if ( mealDetails['Choose'] == true) {
        final mealPrice = int.tryParse(mealDetails['foodPrice']?.toString() ?? '0') ?? 0;
        totalPrice.value += mealPrice; 
      }
    });
  });
  print("ราคา : ${totalPrice.value}");
}



void getCountAll(Map<String, dynamic> MealDetail) {
final dataKios _dataKios = Get.put(dataKios());
final currentLanguage = _dataKios.language.value == 'en'? MealDetail['en'] 
  : _dataKios.language.value == 'zh'? MealDetail['cn']
  : MealDetail['th']; 
countAll.value = 0;
  selectedValues.forEach((category, meals) {
    meals.forEach((mealName, mealDetails) {
      if (mealDetails['Choose'] == true) {
        final int mealCount = (mealDetails['amount'] ?? 0).toInt();
        countAll.value += mealCount;
      }
    });
  }); 
}


void updateAmount(String category, String mealName, int newAmount ,int newPrice,Map<String, dynamic> MealDetail) {


  if (selectedValues.containsKey(category) &&
      selectedValues[category]!.containsKey(mealName)) {
    var mealDetails = selectedValues[category]![mealName];
    if (mealDetails!['Choose'] == true) {
      mealDetails['amount'] = newAmount;
      mealDetails['foodPrice'] = newPrice;   
      update(); 
    }  
     getCountAll(MealDetail);
     getTotalAll(MealDetail);
  }
}

void deleteMealByCondition(String condition) {
  var indexToDelete = allMeals.indexWhere((meal) => meal['mealNameEN'] == condition);
  if (indexToDelete != -1) {
    allMeals.removeAt(indexToDelete);
    allMeals.refresh();
  } else {
    print('Item not found');
  }
}

void deleteMealByConditions(String condition) {
  // พิมพ์ค่า selectedValues ทั้งหมดออกมาดู
  selectedValues.forEach((category, meals) {
    meals.forEach((mealName, mealDetails) {   
    });
  });
  selectedValues.forEach((category, meals) {
    if (meals.containsKey(condition)) {
      meals.remove(condition);
    }
  });
  // พิมพ์ค่า selectedValues หลังจากลบ
  selectedValues.forEach((category, meals) {
    meals.forEach((mealName, mealDetails) {
    });
  });
}





 }