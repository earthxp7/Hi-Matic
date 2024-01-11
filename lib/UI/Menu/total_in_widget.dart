import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../getxController.dart/save_menu.dart';
import '../Font/ColorSet.dart';

class TotalWiget extends StatelessWidget {
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Obx(
          () => Padding(
            padding: const EdgeInsets.only(left: 150, top: 30),
            child: Row(
              children: [
                Text('ยอดชำระเงินทั้งหมด',
                    style: Fonts(context, 0.045, true, Colors.black)),
                SizedBox(
                  width: sizeWidth * 0.22,
                ),
                Text('฿ ${_foodOptionController.total_price.value}',
                    style: Fonts(context, 0.045, true, Colors.black))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
