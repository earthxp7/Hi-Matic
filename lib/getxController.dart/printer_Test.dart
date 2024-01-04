import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class pinter_test extends GetxController {
  final RxBool test_connected = false.obs;
  RxString selectedRadio = ''.obs;
  final List<String> FixPrint = ['USB', 'LAN'];
  var selectedDropdownValues = <String, Map<String, dynamic>>{}.obs;

  var ipAddresses = RxList<Map<String, dynamic>>().obs;
  var devices = RxList<Map<String, dynamic>>().obs;
  var dropdownItems = <DropdownMenuItem<Map<String, dynamic>>>[].obs;
  RxInt vid = 0.obs;
  RxInt pid = 0.obs;
}
