import 'package:get/get.dart';

class TextBoxExampleController extends GetxController {
  var enteredText = ''.obs; // ใช้ Rx ในการตรวจจับการเปลี่ยนแปลงของข้อความ

  void updateEnteredText(String text) {
    enteredText.value = text;
  }
}
