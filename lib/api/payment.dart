import 'dart:ui';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Payments {
  static List<Map<String, dynamic>> PayMentItem(
    BuildContext context,
  ) {
    return [
      {
        'image': 'assets/Payment/promptpay.png',
        'name': AppLocalizations.of(context)!.promptPay,
        'color': Color.fromRGBO(21, 59, 108, 1),
      },
      {
        'image': 'assets/Payment/truemoney.png',
        'name': AppLocalizations.of(context)!.true_Money,
        'color': Color.fromRGBO(247, 148, 29, 1),
      },
       {
        'image': 'assets/Payment/shopee_pay.png',
        'name': AppLocalizations.of(context)!.shopee_Pay,
        'color': Color.fromRGBO(237, 99, 46, 1),
      },
       {
        'image': 'assets/Payment/rabbit.png',
        'name': AppLocalizations.of(context)!.rabbit,
        'color': Color.fromRGBO(0, 193, 62, 1),
      },
      {
        'image': 'assets/Payment/wechat.png',
        'name': AppLocalizations.of(context)!.weChat,
        'color': Color.fromRGBO(12, 201, 2, 1),
      },
      {
        'image': 'assets/Payment/alipay.png',
        'name': AppLocalizations.of(context)!.ali_Pay,
        'color': Color.fromRGBO(22, 119, 225, 1),
      },
       {
        'image': 'assets/Payment/cash.png',
        'name': AppLocalizations.of(context)!.cash,
        'color': Color.fromRGBO(109, 110, 113, 1),
      },
    ];
  }
}
