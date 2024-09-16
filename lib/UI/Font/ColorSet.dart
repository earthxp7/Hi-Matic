import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextStyle Fonts(
    BuildContext context, double sizeFont, bool check_bold, Color color) {
  final sizeWidth = MediaQuery.of(context).size.width;
  return TextStyle(
      fontSize: sizeWidth * sizeFont,
      fontFamily: 'SukhumvitSet-Medium',
      fontWeight: check_bold == true ? FontWeight.bold : null,
      color: color);
}
