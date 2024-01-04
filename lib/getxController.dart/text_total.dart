import 'package:get/get.dart';

class textTotal_Contoller extends GetxController {
  var textValue = 150.obs; // ใช้ Rx ในการตรวจจับการเปลี่ยนแปลงของค่า Text

  void updateTextValue(int value) {
    textValue.value = value;
  }
}
